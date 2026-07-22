import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/mybids/logic/mybid_model.dart';
import 'package:trova/features/mybids/logic/mybid_service.dart';
import 'package:trova/features/mybids/presentation/bloc/mybids_bloc.dart';
import 'package:trova/features/mybids/presentation/bloc/mybids_event.dart';
import 'package:trova/features/mybids/presentation/bloc/mybids_state.dart';
import 'package:trova/features/mybids/presentation/widget/mybids_card.dart';

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: colors.onSurface),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE8E8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // TODO: navigate to bids history screen
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
                            b.status == 'inProgress' ||
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
        bloc.add(ApplyForGuarantee(bid.id));
        break;
      case 'inProgress':
        bloc.add(MarkWorkAsDone(bid.id));
        break;
      case 'guaranteeRejected':
        bloc.add(ApplyForNewGuarantee(bid.id));
        break;
      default:
        break;
    }
  }

  void _onSecondaryAction(BuildContext context, BidModel bid) {
    final bloc = context.read<BidsBloc>();
    switch (bid.status) {
      case 'selected':
        bloc.add(CancelBid(bid.id));
        break;
      case 'guaranteeRejected':
        bloc.add(BackOff(bid.id));
        break;
      default:
        break;
    }
  }
}