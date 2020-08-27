import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:niira/main.dart';
import 'package:niira/models/user_data.dart';

import 'mocks/mock_user_data.dart';
import 'mocks/services/mock_auth_service.dart';
import 'mocks/services/mock_database_service.dart';
import 'mocks/services/mock_nav_service.dart';

void main() {
  enableFlutterDriverExtension();

  final mockNavService = MockNavService();
  final mockUserData = MockUser().userData;
  final mockAuthService = MockAuthService(
    controller: StreamController<UserData>(),
    mockUserData: mockUserData,
    mockNavService: mockNavService,
  );
  final mockDBService = MockDatabaseService();
  mockAuthService.signInWithEmail('email', 'password');

  runApp(MyApp(
    mockAuthService,
    mockNavService.navigatorKey,
    mockDBService,
    mockNavService,
  ));
}
