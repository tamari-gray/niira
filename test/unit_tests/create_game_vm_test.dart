import 'package:flutter_test/flutter_test.dart';
import 'package:niira/models/location.dart';
import 'package:niira/models/view_models/create_game.dart';

void main() {
  test('updates BoundarySize', () {
    final vm = CreateGameViewModel();
    expect(vm.boundarySize, 100);

    vm.addListener(() {
      expect(vm.boundarySize, 200);
    });
    vm.updateBoundarySize(200);
  });
  test('updates BoundaryPosition', () {
    final vm = CreateGameViewModel();
    expect(vm.boundaryPosition, null);

    final testPosition = Location(latitude: 0, longitude: 0);
    vm.addListener(() {
      expect(vm.boundaryPosition, testPosition);
    });
    vm.updateBoundaryPosition(testPosition);
  });

  test('updates loadedMap', () {
    final vm = CreateGameViewModel();
    expect(vm.loadingMap, true);

    vm.addListener(() {
      expect(vm.loadingMap, false);
    });
    vm.loadedMap();
  });
  test('reset updates vm to default values', () {
    final vm = CreateGameViewModel();

    vm.reset();

    expect(vm.boundarySize, 100);
    expect(vm.sonarIntervals, 210);
  });
}
