// lib/features/biddetail/presentation/bid_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/bid-detail/logic/bid_detail_service.dart';
import 'package:trova/features/bid-detail/logic/bide_detail_model.dart';
import 'package:trova/features/bid-detail/presentation/bloc/bid_detail_bloc.dart';
import 'package:trova/features/bid-detail/presentation/bloc/bid_detail_event.dart';
import 'package:trova/features/bid-detail/presentation/bloc/bid_detail_state.dart';
import 'package:trova/features/bid-detail/presentation/widget/detail_info_card.dart';
import 'package:trova/features/bid-detail/presentation/widget/status_timeline.dart';


class BidDetailScreen extends StatelessWidget {
  final String bidId;
  const BidDetailScreen({super.key, required this.bidId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BidDetailBloc(service: sl<BidDetailService>())..add(FetchBidDetail(bidId)),
      child: const _BidDetailView(),
    );
  }
}

class _BidDetailView extends StatelessWidget {
  const _BidDetailView();

  _StatusStyle _styleFor(String status) {
    switch (status) {
      case 'pending':
        return _StatusStyle('Pending', const Color(0xFFFCEFD8), const Color(0xFFB8760B));
      case 'confirmed':
        return _StatusStyle('Confirmed', const Color(0xFFDFF3E3), const Color(0xFF1E8E3E));
      case 'inProgress':
        return _StatusStyle('In Progress', const Color(0xFFDFF3E3), const Color(0xFF1E8E3E));
      case 'guaranteeRejected':
        return _StatusStyle('Guarantee Rejected', const Color(0xFFFDE8E8), const Color(0xFFC82333));
      case 'rejected':
        return _StatusStyle('Rejected', const Color(0xFFF1F1F1), const Color(0xFF5F6368));
      default:
        return _StatusStyle(status, const Color(0xFFDFF3E3), const Color(0xFF1E8E3E));
    }
  }

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
            final style = _styleFor(detail.status);

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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppText(
                          text: detail.projectTitle,
                          fontWeight: FontWeight.bold,
                          textSize: 20,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: style.bg, borderRadius: BorderRadius.circular(20)),
                        child: AppText(text: style.label, textSize: 12, fontWeight: FontWeight.w600, textColor: style.text),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    text: detail.companyName,
                    textSize: 13,
                    textColor: colors.secondary.withValues(alpha: 0.6),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 16),

                  DetailInfoCard(rows: [
                    MapEntry('Sector', detail.sector),
                    MapEntry('Location', detail.location),
                    MapEntry('Contract Value', 'JOD ${detail.contractValue.toStringAsFixed(0)}'),
                    MapEntry('Timeline', detail.timelineRange),
                    if (detail.milestones != null) MapEntry('Milestones', detail.milestones!),
                    if (detail.guaranteeTypeRequired != null)
                      MapEntry('Guarantee Type Required', detail.guaranteeTypeRequired!),
                    if (detail.paymentTerms != null) MapEntry('Payment Terms', detail.paymentTerms!),
                    MapEntry('Your Bid Amount', 'JOD ${detail.bidAmount.toStringAsFixed(0)}'),
                    MapEntry('Project ID', detail.projectId),
                  ]),

                  const SizedBox(height: 20),

                  AppText(
                    text: 'Status Timeline',
                    fontWeight: FontWeight.w600,
                    textSize: 15,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 8),

                  StatusTimeline(steps: detail.statusSteps),

                  const SizedBox(height: 16),

                  if (detail.bannerNote != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDE8E8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AppText(
                        text: detail.bannerNote!,
                        textSize: 12,
                        textColor: const Color(0xFFC82333),
                        textAlign: TextAlign.start,
                      ),
                    ),

                  if (detail.status == 'inProgress' && detail.guaranteeExpiresInDays != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFF3E3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: 'Your Guarantee: Active',
                            textSize: 12,
                            fontWeight: FontWeight.w600,
                            textColor: const Color(0xFF1E8E3E),
                          ),
                          AppText(
                            text: 'Expires in ${detail.guaranteeExpiresInDays} days',
                            textSize: 12,
                            textColor: const Color(0xFF1E8E3E),
                          ),
                        ],
                      ),
                    ),

                  _buildActions(context, detail, colors),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, BidDetailModel detail, ColorScheme colors) {
    switch (detail.status) {
      case 'confirmed':
        return Button(
          text: 'Apply for Guarantee',
          textColor: colors.onPrimary,
          borderRadius: 12,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          buttonWidth: double.infinity,
          buttonHeight: 44,
          elevation: 0,
          onPressed: () {
            // TODO: dispatch ApplyForGuarantee via BidsBloc / repository
          },
        );

      case 'inProgress':
        return Button(
          text: 'Mark Work as Done',
          textColor: colors.onPrimary,
          borderRadius: 12,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          buttonWidth: double.infinity,
          buttonHeight: 44,
          elevation: 0,
          onPressed: () {
            // TODO: dispatch MarkWorkAsDone via BidsBloc / repository
          },
        );

      case 'guaranteeRejected':
        return Row(
          children: [
            Expanded(
              child: Button(
                text: 'Back Off',
                buttonColor: colors.surface,
                textColor: colors.primary,
                borderColor: colors.primary,
                borderRadius: 12,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                buttonWidth: double.infinity,
                buttonHeight: 44,
                elevation: 0,
                onPressed: () {
                  // TODO: dispatch BackOff via BidsBloc / repository
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Button(
                text: 'Apply for New Guarantee',
                textColor: colors.onPrimary,
                borderRadius: 12,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                buttonWidth: double.infinity,
                buttonHeight: 44,
                elevation: 0,
                onPressed: () {
                  // TODO: dispatch ApplyForNewGuarantee via BidsBloc / repository
                },
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

class _StatusStyle {
  final String label;
  final Color bg;
  final Color text;
  const _StatusStyle(this.label, this.bg, this.text);
}