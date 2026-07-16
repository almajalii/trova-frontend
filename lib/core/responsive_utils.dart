


import 'package:flutter/material.dart';


extension FitContext on BuildContext {
  double get screenWidth  => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get buttonSize   => screenWidth * 0.7;
  double get buttonSizeH  => screenHeight * 0.06;
  double get horizontal   => screenWidth * 0.09;//space
  double get vertical     => screenHeight * 0.06;//space
}