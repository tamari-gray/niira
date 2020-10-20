import 'package:flutter/material.dart';
import '../location.dart';

class CreateGameViewModel2 {
  double boundarySize;
  final double defaultBoundarySize;
  int sonarIntervals;
  Location boundaryPosition;

  // constructs vm with default boundary size, must be a multiple of 50
  CreateGameViewModel2({@required this.defaultBoundarySize});
}
