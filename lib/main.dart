// ignore_for_file: prefer_const_constructors, override_on_non_overriding_member

import 'package:fima/Pages/paybills/buyairtime.dart';
import 'package:fima/Pages/paybills/buydata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'Pages/Homepage/homeNav.dart';
import 'Pages/getStarted.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(57, 20, 20, 19), // transparent status bar
  ));
  await Firebase.initializeApp();
  initializeDateFormatting('en_NG').then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Flexible(
        child: StreamBuilder<User?>(
          stream: _auth.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center();
            } else {
              if (snapshot.hasData) {
                // User is logged in
                return Homenav();
              } else {
                // User is logged out
                return Getstarted();
              }
            }
          },
        ),
      ),
    );
  }
}
