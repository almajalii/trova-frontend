import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trova/core/app_text.dart';

class Button extends StatelessWidget {
  final Color? buttonColor;
  final Color textColor;
  final double borderRadius;
  final double fontSize;
  final FontWeight? fontWeight;
  final String text;
  final double elevation;
  final String? iconPath;
  final String? svgIconPath;
  final VoidCallback? onPressed;
  final double buttonWidth;
  final double buttonHeight;
  final bool isText;
  final Color? borderColor; // NEW

  const Button({
    super.key,
    this.buttonColor,
    required this.textColor,
    required this.borderRadius,
    required this.fontSize,
    required this.text,
    this.iconPath,
    this.svgIconPath,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.fontWeight,
    required this.elevation,
    this.isText = false,
    this.onPressed,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final label = AppText(text: text, fontWeight: fontWeight, textSize: fontSize, textColor: textColor);

    if (isText) {
      return GestureDetector(onTap: onPressed, child: label);
    }

    return Center(
      child: Material(
        color: buttonColor ?? colors.primary,
        borderRadius: BorderRadius.circular(borderRadius),
        elevation: elevation,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: buttonWidth,
            height: buttonHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: borderColor != null ? Border.all(color: borderColor!, width: 1.5) : null,
            ),
            child: svgIconPath != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [SvgPicture.asset(svgIconPath!, width: 18, height: 18), const SizedBox(width: 8), label],
                  )
                : iconPath != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(iconPath!, width: 18, height: 18), const SizedBox(width: 8), label],
                  )
                : Center(child: label),
          ),
        ),
      ),
    );
  }
}
