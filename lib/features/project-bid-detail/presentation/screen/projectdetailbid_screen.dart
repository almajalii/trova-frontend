import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/capability-score/logic/capability_score_service.dart';
import 'package:trova/features/project-bid-detail/logic/projectdetailbid_service.dart';
import 'package:trova/features/project-bid-detail/presentation/bloc/projectdetailbid_bloc.dart';
import 'package:trova/features/project-bid-detail/presentation/bloc/projectdetailbid_event.dart';
import 'package:trova/features/project-bid-detail/presentation/widget/projectdetiailbid_layout.dart';

class ProjectDetailScreen extends StatelessWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectBidDetailBloc(
        service: sl<ProjectBidDetailService>(),
        capabilityScoreService: sl<CapabilityScoreService>(),
      )..add(LoadProjectDetail(projectId)),
      child: const ProjectDetailLayout(),
    );
  }
}
