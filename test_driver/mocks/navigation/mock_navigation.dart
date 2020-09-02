import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/navigation/navigation.dart';

class MockNavigation extends Mock implements Navigation {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
