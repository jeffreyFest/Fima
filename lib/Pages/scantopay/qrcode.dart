// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Mqr extends StatefulWidget {
  const Mqr({super.key});

  @override
  State<Mqr> createState() => _MqrState();
}

class _MqrState extends State<Mqr> {
  String? imageUrl;

  Future<void> _fetchImageFromFirebase() async {
  final storage = FirebaseStorage.instance;
  final ref = storage.ref().child('profile_pictures').child('${_user!.email}');
  final downloadUrl = await ref.getDownloadURL();
  setState(() {
    imageUrl = downloadUrl;
  });
  }
final FirebaseAuth auth = FirebaseAuth.instance;
   User? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
    _fetchImageFromFirebase();
  }

  void _getUser() async {
    User? user = auth.currentUser;
    setState(() {
  _user = user;
    });
  }
  @override
  Widget build(BuildContext context) {
 return Scaffold(
   backgroundColor: Colors.white,  
  body: Center(
   child: Column(
  children: [
  Container(
   margin: EdgeInsets.only(top: 30),
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(
    width: 1.5,
   color: Color(0xFF2a5ece)
  )
  ),
  child: imageUrl != null ? CircleAvatar(
      radius: 33,
      backgroundImage: NetworkImage(imageUrl!),
      backgroundColor: Colors.transparent,
    ) : CircleAvatar(
      radius: 33,
      backgroundColor: Colors.grey,
      child: Icon(
         Icons.person,
        size: 60,
  color: Colors.white,
      ),
    ),
    ),
  
  SizedBox(height: 10,),
Text('${_user!.displayName}',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black
  )),
 SizedBox(height: 5),
  Text('@ceofima',
  style: TextStyle(
    fontSize: 17,
    color: Colors.black87
  )),

 Container(
  margin: EdgeInsets.only(top: 40),
  child: Image.asset('assets/images/qrcd.png',
  width: 160,
  )
 )
      ],
    ),
  ),
    );
  }
}