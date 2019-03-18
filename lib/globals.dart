import 'dart:io';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart';

enum EventType {
  restaurantVisit,
  exercised,
  finishedRecommendedExercise,
  reachedWeightGoal,
  lostWeightGoal,
  weightChanged,
}

bool isLoggedIn = false;
User currUser;
var usersFile = File('users.json');
Future<String> loadFile() async {
  return await rootBundle.loadString('users.json');
}

List<Map<String, dynamic>> users_ex = [
  {
    'username': 'ally',
    'password': 'zot',
    'events': [
      {
        'etype': 'EventType.restaurantVisit',
        'restaurant': 'McDonald\'s',
        'lat': 33.745691600,
        'long': -117.8655619400,
        'source': 'Nutritionix',
        'datetime': 'someDatetime',
        'tookRecommendation': true,
        'order': 'itemType'
      },
      {
        'etype': 'EventType.exercised',
        'startTime': 'someDateTime',
        'endTime': 'someDateTime',
        'totalTime': 'someTimeValue',
        'kcalBurned': 100,
      },
      {
        'etype': 'EventType.finishedRecommendedExercise',
        'datetime': 'someDateTime',
        'kcalBurned': 500,
      },
      {
        'etype': 'EventType.weightChanged',
        'changeType': 'loss',
        'prevWeight': 150,
        'newWeight': 145,
        'weightDiff': 5,
        'datetime': 'someDateTime'
      },
      {
        'etype': 'EventType.reachedWeightGoal',
        'datetime': 'someDateTime',
        'weightGoal': 140,
      },
      {
        'etype': 'EventType.lostWeightGoal',
        'datetime': 'someDateTime',
        'weightGoal': 140,
      },
    ],
  },
  {'username': 'peter', 'password': 'uci'},
];

List<User> users = [];

class User {
  final String username;
  final String password;
  List<dynamic> events;

  User(this.username, this.password);

  User.fromJson(dynamic json)
      : username = json['username'],
        password = json['password'],
        events = json['events'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'events': events,
      };
}

void store() =>
    users.forEach((entry) => usersFile.writeAsStringSync(jsonEncode(entry)));

void load() async {
  // Map<String, dynamic> jsonInput = jsonDecode(usersFile.readAsStringSync());

  // Map<String, dynamic> jsonInput = await rootBundle.loadStructuredData('users.json', (String s) async {
  //   return json.decode(s);
  // });
  // List<Map<String, dynamic>> usersList = jsonInput['users'];
  // usersList.forEach(
  //     (entry) => users.add(User.fromJson(jsonDecode(jsonEncode(entry)))));

  await rootBundle.loadStructuredData('assets/users.json', (String s) async {
    return json.decode(s);
  }).then((jsonInput) {
    print(jsonInput['users'].runtimeType.toString());
    jsonInput['users'].forEach(
        (entry) {print(entry.toString()); users.add(User.fromJson(jsonDecode(jsonEncode(entry))));});
  });

  print(users.toString());
}

EventType getEventTypeFromString(String eventTypeString) {
  for (EventType type in EventType.values) {
    if (type.toString() == eventTypeString) {
      return type;
    }
  }
  return null;
}
