import 'dart:io';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart';

enum EventType {
  restaurantVisit,
  consumedCalories,
  finishedRecommendedExercise,
  reachedWeightGoal,
  lostWeightGoal,
  weightChanged,
}

bool isLoggedIn = false;
User currUser;

List<User> users = [];

class User {
  final String username;
  final String password;

  //Personal Model
  int age;
  String gender;
  int height; //in inches
  int currWeight;
  int goalWeight;
  List<dynamic> events;

  User(this.username, this.password);

  User.fromJson(dynamic json)
      : username = json['username'],
        password = json['password'],
        age = json['age'],
        gender = json['gender'],
        height = json['height'],
        currWeight = json['currWeight'],
        goalWeight = json['goalWeight'],
        events = json['events'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'events': events,
      };

  int getDailyCaloricAllowance() {
    double bmr;

    if (this.gender == 'male') {
      bmr = 66 + (6.3 * this.currWeight) + (12.9 * this.height) - (6.8 * this.age);
    }
    else {
      bmr = 655 + (4.3 * this.currWeight) + (4.7 * this.height) - (4.7 * this.age);
    }

    if (this.currWeight != this.goalWeight) {
      bmr -= 500;
    }

    return bmr.toInt();
  }

  int getCaloriesEaten() {
    return 0;
  }

  int getCaloriesLeft() {
    return getDailyCaloricAllowance() - getCaloriesEaten();
  }
}

// void store() =>
//     users.forEach((entry) => usersFile.writeAsStringSync(jsonEncode(entry)));

void load() async {

  await rootBundle.loadStructuredData('assets/users.json', (String s) async {
    return json.decode(s);
  }).then((jsonInput) {
    print(jsonInput['users'].runtimeType.toString());
    jsonInput['users'].forEach((entry) {
      print(entry.toString());
      users.add(User.fromJson(jsonDecode(jsonEncode(entry))));
    });
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
        'etype' : 'EventType.consumedCalories',
        'datetime' : 'someDateTime',
        'kcalConsumed': 100,
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