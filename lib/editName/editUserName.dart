// // ignore_for_file: curly_braces_in_flow_control_structures, avoid_print, non_constant_identifier_names, prefer_const_constructors

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class EditUserName extends StatefulWidget {
//   @override
//   _EditUserNameState createState() => _EditUserNameState();
// }

// class _EditUserNameState extends State<EditUserName> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   String? userName;

//   currentUserProfile() async {
//     final firebaseUser = FirebaseAuth.instance.currentUser;
//     if (firebaseUser != null)
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(firebaseUser.uid)
//           .get()
//           .then((ds) {
//         userName = ds.data()!['userName'];
//         print(userName);
//       }).catchError((e) {
//         print(e);
//       });
//   }

//   final TextEditingController editName_controller = TextEditingController();

//   editUser() {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//     try {
//       final firebaseUser = FirebaseAuth.instance.currentUser;
//       final String updatedUserName = editName_controller.text;

//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(firebaseUser!.uid)
//           .update({"userName": updatedUserName});
//       userName = editName_controller.text;

//       setState(() {
//         userName;
//       });
//       Navigator.of(context).pop();
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Form(
//             key: _formKey,
//             child: TextFormField(
//               controller: editName_controller,
//               keyboardType: TextInputType.name,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your name';
//                 } else if (value.length < 3) {
//                   return "Your name is too short";
//                 }
//                 return null;
//               },
//               decoration: InputDecoration(
//                 labelText: "Username",
//                 prefixIcon: Icon(
//                   Icons.person,
//                   color: Colors.purple[500],
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30.0),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//               ),
//             ),
//           ),
//           ElevatedButton(onPressed: editUser, child: Text("Edit name"))
//         ],
//       ),
//     );
//   }
// }
