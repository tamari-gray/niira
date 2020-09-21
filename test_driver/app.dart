import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:niira/main.dart';
import 'package:niira/models/user_data.dart';

import 'mocks/mock_user_data.dart';
import 'mocks/services/mock_auth_service.dart';
import 'mocks/services/mock_database_service.dart';
import 'mocks/services/mock_location_service.dart';
import 'mocks/navigation/mock_navigation.dart';

void main() {
  enableFlutterDriverExtension();

  final mockNavigation = MockNavigation();
  final mockUserData = MockUser().userData;
  final mockAuthService = MockAuthService(
    controller: StreamController<UserData>(),
    mockUserData: mockUserData,
    mockNavigation: mockNavigation,
  );
  final mockLocationService = MockLocationService();
  final mockDBService = MockDatabaseService();
  mockAuthService.signInWithEmail('email', 'password');

  runApp(MyApp(
    authService: mockAuthService,
    databaseService: mockDBService,
    navigation: mockNavigation,
  ));
}
