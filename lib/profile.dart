import 'package:flutter/material.dart';
import 'package:chews_health/globals.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            semanticLabel: 'previous page',
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("PROFILE"),
      ),
      body: Center(
      ),
    );
  }
}