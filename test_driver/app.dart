import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:niira/main.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/services/auth/navigation_service.dart';

import 'mocks/services/mock_auth_service.dart';

void main() {
  enableFlutterDriverExtension();

  final navService = NavigationService();
  final controller = StreamController<UserData>();
  final mockAuthService = MockAuthService(controller);
  mockAuthService.signInWithEmail('email', 'password');

  runApp(MyApp(mockAuthService, navService.navigatorKey));
}
