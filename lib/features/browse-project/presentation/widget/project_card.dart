import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/features/browse-project/logic/browseproj_model.dart';

class ProjectCardbrowse extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onBidTap;

  const ProjectCardbrowse({
    super.key,
    required this.project,
    required this.onBidTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.surfaceBright),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppText(
                  text: project.title,
                  fontWeight: FontWeight.bold,
                  textSize: 15,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: 8),
              _Badge(
                text: project.sector,
                backgroundColor: colors.surfaceBright,
                textColor: colors.onSurface,
              ),
            ],
          ),
          const SizedBox(height: 4),
          AppText(
            text: project.postedByCompanyName,
            textSize: 13,
            textColor: colors.onSurfaceVariant,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Badge(
                text: 'JOD ${NumberFormat('#,##0').format(project.contractValueJod)}',
                backgroundColor: colors.primary.withValues(alpha: 0.1),
                textColor: colors.primary,
              ),
              _Badge(
                text: 'Min score ${project.minimumRequiredScore}+',
                backgroundColor: colors.surfaceBright,
                textColor: colors.onSurface,
              ),
              _Badge(
                text: project.daysLeftText,
                backgroundColor: colors.surfaceBright,
                textColor: colors.onSurface,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Button(
            text: 'View & Submit Bid',
            textColor: colors.onPrimary,
            borderRadius: 12,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            buttonWidth: double.infinity,
            buttonHeight: 46,
            elevation: 0,
            onPressed: onBidTap,
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const _Badge({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        text: text,
        textSize: 12,
        fontWeight: FontWeight.w600,
        textColor: textColor,
      ),
    );
  }
}