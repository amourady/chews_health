import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'dart:math';
//import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http; 
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:chews_health/app.dart';

import 'package:chews_health/globals.dart';

void main() {
  load();
  runApp(ChewsHealthApp());
}


// // Gets distance (in miles) between 2 pairs of lat,long coordinates
// double getDistance(double startLat, double startLon, double endLat, double endLon) {
//   var earthR = 6373.0; //radius of earth in km

//   //convert lat/long to radians
//   var lat1 = startLat * pi / 180;
//   var lon1 = startLon * pi / 180;
//   var lat2 = endLat * pi / 180;
//   var lon2 = endLon * pi / 180;
  
//   var lonDiff = lon2 - lon1;
//   var latDiff = lat2 - lat1;
  
//   var a = pow(sin(latDiff / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(lonDiff / 2), 2);
//   var c = 2 * atan2(sqrt(a), sqrt(1 - a));
  
//   double miDistance = (earthR * c) / 1.609344;
    
//   return miDistance;
// }

// // Get the user's current position
// Future<Map<String, double>> getPos() async {
//   var location = new Location();
//   Map<String, double> currentLocation = await location.getLocation();
//   return currentLocation;
// }

// // Return a response (string) of 1 restaurant within 50m of given lat/lon
// Future<http.Response> getNearbyRestaurant(double lat, double lon) async {
  
//   var url = 'https://trackapi.nutritionix.com/v2/locations?ll=$lat,$lon&distance=50m&limit=1';

//   Map<String, String> headers = {
//     'Content-Type' : 'application/json',
//     'x-app-id' : 'YOURAPPID',
//     'x-app-key': 'YOURAPPKEY'
//   };
  
//   final response = await http.get(url, headers: headers);
//   final responseJson = json.decode(response.body);
//   print(responseJson);
//   return response;


// }


// // Converts the response string into a useable Map with the JSON info
// Map<String, dynamic> getRestaurantJSON(http.Response resp) {
//   Map<String, dynamic> nearbyRestaurant = json.decode(resp.body);

//     // Our call only returns 1 restaurant within 50m - Access the fields from restaurant["locations"][0]:
//   return nearbyRestaurant['locations'][0]; // NOTE: this will cause an exception when no restaurants are found
// }

// void main() {
  


//   runApp(MaterialApp(
//     title: 'Navigation Basics',
//     home: FirstRoute(),
//   ));
// }

// class FirstRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: PreferredSize(
//       //   preferredSize: Size.fromHeight(50.0),
//       //   child: AppBar(
//       //     title: Text('ChewsHealth'),
//       //   ),
//       // ),
//       body: ListView(

//         children: [
//           Row(
//             mainAxisAlignment:MainAxisAlignment.spaceEvenly,
//             children: [
//               FloatingActionButton(
//                 heroTag: "b1",
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => SecondRoute()),
//                   );
//                 },         
//                 tooltip: 'Go to user page',
//                   child: Icon(Icons.person),
//                 ),

//               FloatingActionButton(
//                 heroTag: "b2",
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => MyHomePage()),
//                   );
//                 },         
//                 tooltip: 'Go to location page',
//                   child: Icon(Icons.location_on),
//                 ),

//               FloatingActionButton(
//                 heroTag: "b3",
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ThirdRoute()),
//                   );
//                 },         
//                 tooltip: 'Go to run page',
//                   child: Icon(Icons.directions_run),
//                 ),

//             ],
//           ),
//           // Image.asset("images/Header.png",
//           // fit: BoxFit.cover,
//           // ),
//           ///////////////////
//           RaisedButton(
//           child: Text('Go to route2'),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => SecondRoute()),
//             );
//           },
//           ),
//           ////////////////////////////
//           RaisedButton(
//           child: Text('Go to route3'),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ThirdRoute()),
//             );
//           },
//         ),
//          RaisedButton(
//           child: Text('GPS Test route'),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => MyHomePage()),
//             );
//           },
//         ),
//         FloatingActionButton(
//           heroTag: "b4",
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => MyHomePage()), // placeholder
//             );
//           },         
//           tooltip: 'get my location',
//             child: Icon(Icons.gps_fixed),
//           ),



//         ],
//       ),
//     );
//   }
// }

// class SecondRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Second Route"),
//       ),
//       body: Center(
//         child: RaisedButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }


// class ThirdRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Third Route"),
//       ),
//       body: Center(
//         child: RaisedButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }


// class MyHomePage extends StatefulWidget {
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }



// class _MyHomePageState extends State<MyHomePage> {
//   String _counter = "";

//   void _incrementCounter() async {

//     // Platform messages may fail, so we use a try/catch PlatformException.
//     // Must 'await getPos()' outside of setState() -- setState cannot be async
//     var currentLocation = <String, double>{};
//     try {
//       currentLocation = await getPos();
//     } on PlatformException {
//       currentLocation = null;
//     }

//     // In-n-out example: 
//     // http.Response resp = await getNearbyRestaurant(33.650162, -117.840609);
    
//     // The response string & nearbyRestaurant Map
//     // (for In-N-Out example) is hardcoded below, to ration API calls
    
//     //String exampleCall = '{"locations":[{"name":"In-N-Out Burger","brand_id":"513fbc1283aa2dc80c000011","fs_id":null,"address":"4115 Campus Drive, Irvine","address2":null,"city":"Irvine","state":"California","country":"US","zip":"92612","phone":"+18007861000","website":"http://www.in-n-out.com/default.asp","guide":null,"id":705010,"lat":33.65018844604492,"lng":-117.84062957763672,"created_at":"2017-06-26T21:36:47.000Z","updated_at":"2018-02-28T22:10:54.000Z","distance_km":0.0035026900922278045}]}';
//     // Map<String, dynamic> nearbyRestaurant = json.decode(exampleCall);

//     http.Response resp = await getNearbyRestaurant(currentLocation['latitude'], currentLocation['longitude']);


//     print(json.decode(resp.body));

//     Map<String, dynamic> nearbyRestaurant = getRestaurantJSON(resp);
    
//     print(nearbyRestaurant['brand_id']);
//     print(nearbyRestaurant['name']);
    
//     nearbyRestaurant.forEach((k,v) => print("KEY: $k               VALUE: $v"));

//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.

//       print(currentLocation["latitude"]);
//       print(currentLocation["longitude"]);
//       print(currentLocation["accuracy"]);
//       print(currentLocation["altitude"]);
//       print(currentLocation["speed"]);
//       print(currentLocation["speed_accuracy"]); // Will always be 0 on iOS

//         _counter = nearbyRestaurant['name'] + "\n\nbrand id: " + 
//           nearbyRestaurant['brand_id'] + "\n\n" + 
//           "Your Coordinates: " + currentLocation['latitude'].toString() + ", " + currentLocation['longitude'].toString();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("GPS Test"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               "Info:",
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.display1,
//               textAlign:TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Geolocate',
//         child: Icon(Icons.gps_fixed),
//       ),
//     );
//   }
// }
