import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chews_health/globals.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/pac.png'),
                SizedBox(height: 16.0),
                Text('CHEWSHEALTH'),
              ],
            ),
            SizedBox(height: 120.0),
            // [Name]
            TextField(
              controller:_usernameController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Username',
              ),
            ),
            // spacer
            SizedBox(height: 12.0),
            // [Password]
            TextField(
              controller:_passwordController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                FlatButton(
                  child: Text('SIGN UP'),
                  onPressed: () {
                  },
                ),
                RaisedButton(
                  child: Text('NEXT'),
                  onPressed: () {
                    String uname = _usernameController.text;
                    String pass = _passwordController.text;

                    // Future<DocumentSnapshot> userDoc = Firestore.instance.collection('users').document(uname).get();
                    print(users.toString());
                    for(User userEntry in users) {
                      print(userEntry.toString());
                      print(userEntry.username);
                      print(userEntry.password);
                      if (userEntry.username == uname && userEntry.password == pass) {
                        isLoggedIn = true;
                        currUser = userEntry;
                        print('MATCHED');
                      }
                    }
                    
                    if (isLoggedIn) Navigator.pop(context);
                    else print("incorrect creds");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}