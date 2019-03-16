import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'dart:math';
//import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http; 
import 'package:cloud_firestore/cloud_firestore.dart';

// Set your API stuff here:
final String appID = 'asdf';
final String appKey = 'asdf';


// Holds details of a menu item
class MenuItem {
  String restaurant;
  String name;
  var calories;
  var protein;
  var carbs;
  var fat;
  
  
  MenuItem (String newRes, String newName, var newCal, var newPro, var newCar, var newFat) {
    restaurant = newRes;
    name = newName;
    calories = newCal;
    protein = newPro;
    carbs = newCar;
    fat = newFat;
  }
}

// Gets distance (in miles) between 2 pairs of lat,long coordinates
double getDistance(double startLat, double startLon, double endLat, double endLon) {
  var earthR = 6373.0; //radius of earth in km

  //convert lat/long to radians
  var lat1 = startLat * pi / 180;
  var lon1 = startLon * pi / 180;
  var lat2 = endLat * pi / 180;
  var lon2 = endLon * pi / 180;
  
  var lonDiff = lon2 - lon1;
  var latDiff = lat2 - lat1;
  
  var a = pow(sin(latDiff / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(lonDiff / 2), 2);
  var c = 2 * atan2(sqrt(a), sqrt(1 - a));
  
  double miDistance = (earthR * c) / 1.609344;
    
  return miDistance;
}

// Get the user's current position
Future<Map<String, double>> getPos() async {
  var location = new Location();
  Map<String, double> currentLocation = await location.getLocation();
  return currentLocation;
}

// Return a response (string) of 1 restaurant within 50m of given lat/lon
// Uses a v2 API call
Future<http.Response> getNearbyRestaurant(double lat, double lon) async {
  var url = 'https://trackapi.nutritionix.com/v2/locations?ll=$lat,$lon&distance=50m&limit=1';

  Map<String, String> headers = {
    'Content-Type' : 'application/json',
    'x-app-id' : '$appID',
    'x-app-key': '$appKey'
  };
  
  final response = await http.get(url, headers: headers);
 
  return response;
}

// Return a response (string) of 30 food items, with minimum 240 calories each, from restaurant with brandID
// Uses a v1 API call
Future<http.Response> getFoodFromRestaurant(String brandID) async {
    var url = 'https://api.nutritionix.com/v1_1/search/?brand_id=$brandID&results=0:30&cal_min=240&cal_max=50000&fields=item_name%2Cbrand_name%2Citem_id%2Cbrand_id%2Cnf_calories%2Cnf_protein%2Cnf_total_carbohydrate%2Cnf_total_fat&appId=$appID&appKey=$appKey';

  final response = await http.get(url);
  
  return response;
}


// Converts the response string into a useable Map with the JSON info
Map<String, dynamic> getRestaurantJSON(http.Response resp) {
  Map<String, dynamic> nearbyRestaurant = json.decode(resp.body);

  // Our call only returns 1 restaurant within 50m - Access the fields from restaurant["locations"][0]:
  return nearbyRestaurant['locations'][0]; // NOTE: this will cause an exception when no restaurants are found
}

// Converts the food hits to a useable List (of Maps) w/ the JSON info
List<dynamic> getFoodJSON(http.Response resp) {
  Map<String, dynamic> nearbyFood = json.decode(resp.body);

  return nearbyFood['hits'];
}




void main() {
  runApp(MaterialApp(
    title: 'ChewsHealth',
    home: MyHomePage(),
  ));
}



class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class ThirdRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Third Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _latlong = "lat:     long:     ";
  String _restaurantName = "";
  String _brandID = "Press the 'locate me' button to find the nearest restaurant.";
  String _foodInfo = "";

  void _getNearestRestaurant() async {
    _foodInfo = "";
    // Platform messages may fail, so we use a try/catch PlatformException.
    // Must 'await getPos()' outside of setState() -- setState cannot be async
    var currentLocation = <String, double>{};
    try {
      currentLocation = await getPos();
    } on PlatformException {
      currentLocation = null;
    }

    // dummy Wendy's Restaurant example (hardcoded JSON response):
    String exampleCall = '{"locations":[{"name":"Wendy\'s","brand_id":"513fbc1283aa2dc80c00000f","fs_id":null,"address":"4115 Campus Drive, Irvine","address2":null,"city":"Irvine","state":"California","country":"US","zip":"92612","phone":"+18007861000","website":"http://www.in-n-out.com/default.asp","guide":null,"id":705010,"lat":33.65018844604492,"lng":-117.84062957763672,"created_at":"2017-06-26T21:36:47.000Z","updated_at":"2018-02-28T22:10:54.000Z","distance_km":0.0035026900922278045}]}';
    Map<String, dynamic> wendysExample = json.decode(exampleCall);
    Map<String, dynamic> nearbyRestaurant = wendysExample['locations'][0];

    // Using the API & actual location: (if you use this one, COMMENT the 3 LOC above for the wendys ex, and uncomment the 3 below)
    //CHOOSE 1:
      // http.Response resp = await getNearbyRestaurant(currentLocation['latitude'], currentLocation['longitude']); // using your current location
      // http.Response resp = await getNearbyRestaurant(33.649515, -117.842338); // WENDY'S lat/long
    // print(json.decode(resp.body));
    // Map<String, dynamic> nearbyRestaurant = getRestaurantJSON(resp);
    
    // Use Brand ID from the 'nearby restaurant' API call to get the menu items, using another API call
    http.Response foodResp = await getFoodFromRestaurant(nearbyRestaurant['brand_id']);
    
    List<dynamic> nearbyFood = getFoodJSON(foodResp);


    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _latlong without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      _latlong = "lat: " + currentLocation['latitude'].toString() + " long: " + currentLocation['longitude'].toString();

      _restaurantName = nearbyRestaurant['name'];

      _brandID = "brand id: " + nearbyRestaurant['brand_id'];

      List<MenuItem> foodList = [];
      // Populate list newL with MenuItems
      nearbyFood.forEach((foodItem) => foodList.add(new MenuItem(nearbyRestaurant['name'], foodItem['fields']['item_name'],
        foodItem['fields']['nf_calories'], foodItem['fields']['nf_protein'], foodItem['fields']['nf_total_carbohydrate'],
        foodItem['fields']['nf_total_fat'])));

      // Sort menu items by calories (ascending)
      foodList.sort((a, b) => a.calories.compareTo(b.calories));

      // Output sorted menu items to _foodInfo
      foodList.forEach((f) => _foodInfo += '${f.name}\n    Cal: ${f.calories}\n        Pro: ${f.protein}\n'
                                + '        Carbs: ${f.carbs}\n        Fat: ${f.fat}\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _getNearestRestaurant method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text('ChewsHealth'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: "b1",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FirstRoute()),
                  );
                },         
                tooltip: 'Go to user page',
                  child: Icon(Icons.person),
                ), // Left button

              FloatingActionButton(
                heroTag: "b2",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                  );
                },         
                tooltip: 'Go to food page',
                  child: Icon(Icons.location_on),
                ), // Middle button

              FloatingActionButton(
                heroTag: "b3",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThirdRoute()),
                  );
                },         
                tooltip: 'Go to run page',
                  child: Icon(Icons.directions_run),
                ), // Right button

            ],
          ),

          // Image.asset("images/Header.png",
          // fit: BoxFit.cover,
          // ),


        Text(
          '\n$_latlong\n',
          textAlign:TextAlign.center,
        ),

        FloatingActionButton(
          heroTag: "b4",
          onPressed: _getNearestRestaurant,
          tooltip: 'Locate me',
            child: Icon(Icons.gps_fixed),
          ),
        

        Container(
          height: 400.0,
          padding: const EdgeInsets.all(10.0),
          child:  Column(
            mainAxisSize:MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
      
              Text(
                '$_restaurantName',
                style: Theme.of(context).textTheme.display1,
                textAlign:TextAlign.center,
              ),

              Text(
                '$_brandID',
                textAlign:TextAlign.center,
              ),

              new Expanded(
                flex: 1,
                child: new SingleChildScrollView(
                  child: new Text(
                    '$_foodInfo',
                      style: new TextStyle (
                      fontSize: 10.0, color: Colors.blue,
                    ),
                  ),
                ),
              ),


              ],
          ),
        ),
        ],
      ),
    );
  }
}
