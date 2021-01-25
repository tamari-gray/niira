import 'package:flutter/material.dart';

double sonarTimer({@required DateTime startTime}) {
  final timeNow = DateTime.now();
  final timeFromStart = timeNow.difference(startTime).inSeconds + 150;
  final remainder = timeFromStart.remainder(90);
  final timerValue = (90 - remainder).toDouble();
  return timerValue;
}
