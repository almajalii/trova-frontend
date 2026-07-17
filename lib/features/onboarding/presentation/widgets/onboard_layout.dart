import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/features/onboarding/logic/onboard_model.dart';
import 'package:trova/features/onboarding/presentation/widgets/dot_inidcator.dart';

class OnboardLayout extends StatelessWidget {
  final OnboardingItem page;
  final int currentIndex;
  final int itemCount;
  final VoidCallback onNext;

  const OnboardLayout({
    super.key,
    required this.page,
    required this.currentIndex,
    required this.itemCount,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.horizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            page.imagePath,
            height: 280,
            fit: BoxFit.contain,
          ),

          SizedBox(height: context.vertical),

          AppTitle(
            title: page.title,
            size: 22,
            weight: FontWeight.bold,
            titleColor: colors.onSurface,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          AppText(
            text: page.description,
            textSize: 15,
            textColor: const Color.fromARGB(255, 184, 183, 183),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: context.vertical),

          DotsIndicator(
            itemCount: itemCount,
            currentIndex: currentIndex,
            activeColor: colors.primary,
            inactiveColor: colors.onPrimary,
          ),

          SizedBox(height: context.vertical),

          Button(
            text: 'Next',
            textColor: colors.onSecondary,
            borderRadius: 12,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            elevation: 4,
            buttonWidth: context.buttonSize,
            buttonHeight: context.buttonSizeH,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}