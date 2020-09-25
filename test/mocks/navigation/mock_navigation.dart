import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/navigation/navigation.dart';

class FakeNavigation extends Fake implements Navigation {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
