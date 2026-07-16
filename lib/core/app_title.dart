import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';

class AppTitle extends StatelessWidget {
  
  final String title;
  final double size;
  final TextAlign? textAlign;
  final FontWeight weight;
  final  Color titleColor;

  const AppTitle({
  super.key,
  required this.size,
  required this.title,
  required this.weight,
  required this.titleColor,
  required this.textAlign,

  });

  @override 
  Widget build (BuildContext context)
  {
    return AppText(text:title,
      textSize: size,
      fontWeight: weight,
      textColor: titleColor,
      textAlign: textAlign ?? TextAlign.start
    );
  }
}