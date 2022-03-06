// @dart=2.8
// ignore_for_file: file_names, prefer_const_constructors, avoid_print, unnecessary_null_comparison, dead_code, sized_box_for_whitespace, avoid_unnecessary_containers, use_key_in_widget_constructors, missing_return
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

import '../screens/home.dart';
import '../screens/loading_screen.dart';
import 'sign_up.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<UserCredential> loginWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      setState(() {
        loading = true;
      });

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      var signCre =
          await FirebaseAuth.instance.signInWithCredential(credential);

      String fullName = googleUser.displayName;

      var names = fullName.split(' ');
      var firstName = names[0];
      var lastName = fullName.replaceAll(firstName, "");

      // var lastName = names[1];

      db
          .collection('users')
          .where('email', isEqualTo: signCre.user.email)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          db.collection("users").doc(signCre.user.uid).set({
            "firstName": firstName,
            "lastName": lastName,
            "email": googleUser.email,
            "image": googleUser.photoUrl
          });
        }
      });

      // var signCre =
      //     await FirebaseAuth.instance.signInWithCredential(credential);
      // await db.collection("users").doc(signCre.user.uid).set({
      //   "userName": googleUser.displayName,
      //   "email": googleUser.email,
      //   "image": googleUser.photoUrl
      // });

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()), (route) => false);
    } catch (e) {
      setState(() {
        loading = false;
      });

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
      print(e.message);

      print(e.message.toString());
    }
  }

  loginWithEmailPassword() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });

    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      final String email = emailController.text;
      final String password = passwordController.text;
      final UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()), (route) => false);
    } catch (e) {
      setState(() {
        loading = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
      print(e.message);
    }
  }

  goToSignUpScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  goToHome() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingScreen()
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                title: Center(child: Text("Login")),
                backgroundColor: Colors.purple[500],
              ),
              body: SafeArea(
                  child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          height: 150,
                          width: 200,
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.purple[500],
                            size: 150,
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20),
                              child: TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value.isNotEmpty && value.length > 7) {
                                    return null;
                                  } else if (value.length < 7 &&
                                      value.isNotEmpty) {
                                    return "Your email address is too short";
                                  } else {
                                    return "Please enter your email address";
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  prefixIcon: Icon(
                                    Icons.email,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20),
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please enter your password";
                                  } else if (value.length < 6) {
                                    return "Your password is too short";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: Icon(
                                    Icons.lock,
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
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Container(
                                  width: 150,
                                  child: TextButton(
                                      onPressed: loginWithEmailPassword,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.purple[500]),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                          )))),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 13, bottom: 10),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Don't have an account? "),
                                    GestureDetector(
                                        onTap: goToSignUpScreen,
                                        child: Text(
                                          "Create one",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.purple[500]),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                  width: 180,
                                  child: TextButton(
                                      onPressed: loginWithGoogle,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Login with Google",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.purple[500]),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                          )))),
                            ),
                          ],
                        ),
                      ),
                    ]),
              )),
            ),
          );
  }
}
