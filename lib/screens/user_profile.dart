// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_print, sized_box_for_whitespace, use_key_in_widget_constructors, avoid_unnecessary_containers, unnecessary_string_interpolations, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/auth/login.dart';
import 'package:flutter_firebase_auth/editName/editUserName.dart';
import 'package:flutter_firebase_auth/screens/home.dart';
import 'package:flutter_firebase_auth/screens/update_profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  dynamic firstName;
  dynamic lastName;
  String? email;
  String? image;

  Stream profilesStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

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

  goToHome() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  void closeDialog() {
    Navigator.of(context).pop();
  }

  void viewImage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: closeDialog,
            child: Container(
                height: 500,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(image!),
                  ),
                )),
          );
        });
  }

  logOut() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final googleSignIn = GoogleSignIn();

    await auth.signOut();
    googleSignIn.disconnect();
    setState(() {});
    print("user diconnected");

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  void logOutDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.purple,
                  ),
                  Text(
                    "  Log Out",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text("Are you sure you want to logout from your account?"),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: closeDialog,
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )),
                  SizedBox(
                    width: 50,
                  ),
                  TextButton(
                    onPressed: logOut,
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Text(
                      "LogOut",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ));
        });
  }

  final TextEditingController editFirstName_controller =
      TextEditingController();

  final TextEditingController editLastName_controller = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    editFirstName_controller.text = firstName;
  }

  editUserFirstName() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final String updatedUserName = editFirstName_controller.text;

      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser!.uid)
          .update({"firstName": updatedUserName});
      firstName = editFirstName_controller.text;

      setState(() {
        firstName;
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  editFirstName() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: editFirstName_controller,
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
                      labelText: "First name",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.purple[500],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: editUserFirstName, child: Text("Edit name"))
              ],
            ),
          );
        });
  }

  editUserlastName() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final String updatedUserLastName = editLastName_controller.text;

      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser!.uid)
          .update({"lastName": updatedUserLastName});
      lastName = editLastName_controller.text;

      setState(() {
        lastName;
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  editLastName() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: editLastName_controller,
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
                      labelText: "Last name",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.purple[500],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: editLastName, child: Text("Edit last name"))
              ],
            ),
          );
        });
  }

  goToUpdateProfile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Update_Profile()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Center(
                  child: Text(
                "Account Details",
                style: TextStyle(color: Colors.black),
              )),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: goToHome,
              ),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    onPressed: logOutDialog),
              ],
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
                    child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 8),
                        child: Column(children: [
                          Center(
                            child: Container(
                              child: GestureDetector(
                                onTap: viewImage,
                                child: CircleAvatar(
                                  radius: 100,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(image ?? ''),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ListTile(
                              title: Text(
                                "First name: $firstName",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              // trailing: IconButton(
                              //     onPressed: editFirstName,
                              //     icon: Icon(Icons.edit)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ListTile(
                              title: Text(
                                "Last name: $lastName",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              // trailing: IconButton(
                              //     onPressed: editLastName,
                              //     icon: Icon(Icons.edit)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "Email: ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Text(
                                  email!,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: goToUpdateProfile,
                              child: Text("Update profile"))
                        ])),
                  );
                })));
  }
}
