import 'package:flutter/material.dart';
import 'package:chews_health/globals.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.person,
            semanticLabel: 'profile',
          ),
          onPressed: () {
            print('prof button');
          },
        ),
        title: Text('CHEWSHEALTH'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.directions_run,
              semanticLabel: 'exercise',
            ),
            onPressed: () {
              print('exercise button');
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 1,
        padding: EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 9.0,
        children: <Widget>[
          Text(
            'Lat: , Long: ',
            textAlign: TextAlign.center,
          ),
          IconButton(
            icon: Icon(
              Icons.gps_not_fixed,
              semanticLabel: 'locate'
            ),
            onPressed: () {
              print('locate button');
            },
          ),
        ],
      ),
    );
  }
}
