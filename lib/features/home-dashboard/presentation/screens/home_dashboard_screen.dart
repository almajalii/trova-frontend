import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/success_badge.dart';
import 'package:trova/features/browse-project/presentation/screen/browseproj_screen.dart';
import 'package:trova/features/capability-score/presentation/screens/my_score_screen.dart';
import 'package:trova/features/home-dashboard/logic/home_dashboard_service.dart';
import 'package:trova/features/home-dashboard/presentation/bloc/home_dashboard_bloc.dart';
import 'package:trova/features/home-dashboard/presentation/bloc/home_dashboard_event.dart';
import 'package:trova/features/home-dashboard/presentation/bloc/home_dashboard_state.dart';
import 'package:trova/features/home-dashboard/presentation/widget/home_dashboard_layout.dart';
import 'package:trova/features/post-project/presentation/screens/post_a_project_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) =>
            HomeDashboardBloc(homeDashboardService: sl<HomeDashboardService>())..add(const HomeDashboardStarted()),
        child: BlocConsumer<HomeDashboardBloc, HomeDashboardState>(
          listener: (context, state) {
            if (state is HomeDashboardError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is HomeDashboardLoading || state is HomeDashboardInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeDashboardError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(state.message, textAlign: TextAlign.center),
                ),
              );
            }
            final summary = (state as HomeDashboardLoaded).summary;
            return HomeDashboardLayout(
              summary: summary,
              onViewScoreBreakdown: () =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyScoreScreen())),
              onBrowseProjects: () =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BrowseProjectsScreen())),
              onPostProject: () =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PostAProjectScreen())),
              onNotifications: () {
                // TODO: wire to Notifications screen once it's built (flagged as "remaining").
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const TrovaBottomNav(activeIndex: 0),
    );
  }
}
