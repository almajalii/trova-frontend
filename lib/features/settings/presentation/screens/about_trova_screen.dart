import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/responsive_utils.dart';

class AboutTrovaScreen extends StatelessWidget {
  const AboutTrovaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.horizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.vertical),
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: Icon(Icons.arrow_back, color: colors.onSurface),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.primaryTint, borderRadius: BorderRadius.circular(18)),
                  child: Text(
                    'T',
                    style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w800, fontSize: 30, color: colors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: AppTitle(title: 'Trova', size: 22, weight: FontWeight.w700, titleColor: colors.onSurface, textAlign: TextAlign.center),
              ),
              const SizedBox(height: 6),
              Center(
                child: AppText(text: 'Version 1.0.0', textSize: 13, textColor: colors.onSurfaceVariant, textAlign: TextAlign.center),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: AppText(
                  text:
                      'Trova connects contractors with construction projects, backed by a transparent capability score and bank-guaranteed bidding.',
                  textSize: 14,
                  textColor: colors.onSurfaceVariant,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
