import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

String formatNumber(num number){
  final formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 0,
  );

  return formatter.format(number);
}

Color getRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

bool isMobileDevice(BuildContext context){
  return MediaQuery.sizeOf(context).width < 700;
}