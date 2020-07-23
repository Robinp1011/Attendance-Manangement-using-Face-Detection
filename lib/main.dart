


import 'package:attendanceblp/homePage.dart';
import 'package:attendanceblp/output.dart';
import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
//import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';
import 'dart:ui';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');

  print(email);
  runApp(MyApp(email));
}


class MyApp extends StatelessWidget {
  @override
  String email;
  MyApp(String email)
  {
    this.email = email;
  }
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: email == null ? LoginPage() : GeoListenPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}




/*
import 'dart:ui';

import 'package:attendanceblp/homePage.dart';
import 'package:attendanceblp/loginPage.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';
import 'dart:async';
import 'dart:io';
import 'face.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:GeoListenPage() ,
    );
  }
}



 */
