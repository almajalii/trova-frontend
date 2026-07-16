import 'package:flutter/material.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/features/onboarding/presentation/widgets/dot_inidcator.dart';

class WelcomeLayout extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final VoidCallback onLogin;
  final VoidCallback onSignup;

  const WelcomeLayout({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    required this.onLogin,
    required this.onSignup,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.horizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surfaceContainerHighest,
            ),
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary,
                ),
                child: Icon(Icons.check, color: colors.onPrimary, size: 44),
              ),
            ),
          ),

          SizedBox(height: context.vertical),

          AppTitle(
            title: "You're all set",
            size: 22,
            weight: FontWeight.bold,
            titleColor: colors.onSurface,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          AppText(
            text: 'Create an account or sign in to start scoring contractors and issuing guarantees.',
            textSize: 15,
            textColor: colors.onSurfaceVariant,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: context.vertical),

          DotsIndicator(
            itemCount: itemCount,
            currentIndex: currentIndex,
            activeColor: colors.primary,
            inactiveColor: colors.surfaceContainerHighest,
          ),

          SizedBox(height: context.vertical),

          Button(
            text: 'Sign Up',
            textColor: colors.onPrimary,
            borderRadius: 12,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            elevation: 0,
            buttonWidth: context.buttonSize,
            buttonHeight: context.buttonSizeH,
            onPressed: onSignup,
          ),

          const SizedBox(height: 12),

          Button(
            text: 'Sign In',
            buttonColor: colors.surface,
            textColor: colors.primary,
            borderColor: colors.primary,
            borderRadius: 12,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            elevation: 0,
            buttonWidth: context.buttonSize,
            buttonHeight: context.buttonSizeH,
            onPressed: onLogin,
          ),
        ],
      ),
    );
  }
}