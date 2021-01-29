import 'package:flutter/material.dart';

double sonarTimer({@required String startTime}) {
  final startTimeAsDateTime = DateTime.parse(startTime);
  final timeNow = DateTime.now();
  final timeFromStart = timeNow.difference(startTimeAsDateTime).inSeconds;
  final remainder = timeFromStart.remainder(90);
  final timerValue = (90 - remainder).toDouble();
  return timerValue;
}
