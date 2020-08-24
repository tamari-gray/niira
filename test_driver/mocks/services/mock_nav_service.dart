import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/services/auth/navigation_service.dart';

class MockNavService extends Mock implements NavigationService {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
