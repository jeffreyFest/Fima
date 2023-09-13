// ignore_for_file: prefer_const_constructors

import 'package:fima/Pages/getStarted.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Streaks extends StatefulWidget {
  const Streaks({super.key});

  @override
  State<Streaks> createState() => _StreaksState();
}

class _StreaksState extends State<Streaks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value){
                   Navigator.pushAndRemoveUntil(context,
                     MaterialPageRoute(builder:
                    (context) => Getstarted()), (route) => false
                   );
                });
              },
             icon: Icon(Icons.exit_to_app_outlined,
             size: 32,
             color:  Color(0xFF4B2DC4),))
          ],
        ),
      ),
    );
  }
}