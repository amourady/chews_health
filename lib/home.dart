import 'package:flutter/material.dart';
import 'package:chews_health/globals.dart';
import 'profile.dart';
import 'login.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:chews_health/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';

import 'menu_list.dart';
import 'menuItem_model.dart';


// Set your API stuff here:
final String appID = 'a92db20e';
final String appKey = '66839975ad994f1994ccf893bf1647d6';

// Test vars:
final testWeight = 160;

double hrsRunningToBurn(var calories, var lbWeight) {
  var runMET =
      7.5; //Metabolic Equivalent of Task Value from National Cancer Institute (cancer.gov)
  return (calories / ((lbWeight / 2.2) * runMET));
}

double minRunningToBurn(var calories, var lbWeight) {
  return hrsRunningToBurn(calories, lbWeight) * 60;
}

// Gets distance (in miles) between 2 pairs of lat,long coordinates
double getDistance(
    double startLat, double startLon, double endLat, double endLon) {
  var earthR = 6373.0; //radius of earth in km

  //convert lat/long to radians
  var lat1 = startLat * pi / 180;
  var lon1 = startLon * pi / 180;
  var lat2 = endLat * pi / 180;
  var lon2 = endLon * pi / 180;

  var lonDiff = lon2 - lon1;
  var latDiff = lat2 - lat1;

  var a = pow(sin(latDiff / 2), 2) +
      cos(lat1) * cos(lat2) * pow(sin(lonDiff / 2), 2);
  var c = 2 * atan2(sqrt(a), sqrt(1 - a));

  double miDistance = (earthR * c) / 1.609344;

  return miDistance;
}

void updateCaloriesLeft(var ateItemCal) {
  generateEventConsumedCalories(ateItemCal);
  print(currUser.events.last.toString());
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
  var url =
      'https://trackapi.nutritionix.com/v2/locations?ll=$lat,$lon&distance=50m&limit=1';

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'x-app-id': '$appID',
    'x-app-key': '$appKey'
  };

  final response = await http.get(url, headers: headers);

  return response;
}

// Return a response (string) of 30 food items, with minimum 240 calories each, from restaurant with brandID
// Uses a v1 API call
Future<http.Response> getFoodFromRestaurant(String brandID) async {
  var url =
      'https://api.nutritionix.com/v1_1/search/?brand_id=$brandID&results=0:50&cal_min=240&cal_max=${currUser.getCaloriesLeft()}&fields=item_name%2Cbrand_name%2Citem_id%2Cbrand_id%2Cnf_calories%2Cnf_protein%2Cnf_total_carbohydrate%2Cnf_total_fat&appId=$appID&appKey=$appKey';

  final response = await http.get(url);

  return response;
}

// Converts the response string into a useable Map with the JSON info
Map<String, dynamic> getRestaurantJSON(http.Response resp) {
  Map<String, dynamic> nearbyRestaurant = json.decode(resp.body);

  // Our call only returns 1 restaurant within 50m - Access the fields from restaurant["locations"][0]:
  return nearbyRestaurant['locations']
      [0]; // NOTE: this will cause an exception when no restaurants are found
}

// Converts the food hits to a useable List (of Maps) w/ the JSON info
List<dynamic> getFoodJSON(http.Response resp) {
  Map<String, dynamic> nearbyFood = json.decode(resp.body);

  return nearbyFood['hits'];
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // double _caloriesLeft = caloriesLeft;
  String _latlong = "lat:     long:     ";
  String _restaurantName = "";
  bool _gotRestaurant = false;
  List<MenuItem> _foodList = [];

  void _refreshCaloriesLeft() { 
      
    print("Refreshing calories left");
    // _caloriesLeft = currUser.getCaloriesLeft().toDouble();
    _foodList.removeWhere((item) => item.calories > currUser.getCaloriesLeft());

    setState(() {
      // _caloriesLeft = caloriesLeft;
    });
  }

  void _getNearestRestaurant() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // Must 'await getPos()' outside of setState() -- setState cannot be async
    var currentLocation = <String, double>{};
    try {
      currentLocation = await getPos();
    } on PlatformException {
      currentLocation = null;
    }

    // dummy Wendy's Restaurant example (hardcoded JSON response):
    String exampleCall =
        '{"locations":[{"name":"Wendy\'s","brand_id":"513fbc1283aa2dc80c00000f","fs_id":null,"address":"4115 Campus Drive, Irvine","address2":null,"city":"Irvine","state":"California","country":"US","zip":"92612","phone":"+18007861000","website":"https://www.wendys.com/","guide":null,"id":705010,"lat":33.65018844604492,"lng":-117.84062957763672,"created_at":"2017-06-26T21:36:47.000Z","updated_at":"2018-02-28T22:10:54.000Z","distance_km":0.0035026900922278045}]}';
    Map<String, dynamic> wendysExample = json.decode(exampleCall);
    Map<String, dynamic> nearbyRestaurant = wendysExample['locations'][0];

    // Using the API & actual location: (if you use this one, COMMENT the 3 LOC above for the wendys ex, and uncomment the 3 below)
    //CHOOSE 1:
    // http.Response resp = await getNearbyRestaurant(currentLocation['latitude'], currentLocation['longitude']); // using your current location
    // http.Response resp = await getNearbyRestaurant(33.649515, -117.842338); // WENDY'S lat/long
    // print(json.decode(resp.body));
    // Map<String, dynamic> nearbyRestaurant = getRestaurantJSON(resp);

    // Use Brand ID from the 'nearby restaurant' API call to get the menu items, using another API call
    http.Response foodResp =
        await getFoodFromRestaurant(nearbyRestaurant['brand_id']);

    List<dynamic> nearbyFood = getFoodJSON(foodResp);

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _latlong without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      // _caloriesLeft = caloriesLeft;
      _latlong = "lat: " +
          currentLocation['latitude'].toString() +
          " long: " +
          currentLocation['longitude'].toString();

      _restaurantName =
          nearbyRestaurant['name'] + ", " + nearbyRestaurant['city'];

      _foodList = [];
      // Populate list newL with MenuItems
      nearbyFood.forEach((foodItem) => _foodList.add(new MenuItem(
          nearbyRestaurant['name'],
          foodItem['fields']['item_name'],
          foodItem['fields']['nf_calories'],
          foodItem['fields']['nf_protein'],
          foodItem['fields']['nf_total_carbohydrate'],
          foodItem['fields']['nf_total_fat'])));
      _gotRestaurant = true;

      
      _foodList.sort((a, b) => a.calories.compareTo(b.calories)); //asc
      _foodList.sort((a, b) => a.fat.compareTo(b.fat)); //asc
      _foodList.sort((a, b) => a.carbs.compareTo(b.carbs)); //asc

      // print(_foodList.toString());
      generateEventRestaurantVisit(currentLocation['latitude'], currentLocation['longitude'], nearbyRestaurant['name']);
      print(currUser.events.last.toString());

    });
  }

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        ),
        title: Text('CHEWSHEALTH'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              semanticLabel: 'log out',
            ),
            onPressed: () {
              isLoggedIn = false;
              currUser = null;
              //store();

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => LoginPage()),
              // );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          Text(
            '\n$_latlong\n',
            textAlign: TextAlign.center,
          ),
          FloatingActionButton(
            heroTag: "b4",
            onPressed: (_gotRestaurant ? _refreshCaloriesLeft : _getNearestRestaurant),
            tooltip:
                (_gotRestaurant ? 'Update my recommendations' : 'Locate me'),
            child: Icon((_gotRestaurant ? Icons.refresh : Icons.gps_fixed)),
          ),
          Text(
            '$_restaurantName',
            style: Theme.of(context).textTheme.display1,
            textAlign: TextAlign.center,
          ),
          Text(
            (currUser.getCaloriesLeft() > 0
                ? 'Calories left for this meal: ${currUser.getCaloriesLeft()}'
                : 'WATCH OUT! You ate ${currUser.getCaloriesLeft() + (2 * (-1 * currUser.getCaloriesLeft()))} extra calories!'),
            textAlign: TextAlign.center,
            style: (currUser.getCaloriesLeft() > 0
                ? Theme.of(context).textTheme.body1
                : TextStyle(color: Colors.red)),
          ),
          Divider(
            height: 5.0,
          ),
          Container(
            height: 400.0,
            child: Center(
              child: (_foodList.length > 0
                  ? MenuList(_foodList, this)
                  : (_gotRestaurant
                      ? Text('Sorry, we\'re out of recommendations!')
                      : MenuList(_foodList, this))),
            ),
          ),
        ],
      ),
    );
  }
}
