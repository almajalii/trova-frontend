import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/bank-connection/presentation/screens/connect_bank_account_screen.dart';
import 'package:trova/features/company-details/logic/company_details_model.dart';
import 'package:trova/features/company-details/logic/company_details_service.dart';
import 'package:trova/features/company-details/presentation/bloc/company_details_bloc.dart';
import 'package:trova/features/company-details/presentation/bloc/company_details_event.dart';
import 'package:trova/features/company-details/presentation/bloc/company_details_state.dart';
import 'package:trova/features/company-details/presentation/widget/company_details_layout.dart';

class CompanyDetailsScreen extends StatefulWidget {
  /// Called once company details are saved successfully. Defaults to
  /// pushing ConnectBankAccountScreen (the next step in the onboarding
  /// chain) if not provided.
  final VoidCallback? onSaved;

  const CompanyDetailsScreen({super.key, this.onSaved});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _sectorController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _yearsInOperationController = TextEditingController();
  final _teamSizeController = TextEditingController();
  final _annualRevenueController = TextEditingController();

  @override
  void dispose() {
    _companyNameController.dispose();
    _sectorController.dispose();
    _registrationNumberController.dispose();
    _yearsInOperationController.dispose();
    _teamSizeController.dispose();
    _annualRevenueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => CompanyDetailsBloc(companyDetailsService: sl<CompanyDetailsService>()),
        child: BlocConsumer<CompanyDetailsBloc, CompanyDetailsState>(
          listener: (context, state) {
            if (state is CompanyDetailsError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is CompanyDetailsSuccess) {
              if (widget.onSaved != null) {
                widget.onSaved!.call();
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ConnectBankAccountScreen()),
                );
              }
            }
          },
          builder: (context, state) {
            final isLoading = state is CompanyDetailsLoading;
            return CompanyDetailsLayout(
              formKey: _formKey,
              companyNameController: _companyNameController,
              sectorController: _sectorController,
              registrationNumberController: _registrationNumberController,
              yearsInOperationController: _yearsInOperationController,
              teamSizeController: _teamSizeController,
              annualRevenueController: _annualRevenueController,
              isLoading: isLoading,
              onBack: () => Navigator.of(context).maybePop(),
              onSubmit: () {
                if (_formKey.currentState!.validate()) {
                  final draft = CompanyDetailsDraft(
                    companyName: _companyNameController.text.trim(),
                    sector: _sectorController.text.trim(),
                    registrationNumber: _registrationNumberController.text.trim(),
                    yearsInOperation: int.tryParse(_yearsInOperationController.text) ?? 0,
                    teamSize: int.tryParse(_teamSizeController.text) ?? 0,
                    annualRevenueJod: double.tryParse(_annualRevenueController.text) ?? 0,
                  );
                  context.read<CompanyDetailsBloc>().add(CompanyDetailsSubmitted(draft: draft));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
