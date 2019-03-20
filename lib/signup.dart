import 'package:flutter/material.dart';
import 'package:chews_health/globals.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _dropdownValue = 'male';
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _currWeightController = TextEditingController();
  final _goalWeightController = TextEditingController();

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
        title: Text("SIGN UP"),
      ),
      body: ListView(padding: EdgeInsets.all(8.0), itemExtent: 20.0, children: <
          Widget>[
        // [Username]
        SizedBox(height: 80.0),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            filled: true,
            labelText: 'Username',
          ),
        ),
        // spacer
        SizedBox(height: 80.0),
        // [Password]
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            filled: true,
            labelText: 'Password',
          ),
          obscureText: true,
        ),
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
        TextField(
          controller: _heightController,
          decoration: InputDecoration(
            filled: true,
            labelText: 'height (inches)',
          ),
          keyboardType: TextInputType.number,
        ),
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
        // update button
        RaisedButton(
          child: Text('REGISTER'),
          onPressed: () {
            if (_usernameController.text.isNotEmpty &&
                _passwordController.text.isNotEmpty)
              currUser =
                  new User(_usernameController.text, _passwordController.text);

            currUser.gender = _dropdownValue;

            if (_ageController.text.isNotEmpty)
              currUser.age = int.tryParse(_ageController.text);

            if (_heightController.text.isNotEmpty)
              currUser.height = int.tryParse(_heightController.text);

            if (_currWeightController.text.isNotEmpty)
              currUser.currWeight = int.tryParse(_currWeightController.text);

            if (_goalWeightController.text.isNotEmpty)
              currUser.goalWeight = int.tryParse(_goalWeightController.text);

            users.add(currUser);

            store();

            Navigator.pop(context);
          },
        )
      ]),
    );
  }
}
