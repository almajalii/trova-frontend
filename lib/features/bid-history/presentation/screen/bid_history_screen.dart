import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/bid-detail/presentation/screen/bid_detail_screen.dart';
import 'package:trova/features/bid-history/logic/bid_history_service.dart';
import 'package:trova/features/bid-history/presentation/bloc/bid_history_bloc.dart';
import 'package:trova/features/bid-history/presentation/bloc/bid_history_event.dart';
import 'package:trova/features/bid-history/presentation/bloc/bid_history_state.dart';
import 'package:trova/features/bid-history/presentation/widget/bid_history_card.dart';

class BidHistoryScreen extends StatelessWidget {
  const BidHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BidHistoryBloc(service: sl<BidHistoryService>())..add(const FetchBidHistory()),
      child: const _BidHistoryView(),
    );
  }
}

class _BidHistoryView extends StatelessWidget {
  const _BidHistoryView();

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
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: colors.onSurface),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 8),
              AppTitle(
                title: 'History',
                size: 24,
                weight: FontWeight.bold,
                titleColor: colors.onSurface,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 4),
              AppText(
                text: 'Completed and closed bids, including reviews you received.',
                textSize: 13,
                textColor: colors.secondary.withValues(alpha: 0.6),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<BidHistoryBloc, BidHistoryState>(
                  builder: (context, state) {
                    if (state is BidHistoryInitial || state is BidHistoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is BidHistoryError) {
                      return Center(child: AppText(text: state.message));
                    }

                    final bids = (state as BidHistorySuccess).bids;
                    if (bids.isEmpty) {
                      return Center(
                        child: AppText(
                          text: 'No closed bids yet.',
                          textSize: 13,
                          textColor: colors.secondary.withValues(alpha: 0.6),
                        ),
                      );
                    }

                    return ListView(
                      children: [
                        ...bids.map((bid) => BidHistoryCard(
                              bid: bid,
                              // Backed-off bids have no detail screen in the
                              // flow (the bid is closed), so only completed
                              // and rejected navigate through.
                              onTap: bid.status == 'backedOff'
                                  ? null
                                  : () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BidDetailScreen(bidId: bid.id),
                                        ),
                                      ),
                            )),
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
    );
  }
}
