// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class Splitpage extends StatefulWidget {
  const Splitpage({super.key});

  @override
  State<Splitpage> createState() => _SplitpageState();
}

class _SplitpageState extends State<Splitpage> {
  TextEditingController srch = TextEditingController();
  @override
  Widget build(BuildContext context) {
  return  Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.asset('assets/images/bill.png',
            color: Color(0xFF2a5ece),
            scale: 7,
            ),
    
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
            text: 'Easy split payment from\n',
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.w500
            ),
          children: [
            TextSpan(
            text: 'trips to group gifts',
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.w500
            ),)
          ]
          )),
          SizedBox(
            height: 20,
          ),
    
          Container(
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffccf0fe),
            ),
            child: TextButton(
              onPressed: () {},
             child: Text(
              'Create group',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15
              ),
             ),
            ))
          ]),
    ),
  );
  }
}