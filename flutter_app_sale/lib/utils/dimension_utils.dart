import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class DimensionUtils {
  static double getWidthScreen(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeightScreen(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double paddingWithDivideNumber(BuildContext context, [int divideNumber = 20]) {
    return MediaQuery.of(context).size.width / divideNumber;
  }

  static double paddingHeightDivideNumber(BuildContext context, [int divideNumber = 20]) {
    return MediaQuery.of(context).size.height / divideNumber;
  }

  static double marginWithDivideNumber(BuildContext context, [int divideNumber = 20]) {
    return MediaQuery.of(context).size.width / divideNumber;
  }

  static double marginHeightDivideNumber(BuildContext context, [int divideNumber = 20]) {
    return MediaQuery.of(context).size.height / divideNumber;
  }
}