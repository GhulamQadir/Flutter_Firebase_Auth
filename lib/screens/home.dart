// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/auth/login.dart';
import 'package:flutter_firebase_auth/screens/user_profile.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  logOut() async {
    await auth.signOut();
    googleSignIn.disconnect();
    setState(() {});
    print("user diconnected");

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  String? firstName;
  String? lastName;
  String? email;
  String? image;
  currentUserProfile() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        firstName = ds.data()!['firstName'];
        lastName = ds.data()!['lastName'];
        email = ds.data()!['email'];
        image = ds.data()!['image'];
      }).catchError((e) {
        print(e);
      });
  }

  goToProfile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserProfile()));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Home Screen"),
            actions: [
              GestureDetector(
                  onTap: logOut,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, right: 10),
                    child: Text(
                      "LogOut",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  )),
            ],
          ),
          drawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.grey[200],
            ),
            child: Drawer(
              child: SafeArea(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                      future: currentUserProfile(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done)
                          return CircularProgressIndicator();

                        return Row(
                          children: [
                            Container(
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(image ?? ''),
                              ),
                            ),
                            Text("$firstName $lastName")
                          ],
                        );
                      }),
                  Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: GestureDetector(
                          onTap: goToProfile,
                          child: Text(
                            "Profile",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          )),
                    )
                  ])
                ],
              )),
            ),
          )),
    );
  }
}
