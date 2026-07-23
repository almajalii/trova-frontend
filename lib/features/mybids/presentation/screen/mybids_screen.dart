import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/success_badge.dart';
import 'package:trova/features/bid-detail/presentation/screen/bid_detail_screen.dart';
import 'package:trova/features/bid-detail/presentation/widget/contract_agreement_screen.dart';
import 'package:trova/features/mybids/logic/mybid_model.dart';
import 'package:trova/features/mybids/logic/mybid_service.dart';
import 'package:trova/features/mybids/presentation/bloc/mybids_bloc.dart';
import 'package:trova/features/mybids/presentation/bloc/mybids_event.dart';
import 'package:trova/features/mybids/presentation/bloc/mybids_state.dart';
import 'package:trova/features/mybids/presentation/screen/bid_action_confirmation_screens.dart';
import 'package:trova/features/mybids/presentation/widget/mybids_card.dart';
import 'package:trova/features/bid-history/presentation/screen/bid_history_screen.dart';
import 'package:trova/features/guarantees/logic/guarantee_service.dart';
import 'package:trova/features/guarantees/presentation/bloc/guarantee_bloc.dart';
import 'package:trova/features/guarantees/presentation/bloc/guarantee_event.dart';
import 'package:trova/features/guarantees/presentation/screens/gaurantee_request_screen.dart';

class MyBidsScreen extends StatelessWidget {
  const MyBidsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BidsBloc(service: sl<BidsService>())..add(const FetchBids()),
      child: const _MyBidsView(),
    );
  }
}

class _MyBidsView extends StatelessWidget {
  const _MyBidsView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE8E8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => const BidHistoryScreen(),
                        ));
                      },
                      child: AppText(
                        text: 'History',
                        textSize: 13,
                        fontWeight: FontWeight.w600,
                        textColor: const Color(0xFFC82333),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              AppTitle(
                title: 'My Bids',
                size: 24,
                weight: FontWeight.bold,
                titleColor: colors.onSurface,
                textAlign: TextAlign.start,
              ),

              const SizedBox(height: 4),

              AppText(
                text: "Track the status of every project you've bid on",
                textSize: 13,
                textColor: colors.secondary.withValues(alpha: 0.6),
                textAlign: TextAlign.start,
              ),

              const SizedBox(height: 16),

              Expanded(
                child: BlocConsumer<BidsBloc, BidsState>(
                  listener: (context, state) {
                    if (state is BidsError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is BidsInitial || state is BidsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is BidsError) {
                      return Center(child: AppText(text: state.message));
                    }

                    final bids = (state as BidsSuccess).bids;

                    final awaiting = bids.where((b) => b.status == 'pending').toList();
                    final selected = bids.where((b) => b.status == 'selected').toList();
                    final inExecution = bids
                        .where((b) =>
                            b.status == 'confirmed' ||
                            b.status == 'guaranteePendingReview' ||
                            b.status == 'guaranteeIssued' ||
                            b.status == 'inProgress' ||
                            b.status == 'workSubmitted' ||
                            b.status == 'guaranteeRejected')
                        .toList();

                    return ListView(
                      children: [
                        if (awaiting.isNotEmpty) ..._buildSection(context, '1. Awaiting Response', awaiting),
                        if (selected.isNotEmpty) ..._buildSection(context, '2. Selected — Action Needed', selected),
                        if (inExecution.isNotEmpty) ..._buildSection(context, '3. In Execution', inExecution),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TrovaBottomNav(activeIndex: 2),
    );
  }

  List<Widget> _buildSection(BuildContext context, String title, List<BidModel> bids) {
    final colors = Theme.of(context).colorScheme;

    return [
      AppText(
        text: title,
        textSize: 13,
        fontWeight: FontWeight.w600,
        textColor: colors.secondary.withValues(alpha: 0.6),
        textAlign: TextAlign.start,
      ),
      const SizedBox(height: 8),
      ...bids.map((bid) => BidCard(
            bid: bid,
            onPrimaryAction: () => _onPrimaryAction(context, bid),
            onSecondaryAction: () => _onSecondaryAction(context, bid),
            onBackOffAction: () => _onBackOffAction(context, bid),
            onTap: () {
              if (bid.status == 'selected') {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => ContractAgreementScreen(bidId: bid.id),
                )).then((_) => context.read<BidsBloc>().add(const FetchBids()));
              } else {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => BidDetailScreen(bidId: bid.id),
                )).then((_) => context.read<BidsBloc>().add(const FetchBids()));
              }
            },
          )),
      const SizedBox(height: 8),
    ];
  }

  void _onPrimaryAction(BuildContext context, BidModel bid) {
    final bloc = context.read<BidsBloc>();
    switch (bid.status) {
      case 'selected':
        bloc.add(ConfirmBid(bid.id));
        break;
      case 'confirmed':
      case 'guaranteeRejected':
        _openGuaranteeRequest(context, bid.projectId);
        break;
      case 'inProgress':
        _runActionWithConfirmation(
          context,
          () => sl<BidsService>().markWorkAsDone(bid.id),
          WorkSubmittedScreen(companyName: bid.companyName),
        );
        break;
      default:
        break;
    }
  }

  /// Runs a bid action directly against BidsService and, on success, shows
  /// the matching Figma confirmation screen ("Submitted for Review" /
  /// "You've Backed Off"). Errors surface via the standard snackbar.
  Future<void> _runActionWithConfirmation(
    BuildContext context,
    Future<List<BidModel>> Function() action,
    Widget confirmation,
  ) async {
    try {
      await action();
      if (!context.mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => confirmation));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _openGuaranteeRequest(BuildContext context, String projectId) {
    final bloc = context.read<BidsBloc>();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => GuaranteeRequestBloc(sl<GuaranteeService>())
          ..add(GuaranteePrefillRequested(projectId)),
        child: const GuaranteeRequestScreen(),
      ),
    )).then((_) => bloc.add(const FetchBids()));
  }

  void _onSecondaryAction(BuildContext context, BidModel bid) {
    switch (bid.status) {
      case 'selected':
        _onBackOffAction(context, bid);
        break;
      default:
        break;
    }
  }

  void _onBackOffAction(BuildContext context, BidModel bid) async {
    switch (bid.status) {
      case 'selected':
      case 'confirmed':
      case 'inProgress':
      case 'guaranteeRejected':
        final confirmed = await _confirmBackOff(context, bid);
        if (!confirmed || !context.mounted) return;
        _runActionWithConfirmation(
          context,
          () => sl<BidsService>().backOff(bid.id),
          BackedOffScreen(companyName: bid.companyName),
        );
        break;
      default:
        break;
    }
  }

  /// Confirms the irreversible back-off / decline action before it's sent.
  /// Wording differs for a still-unawarded 'selected' bid (declining kills
  /// the owner's award and re-opens their project) vs. the post-award states
  /// (backing off just ends the contract).
  Future<bool> _confirmBackOff(BuildContext context, BidModel bid) async {
    final isSelected = bid.status == 'selected';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isSelected ? 'Decline this award?' : 'Back off from ${bid.projectTitle}?'),
        content: Text(
          isSelected
              ? '${bid.companyName} will be notified and the project will be re-opened. This can\'t be undone.'
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
}
