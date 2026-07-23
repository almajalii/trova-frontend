import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/bank-connection/logic/bank_connection_model.dart';
import 'package:trova/features/bank-connection/logic/bank_connection_service.dart';
import 'package:trova/features/bank-connection/presentation/bloc/bank_connection_bloc.dart';
import 'package:trova/features/bank-connection/presentation/bloc/bank_connection_event.dart';
import 'package:trova/features/bank-connection/presentation/bloc/bank_connection_state.dart';
import 'package:trova/features/bank-connection/presentation/screens/bank_connected_screen.dart';
import 'package:trova/features/bank-connection/presentation/widget/bank_consent_modal.dart';
import 'package:trova/features/bank-connection/presentation/widget/connect_bank_layout.dart';

class ConnectBankAccountScreen extends StatelessWidget {
  const ConnectBankAccountScreen({super.key});

  Future<void> _openConsentModal(BuildContext context, BankOption bank) async {
    bool isAuthorizing = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return BankConsentModal(
              bank: bank,
              isAuthorizing: isAuthorizing,
              onCancel: () => Navigator.of(sheetContext).pop(),
              onAuthorize: (remainingDebtCapacityJod, numberOfDelinquentDebts, numberOfCurrentDebts) async {
                setSheetState(() => isAuthorizing = true);
                try {
                  final bankName = await sl<BankConnectionService>().connect(
                    bankCode: bank.code,
                    remainingDebtCapacityJod: remainingDebtCapacityJod,
                    numberOfDelinquentDebts: numberOfDelinquentDebts,
                    numberOfCurrentDebts: numberOfCurrentDebts,
                  );
                  if (!sheetContext.mounted) return;
                  Navigator.of(sheetContext).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => BankConnectedScreen(bankName: bankName)));
                } on ApiException catch (e) {
                  setSheetState(() => isAuthorizing = false);
                  if (sheetContext.mounted) {
                    ScaffoldMessenger.of(sheetContext).showSnackBar(SnackBar(content: Text(e.message)));
                  }
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => BankConnectionBloc(bankConnectionService: sl<BankConnectionService>())..add(const BankConnectionStarted()),
        child: BlocConsumer<BankConnectionBloc, BankConnectionState>(
          listener: (context, state) {
            if (state is BankConnectionError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is BankConnectionLoading || state is BankConnectionInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is BankConnectionError) {
              return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(state.message, textAlign: TextAlign.center)));
            }
            final banks = (state as BankConnectionLoaded).banks;
            return ConnectBankLayout(
              banks: banks,
              onBack: () => Navigator.of(context).maybePop(),
              onBankTap: (bank) => _openConsentModal(context, bank),
            );
          },
        ),
      ),
    );
  }
}
