import 'package:flutter/material.dart';
import 'package:chews_health/globals.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _dropdownValue = currUser.gender;
  final _ageController = TextEditingController.fromValue(
      TextEditingValue(text: currUser.age.toString()));
  final _heightController = TextEditingController.fromValue(
      TextEditingValue(text: currUser.height.toString()));
  final _currWeightController = TextEditingController.fromValue(
      TextEditingValue(text: currUser.currWeight.toString()));
  final _goalWeightController = TextEditingController.fromValue(
      TextEditingValue(text: currUser.goalWeight.toString()));

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
      body: ListView(padding: EdgeInsets.all(8.0), itemExtent: 20.0, children: <
          Widget>[
        Text(
          '${currUser.username}',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 80.0),
        Text('Daily Calories Needed: ${currUser.getDailyCaloricAllowance()}'),
        SizedBox(height: 80.0),
        Text('Calories Eaten Today: ${currUser.getCaloriesEaten()}'),
        SizedBox(height: 80.0),
        Text('Calories Left Today: ${currUser.getCaloriesLeft()}'),
        SizedBox(height: 80.0),
        // [gender]
        DropdownButton<String>(
          value: _dropdownValue,
          onChanged: (String newValue) {
            setState(() {
              _dropdownValue = newValue;
            });
          },
          items: <String>['male', 'female'].map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
        ),
        SizedBox(height: 80.0),
        // [age]
        TextField(
          controller: _ageController,
          decoration: InputDecoration(
            filled: true,
            labelText: 'age',
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 80.0),
        // [height]
        SizedBox(height: 80.0),
        TextField(
          controller: _heightController,
          decoration: InputDecoration(
            filled: true,
            labelText: 'height (inches)',
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 80.0),
        SizedBox(height: 80.0),
        // [current weight]
        TextField(
          controller: _currWeightController,
          decoration: InputDecoration(
            filled: true,
            labelText: 'current weight (lbs)',
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 80.0),
        SizedBox(height: 80.0),
        // [goal weight]
        TextField(
          controller: _goalWeightController,
          decoration: InputDecoration(
            filled: true,
            labelText: 'goal weight (lbs)',
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 80.0),
        SizedBox(height: 80.0),

        // update button
        RaisedButton(
          child: Text('UPDATE'),
          onPressed: () {
            if (_dropdownValue != currUser.gender)
              currUser.gender = _dropdownValue;

            if (_ageController.text.isNotEmpty &&
                int.tryParse(_ageController.text) != currUser.age)
              currUser.age = int.tryParse(_ageController.text);

            if (_heightController.text.isNotEmpty &&
                int.tryParse(_heightController.text) != currUser.height)
              currUser.height = int.tryParse(_heightController.text);

            if (_currWeightController.text.isNotEmpty &&
                int.tryParse(_currWeightController.text) !=
                    currUser.currWeight) {
              generateEventWeightChanged(currUser.currWeight,
                  int.tryParse(_currWeightController.text));
              currUser.currWeight = int.tryParse(_currWeightController.text);
              print(currUser.events.last.toString());
            }

            if (_goalWeightController.text.isNotEmpty &&
                int.tryParse(_goalWeightController.text) != currUser.goalWeight)
              currUser.goalWeight = int.tryParse(_goalWeightController.text);

            if (currUser.currWeight == currUser.goalWeight &&
                !currUser.atGoalWeight) {
              currUser.atGoalWeight = true;
              generateEventReachedWeightGoal();
              print(currUser.events.last.toString());
            } else if (currUser.currWeight != currUser.goalWeight &&
                currUser.atGoalWeight) {
              currUser.atGoalWeight = false;
              generateEventLostWeightGoal();
              print(currUser.events.last.toString());
            }

            // if (currUser.currWeight == currUser.goalWeight) {
            //   currUser.atGoalWeight = true;
            // }
            // else currUser.atGoalWeight = false;

            store();
            setState(() {});
          },
        )
      ]),
    );
  }
}
