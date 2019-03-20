import 'dart:io';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

enum EventType {
  restaurantVisit,
  consumedCalories,
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
        'age': age,
        'gender': gender,
        'height': height,
        'currWeight': currWeight,
        'goalWeight': goalWeight,
        'events': events,
      };

  int getDailyCaloricAllowance() {
    double bmr;

    if (this.gender == 'male') {
      bmr = 66 +
          (6.3 * this.currWeight) +
          (12.9 * this.height) -
          (6.8 * this.age);
    } else {
      bmr = 655 +
          (4.3 * this.currWeight) +
          (4.7 * this.height) -
          (4.7 * this.age);
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
  // await rootBundle.loadStructuredData('assets/users.json', (String s) async {
  //   return json.decode(s);
  // }).then((jsonInput) {
  //   print(jsonInput['users'].runtimeType.toString());
  //   jsonInput['users'].forEach((entry) {
  //     print(entry.toString());
  //     users.add(User.fromJson(jsonDecode(jsonEncode(entry))));
  //   });
  // });

  final file = await _localFile;
  await file.readAsString().then((jsonStr) {
    var jsonInput = jsonDecode(jsonStr);
    print(jsonInput['users'].runtimeType.toString());
    jsonInput['users'].forEach((entry) {
      print(entry.toString());
      users.add(User.fromJson(jsonDecode(jsonEncode(entry))));
    });
  });
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  print('$path');
  return File('$path/users.json');
}

Future<File> store() async {
  final file = await _localFile;
  print(jsonEncode({'users': users}));
  await file.writeAsString(jsonEncode({'users': users}));
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
        'etype': 'EventType.consumedCalories',
        'datetime': 'someDateTime',
        'kcalConsumed': 100,
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
