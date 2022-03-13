// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, use_key_in_widget_constructors

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth/screens/home.dart';
import 'package:flutter_firebase_auth/screens/loading_screen.dart';
import 'package:flutter_firebase_auth/screens/update_profile.dart';
import 'package:flutter_firebase_auth/screens/user_profile.dart';
import 'auth/forget_password.dart';
import 'auth/login.dart';
import 'auth/sign_up.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(
            child:
                Text("Something went wrong!", textDirection: TextDirection.ltr),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: FirebaseAuth.instance.currentUser == null ? Login() : Home(),
            routes: {
              "/home": (context) => Home(),
              "/sign-up": (context) => SignUp(),
              "/login": (context) => Login(),
              "/forget-password": (context) => ForgetPassword(),
              "/user-profile": (context) => UserProfile(),
              "/update-profile": (context) => Update_Profile(),
              "/loading-screen": (context) => LoadingScreen(),
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
            child: Text("Loading...", textDirection: TextDirection.ltr));
      },
    );
  }
}
