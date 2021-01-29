import 'package:niira/utilities/calc_sonar_timer.dart';
import 'package:test/test.dart';

void main() {
  test('returns correct time', () async {
    // init data
    final _startTime = DateTime.now().toString();

    // calc time
    final _sonarTimerValue = await Future.delayed(Duration(seconds: 4), () {
      return sonarTimer(startTime: _startTime);
    });

    // check that time is alg
    expect(_sonarTimerValue, 86);
  });
}
