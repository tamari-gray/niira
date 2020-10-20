import 'package:flutter/material.dart';
import '../location.dart';

class CreateGameViewModel2 extends ChangeNotifier {
  double boundarySize;
  double defaultBoundarySize = 100;
  int sonarIntervals;
  Location boundaryPosition;

  // constructs vm with default boundary size, must be a multiple of 50
  CreateGameViewModel2({@required this.defaultBoundarySize});

  void reset() {
    boundarySize = null;
    defaultBoundarySize = 100;
    sonarIntervals = null;
    boundaryPosition = null;
  }
}
