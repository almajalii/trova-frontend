import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/bidders/logic/bidder_model.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';
import 'package:trova/features/guarantees/logic/guarantee_service.dart';
import 'package:trova/features/guarantees/presentation/bloc/guarantee_bloc.dart';
import 'package:trova/features/guarantees/presentation/bloc/guarantee_event.dart';
import 'package:trova/features/guarantees/presentation/bloc/guarantee_state.dart';
import 'package:trova/features/guarantees/presentation/screens/guarantee_verified_screen.dart';
import 'package:trova/features/guarantees/presentation/widget/award_request_guarantee_layout.dart';

class AwardRequestGuaranteeScreen extends StatefulWidget {
  final String projectId;
  final String projectTitle;
  final Bidder awardedBidder;

  const AwardRequestGuaranteeScreen({
    super.key,
    required this.projectId,
    required this.projectTitle,
    required this.awardedBidder,
  });

  @override
  State<AwardRequestGuaranteeScreen> createState() => _AwardRequestGuaranteeScreenState();
}

class _AwardRequestGuaranteeScreenState extends State<AwardRequestGuaranteeScreen> {
  late final TextEditingController _amountController;
  GuaranteeType _type = GuaranteeType.performance;

  @override
  void initState() {
    super.initState();
    final suggested = (widget.awardedBidder.bidAmountJod * 0.10).round();
    _amountController = TextEditingController(text: '$suggested (10% of contract)');
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double _parsedAmount() {
    final digitsOnly = _amountController.text.replaceAll(RegExp(r'[^0-9.]'), ' ').trim().split(' ').first;
    return double.tryParse(digitsOnly) ?? (widget.awardedBidder.bidAmountJod * 0.10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => GuaranteeBloc(guaranteeService: sl<GuaranteeService>()),
        child: BlocConsumer<GuaranteeBloc, GuaranteeState>(
          listener: (context, state) {
            if (state is GuaranteeError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is GuaranteeSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => GuaranteeVerifiedScreen(guarantee: state.guarantee)),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is GuaranteeLoading;
            return AwardRequestGuaranteeLayout(
              projectTitle: widget.projectTitle,
              awardedCompanyName: widget.awardedBidder.companyName,
              amountController: _amountController,
              type: _type,
              onTypeChanged: (v) => setState(() => _type = v),
              isLoading: isLoading,
              onBack: () => Navigator.of(context).maybePop(),
              onSubmit: () => context.read<GuaranteeBloc>().add(
                    GuaranteeRequested(projectId: widget.projectId, amountJod: _parsedAmount(), type: _type),
                  ),
            );
          },
        ),
      ),
    );
  }
}
