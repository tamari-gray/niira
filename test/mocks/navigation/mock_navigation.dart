import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/navigation/navigation.dart';

class FakeNavigation extends Fake implements Navigation {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class MockNavigation extends Mock implements Navigation {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
