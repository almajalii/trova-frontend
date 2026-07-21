import 'package:flutter/material.dart';
import 'package:trova/features/browse-project/logic/browseproj_model.dart';
import 'package:trova/features/browse-project/presentation/widget/project_card.dart';

class ProjectsListView extends StatelessWidget {
  final List<ProjectModel> projects;
  final ValueChanged<ProjectModel> onBidTap;

  const ProjectsListView({
    super.key,
    required this.projects,
    required this.onBidTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return ProjectCardbrowse(
          project: project,
          onBidTap: () => onBidTap(project),
        );
      },
    );
  }
}