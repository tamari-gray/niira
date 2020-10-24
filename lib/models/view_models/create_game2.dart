import 'package:flutter/material.dart';
import '../location.dart';

/// set initial [boundarySize] value by manualy changing it here
class CreateGameViewModel2 extends ChangeNotifier {
  double boundarySize = 100;
  double sonarIntervals = 300;
  Location boundaryPosition;

  void updateBoundarySize(double size) {
    boundarySize = size;
    notifyListeners();
  }

  void updateBoundaryPosition(Location position) {
    boundaryPosition = position;
    notifyListeners();
  }

  void reset() {
    boundarySize = 100;
    sonarIntervals = 300;
    boundaryPosition = null;
  }
}
