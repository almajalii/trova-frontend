// lib/features/biddetail/presentation/contract_agreement_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/bid-detail/logic/bid_detail_service.dart';
import 'package:trova/features/bid-detail/presentation/bloc/bid_detail_bloc.dart';
import 'package:trova/features/bid-detail/presentation/bloc/bid_detail_event.dart';
import 'package:trova/features/bid-detail/presentation/bloc/bid_detail_state.dart';
import 'package:trova/features/bid-detail/presentation/widget/detail_info_card.dart';
import 'package:trova/features/bid-detail/presentation/widget/status_timeline.dart';

class ContractAgreementScreen extends StatelessWidget {
  final String bidId;
  const ContractAgreementScreen({super.key, required this.bidId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BidDetailBloc(service: sl<BidDetailService>())..add(FetchBidDetail(bidId)),
      child: const _ContractAgreementView(),
    );
  }
}

class _ContractAgreementView extends StatelessWidget {
  const _ContractAgreementView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: BlocBuilder<BidDetailBloc, BidDetailState>(
          builder: (context, state) {
            if (state is BidDetailInitial || state is BidDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is BidDetailError) {
              return Center(child: AppText(text: state.message));
            }

            final detail = (state as BidDetailSuccess).detail;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  const SizedBox(height: 8),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: colors.onSurface),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  const SizedBox(height: 8),

                  AppText(
                    text: "You've Been Selected!",
                    fontWeight: FontWeight.bold,
                    textSize: 20,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 6),
                  AppText(
                    text:
                        '${detail.companyName} has selected you for this project. Review the full contract details before accepting.',
                    textSize: 13,
                    textColor: colors.secondary.withValues(alpha: 0.6),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 16),

                  DetailInfoCard(rows: [
                    MapEntry('Project', detail.projectTitle),
                    MapEntry('Sector', detail.sector),
                    MapEntry('Location', detail.location),
                    MapEntry('Contract Value', 'JOD ${detail.contractValue.toStringAsFixed(0)}'),
                    MapEntry('Timeline', detail.timelineRange),
                    if (detail.milestones != null) MapEntry('Milestones', detail.milestones!),
                    if (detail.guaranteeTypeRequired != null)
                      MapEntry('Guarantee Type Required', detail.guaranteeTypeRequired!),
                    if (detail.paymentTerms != null) MapEntry('Payment Terms', detail.paymentTerms!),
                  ]),

                  const SizedBox(height: 20),
                  AppText(text: 'Status Timeline', fontWeight: FontWeight.w600, textSize: 15, textAlign: TextAlign.start),
                  const SizedBox(height: 8),
                  StatusTimeline(steps: detail.statusSteps),

                  if (detail.description != null) ...[
                    const SizedBox(height: 20),
                    AppText(text: 'Description', fontWeight: FontWeight.w600, textSize: 15, textAlign: TextAlign.start),
                    const SizedBox(height: 6),
                    AppText(
                      text: detail.description!,
                      textSize: 13,
                      textColor: colors.secondary.withValues(alpha: 0.7),
                      textAlign: TextAlign.start,
                    ),
                  ],

                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE8E8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AppText(
                      text:
                          'By accepting, you agree to deliver the project under these terms and confirm you will apply for the required bank guarantee.',
                      textSize: 12,
                      textColor: const Color(0xFFC82333),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Button(
                          text: 'Decline',
                          buttonColor: colors.surface,
                          textColor: colors.primary,
                          borderColor: colors.primary,
                          borderRadius: 12,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          buttonWidth: double.infinity,
                          buttonHeight: 44,
                          elevation: 0,
                          onPressed: () {
                            // TODO: dispatch CancelBid via BidsBloc / repository
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Button(
                          text: 'Agree & Accept',
                          textColor: colors.onPrimary,
                          borderRadius: 12,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          buttonWidth: double.infinity,
                          buttonHeight: 44,
                          elevation: 0,
                          onPressed: () {
                            // TODO: dispatch ConfirmBid via BidsBloc / repository
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}