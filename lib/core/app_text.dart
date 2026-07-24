import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppText extends StatelessWidget {
  final String text;
  final double? textSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText(  {
    super.key,
    required this.text,
    this.fontWeight,
    this.textSize,
    this.textColor,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.center,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.inter(
        fontSize: textSize,
        fontWeight: fontWeight,
        color: textColor ?? colors.onSurface,
      ),
    );
  }
}