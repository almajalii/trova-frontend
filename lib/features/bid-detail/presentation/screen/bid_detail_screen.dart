// lib/features/biddetail/presentation/bid_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/bid-detail/logic/bid_detail_service.dart';
import 'package:trova/features/bid-detail/logic/bide_detail_model.dart';
import 'package:trova/features/bid-detail/presentation/bloc/bid_detail_bloc.dart';
import 'package:trova/features/bid-detail/presentation/bloc/bid_detail_event.dart';
import 'package:trova/features/bid-detail/presentation/bloc/bid_detail_state.dart';
import 'package:trova/features/bid-detail/presentation/widget/detail_info_card.dart';
import 'package:trova/features/bid-detail/presentation/widget/status_timeline.dart';
import 'package:trova/features/mybids/logic/mybid_service.dart';
import 'package:trova/features/mybids/presentation/screen/bid_action_confirmation_screens.dart';
import 'package:trova/features/guarantees/logic/guarantee_service.dart';
import 'package:trova/features/guarantees/presentation/bloc/guarantee_bloc.dart';
import 'package:trova/features/guarantees/presentation/bloc/guarantee_event.dart';
import 'package:trova/features/guarantees/presentation/screens/gaurantee_request_screen.dart';

class BidDetailScreen extends StatelessWidget {
  final String bidId;
  const BidDetailScreen({super.key, required this.bidId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BidDetailBloc(service: sl<BidDetailService>())..add(FetchBidDetail(bidId)),
      child: _BidDetailView(bidId: bidId),
    );
  }
}

class _BidDetailView extends StatefulWidget {
  final String bidId;
  const _BidDetailView({required this.bidId});

  @override
  State<_BidDetailView> createState() => _BidDetailViewState();
}

class _BidDetailViewState extends State<_BidDetailView> {
  bool _isSubmitting = false;

  _StatusStyle _styleFor(String status) {
    switch (status) {
      case 'pending':
        return _StatusStyle('Pending', const Color(0xFFFCEFD8), const Color(0xFFB8760B));
      case 'selected':
        return _StatusStyle('Selected', const Color(0xFFDFF3E3), const Color(0xFF1E8E3E));
      case 'confirmed':
        return _StatusStyle('Confirmed', const Color(0xFFDFF3E3), const Color(0xFF1E8E3E));
      case 'guaranteePendingReview':
        return _StatusStyle('Pending Bank Review', const Color(0xFFFCEFD8), const Color(0xFFB8760B));
      case 'guaranteeIssued':
        return _StatusStyle('Awaiting Owner Confirmation', const Color(0xFFFCEFD8), const Color(0xFFB8760B));
      case 'inProgress':
        return _StatusStyle('In Progress', const Color(0xFFDFF3E3), const Color(0xFF1E8E3E));
      case 'workSubmitted':
        return _StatusStyle('Awaiting Owner Review', const Color(0xFFDFF3E3), const Color(0xFF1E8E3E));
      case 'guaranteeRejected':
        return _StatusStyle('Guarantee Rejected', const Color(0xFFFDE8E8), const Color(0xFFC82333));
      case 'rejected':
        return _StatusStyle('Rejected', const Color(0xFFF1F1F1), const Color(0xFF5F6368));
      case 'completed':
        return _StatusStyle('Completed', const Color(0xFFDFF3E3), const Color(0xFF1E8E3E));
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

                  if ((detail.status == 'inProgress' || detail.status == 'workSubmitted') &&
                      detail.guaranteeExpiresInDays != null)
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

                  if (detail.status == 'completed' && detail.reviewText != null) ...[
                    AppText(
                      text: 'Review Received',
                      fontWeight: FontWeight.w600,
                      textSize: 15,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colors.surfaceBright),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: detail.companyName,
                                textSize: 13,
                                fontWeight: FontWeight.w600,
                                textColor: colors.onSurface,
                              ),
                              if (detail.reviewRating != null)
                                AppText(
                                  text: '★' * detail.reviewRating! + '☆' * (5 - detail.reviewRating!),
                                  textSize: 13,
                                  textColor: const Color(0xFFB8760B),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          AppText(
                            text: '"${detail.reviewText!}"',
                            textSize: 12,
                            textColor: colors.secondary.withValues(alpha: 0.7),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],

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
      case 'selected':
        return Row(
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
                onPressed: _isSubmitting ? null : () => _backOff(context, detail),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Button(
                text: 'Confirm',
                textColor: colors.onPrimary,
                borderRadius: 12,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                buttonWidth: double.infinity,
                buttonHeight: 44,
                elevation: 0,
                onPressed: _isSubmitting ? null : () => _confirmBid(context, detail.id),
              ),
            ),
          ],
        );

      case 'confirmed':
        return Column(
          children: [
            Button(
              text: 'Apply for Guarantee',
              textColor: colors.onPrimary,
              borderRadius: 12,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              buttonWidth: double.infinity,
              buttonHeight: 44,
              elevation: 0,
              onPressed: _isSubmitting ? null : () => _openGuaranteeRequest(context, detail.projectId),
            ),
            const SizedBox(height: 12),
            Button(
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
              onPressed: _isSubmitting ? null : () => _backOff(context, detail),
            ),
          ],
        );

      case 'inProgress':
        return Column(
          children: [
            Button(
              text: 'Mark Work as Done',
              textColor: colors.onPrimary,
              borderRadius: 12,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              buttonWidth: double.infinity,
              buttonHeight: 44,
              elevation: 0,
              onPressed: _isSubmitting ? null : () => _markWorkAsDone(context, detail),
            ),
            const SizedBox(height: 12),
            Button(
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
              onPressed: _isSubmitting ? null : () => _backOff(context, detail),
            ),
          ],
        );

      case 'workSubmitted':
        return const SizedBox.shrink();

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
                onPressed: _isSubmitting ? null : () => _backOff(context, detail),
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
                onPressed: _isSubmitting ? null : () => _openGuaranteeRequest(context, detail.projectId),
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _confirmBid(BuildContext context, String bidId) =>
      _runAction(context, () => sl<BidsService>().confirmBid(bidId));

  /// Back Off closes the bid and shows the "You've Backed Off" confirmation
  /// (Figma), which then rebuilds the My Bids stack. Gated behind a
  /// confirmation dialog since backing off is irreversible.
  Future<void> _backOff(BuildContext context, BidDetailModel detail) async {
    final confirmed = await _confirmBackOff(context, detail);
    if (!confirmed || !context.mounted) return;
    await _runAction(
      context,
      () => sl<BidsService>().backOff(detail.id),
      confirmation: BackedOffScreen(companyName: detail.companyName),
    );
  }

  /// Wording differs for a still-unawarded 'selected' bid (declining kills
  /// the owner's award and re-opens their project) vs. the post-award
  /// states (backing off just ends the contract).
  Future<bool> _confirmBackOff(BuildContext context, BidDetailModel detail) async {
    final isSelected = detail.status == 'selected';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isSelected ? 'Decline this award?' : 'Back off from ${detail.projectTitle}?'),
        content: Text(
          isSelected
              ? '${detail.companyName} will be notified and the project will be re-opened. This can\'t be undone.'
              : 'This can\'t be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              isSelected ? 'Decline' : 'Back Off',
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  /// Mark Work as Done shows the "Submitted for Review" confirmation
  /// (Figma), which then rebuilds the My Bids stack.
  Future<void> _markWorkAsDone(BuildContext context, BidDetailModel detail) => _runAction(
        context,
        () => sl<BidsService>().markWorkAsDone(detail.id),
        confirmation: WorkSubmittedScreen(companyName: detail.companyName),
      );

  /// Runs a bid action against the shared BidsService. On success, either
  /// pushes the given confirmation screen (Figma back-off / work-done flows)
  /// or pops back to My Bids with a result flag so the list refreshes.
  Future<void> _runAction(
    BuildContext context,
    Future<List<dynamic>> Function() action, {
    Widget? confirmation,
  }) async {
    setState(() => _isSubmitting = true);
    try {
      await action();
      if (!context.mounted) return;
      if (confirmation != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => confirmation));
      } else {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!context.mounted) return;
      final message = e is ApiException ? e.message : e.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _openGuaranteeRequest(BuildContext context, String projectId) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => GuaranteeRequestBloc(sl<GuaranteeService>())
          ..add(GuaranteePrefillRequested(projectId)),
        child: const GuaranteeRequestScreen(),
      ),
    )).then((_) {
      if (context.mounted) {
        context.read<BidDetailBloc>().add(FetchBidDetail(widget.bidId));
      }
    });
  }
}

class _StatusStyle {
  final String label;
  final Color bg;
  final Color text;
  const _StatusStyle(this.label, this.bg, this.text);
}
