import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';

import 'package:chews_health/globals.dart';

class ChewsHealthApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      home: LoginPage(),
      // initialRoute: '/login',
      // onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}