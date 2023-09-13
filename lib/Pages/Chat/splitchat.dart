// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  User? user;

  @override
  void initState() {
    super.initState();
    displayname();
  }

  displayname(){
   final name = FirebaseAuth.instance.currentUser;
   setState(() {
      user = name;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
         icon: Icon(Icons.arrow_back_ios),
         onPressed: () {},
        ),
      title:Text('${user!.displayName}',
           style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500
           ),
           ),
      ),

    body: ListView(
      children: const [

      ],
    ),
    );
  }
 }