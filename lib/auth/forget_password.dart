// ignore_for_file: prefer_const_constructors, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth/auth/login.dart';
import 'package:cool_alert/cool_alert.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      print("Password reset email sent");
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));

      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Password reset email sent",
      );
    } catch (e) {
      print(e.toString());
    }
  }

  // @override
  // void dispose() {
  //   emailController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Forget Password")),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isNotEmpty && value.length > 7) {
                      return null;
                    } else if (value.length < 7 && value.isNotEmpty) {
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
              ElevatedButton(
                  onPressed: resetPassword, child: Text("Reset password"))
            ],
          ),
        ),
      ),
    );
  }
}
