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
  bool atGoalWeight = false;
  List<dynamic> events = [];

  User(this.username, this.password);

  User.fromJson(dynamic json)
      : username = json['username'],
        password = json['password'],
        age = json['age'],
        gender = json['gender'],
        height = json['height'],
        currWeight = json['currWeight'],
        goalWeight = json['goalWeight'],
        atGoalWeight = json['atGoalWeight'],
        events = json['events'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'age': age,
        'gender': gender,
        'height': height,
        'currWeight': currWeight,
        'goalWeight': goalWeight,
        'atGoalWeight': atGoalWeight,
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
    int total = 0;

    if (currUser.events == null) return total;

    for (var event in currUser.events) {
      if (getEventTypeFromString(event['etype']) ==
          EventType.consumedCalories) {
        DateTime eventDateTime = DateTime.tryParse(event['datetime']);
        int eventYear = eventDateTime.year;
        int eventMonth = eventDateTime.month;
        int eventDay = eventDateTime.day;

        DateTime now = DateTime.now();

        if (eventYear == now.year &&
            eventMonth == now.month &&
            eventDay == now.day) {
          total += event['kcalConsumed'];
        }
      }
    }
    print('new calories eaten: $total');
    return total;
  }

  int getCaloriesLeft() {
    return getDailyCaloricAllowance() - getCaloriesEaten();
  }
}

// void store() =>
//     users.forEach((entry) => usersFile.writeAsStringSync(jsonEncode(entry)));

void load() async {
  // // RUN THIS TO READ IN AN INITIAL FILE IF LOADING FROM APK FILE DOESN'T WORK
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
  print("\n CurrUser: ");
  print(jsonEncode(currUser));
  print("");
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

void generateEventWeightChanged(int prevWeight, int newWeight) {
  int weightDiff;
  String changeType;
  if (prevWeight > newWeight) {
    weightDiff = prevWeight - newWeight;
    changeType = 'loss';
  } else {
    weightDiff = newWeight - prevWeight;
    changeType = 'gain';
  }
  var event = {
    'etype': 'EventType.weightChanged',
    'changeType': changeType,
    'prevWeight': prevWeight,
    'newWeight': newWeight,
    'weightDiff': weightDiff,
    'datetime': DateTime.now().toString(),
  };
  currUser.events.add(event);
}

void generateEventReachedWeightGoal() {
  var event = {
    'etype': 'EventType.reachedWeightGoal',
    'datetime': DateTime.now().toString(),
    'weightGoal': currUser.goalWeight,
  };
  currUser.events.add(event);
}

void generateEventLostWeightGoal() {
  var event = {
    'etype': 'EventType.lostWeightGoal',
    'datetime': DateTime.now().toString(),
    'weightGoal': currUser.goalWeight,
  };
  currUser.events.add(event);
}

void generateEventRestaurantVisit(double lat, double long, String restName) {
  var event = {
    'etype': 'EventType.restaurantVisit',
    'restaurant': restName,
    'lat': lat,
    'long': long,
    'source': 'Nutritionix',
    'datetime': DateTime.now().toString(),
    'tookRecommendation': true
  };
  currUser.events.add(event);
  store();
}

void generateEventConsumedCalories(int cals) {
  var event = {
    'etype': 'EventType.consumedCalories',
    'datetime': DateTime.now().toString(),
    'kcalConsumed': cals,
  };
  currUser.events.add(event);
  store();
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
        'datetime': '2019-03-19 17:37:23.616',
        'tookRecommendation': true
      },
      {
        'etype': 'EventType.consumedCalories',
        'datetime': '2019-03-19 17:37:23.616',
        'kcalConsumed': 100,
      },
      {
        'etype': 'EventType.weightChanged',
        'changeType': 'loss',
        'prevWeight': 150,
        'newWeight': 145,
        'weightDiff': 5,
        'datetime': '2019-03-19 17:37:23.616'
      },
      {
        'etype': 'EventType.reachedWeightGoal',
        'datetime': '2019-03-19 17:37:23.616',
        'weightGoal': 140,
      },
      {
        'etype': 'EventType.lostWeightGoal',
        'datetime': '2019-03-19 17:37:23.616',
        'weightGoal': 140,
      },
    ],
  },
  {'username': 'peter', 'password': 'uci'},
];
