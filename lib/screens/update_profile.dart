// ignore_for_file: use_key_in_widget_constructors, camel_case_types, prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_firebase_auth/screens/user_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class Update_Profile extends StatefulWidget {
  @override
  State<Update_Profile> createState() => _Update_ProfileState();
}

class _Update_ProfileState extends State<Update_Profile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? firstName;
  String? lastName;
  String? email;
  String? image;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool loading = false;

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
        firstNameController.text = firstName!;
        lastNameController.text = lastName!;
        emailController.text = email!;
      }).catchError((e) {
        print(e);
      });
  }

  updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      FirebaseFirestore db = FirebaseFirestore.instance;

      String updateFirstName = firstNameController.text;
      String updateLastName = lastNameController.text;
      db.collection('users').doc(firebaseUser!.uid).update({
        "firstName": updateFirstName,
        "lastName": updateLastName,
      });
      firstName = firstNameController.text;
      lastName = lastNameController.text;

      setState(() {
        firstName;
        lastName;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => UserProfile()),
          (route) => false);
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(e.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Update profile"),
          ),
          body: FutureBuilder(
              future: currentUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.purple,
                  ));

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(image!),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20),
                              child: TextFormField(
                                controller: firstNameController,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  } else if (value.length < 3) {
                                    return "Your name is too short";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "First Name",
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.purple[500],
                                  ),
                                  filled: true,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20),
                              child: TextFormField(
                                controller: lastNameController,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name';
                                  } else if (value.length < 3) {
                                    return "Your name is too short";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Last Name",
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.purple[500],
                                  ),
                                  filled: true,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20),
                              child: TextFormField(
                                readOnly: true,
                                enabled: false,
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.purple[500],
                                  ),
                                  filled: true,
                                ),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: updateProfile,
                                child: Text("Update")),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}
