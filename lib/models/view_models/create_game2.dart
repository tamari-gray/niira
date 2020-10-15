import 'package:flutter/material.dart';
import '../location.dart';

class CreateGameViewModel2 {
  double boundarySize;
  final double defaultBoundarySize;
  int sonarIntervals;
  Location boundaryPosition;

  // constructs vm with default boundary size
  CreateGameViewModel2({@required this.defaultBoundarySize});
}
