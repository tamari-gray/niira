import 'package:niira/utilities/calc_sonar_timer.dart';
import 'package:test/test.dart';

void main() {
  test('returns correct time', () {
    // init data
    final _startTime = DateTime.now();

    // calc time
    final _sonarTimerValue = sonarTimer(startTime: _startTime);

    // check that time is alg
    expect(_sonarTimerValue, 5);
  });
}
