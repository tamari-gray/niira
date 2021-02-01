import 'package:flutter/material.dart';

double sonarTimer({@required String startTime, @required double timerLength}) {
  final startTimeAsDateTime = DateTime.parse(startTime);
  final timeNow = DateTime.now();
  final timeFromStart = timeNow.difference(startTimeAsDateTime).inSeconds;
  final remainder = timeFromStart.remainder(timerLength);
  final timerValue = (timerLength - remainder).toDouble();
  return timerValue;
}
