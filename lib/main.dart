import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'dart:math';
//import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:chews_health/app.dart';

import 'package:chews_health/globals.dart';

void main() {
  load();
  runApp(ChewsHealthApp());
}
