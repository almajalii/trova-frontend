import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/project-bid-detail/logic/projectdetailbid_model.dart';
import 'package:trova/features/project-bid-detail/logic/projectdetailbid_service.dart';
import 'package:trova/features/project-bid-detail/presentation/bloc/projectdetailbid_bloc.dart';
import 'package:trova/features/project-bid-detail/presentation/widget/projectdetiailbid_layout.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectBidDetailBloc(
        service: ProjectBidDetailService(),
        project: project,
      ),
      child: const ProjectDetailLayout(),
    );
  }
}