// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fima/Pages/scantopay/qrcode.dart';
import 'package:flutter/material.dart';

class Scanoption extends StatefulWidget {
  const Scanoption({super.key});

  @override
  State<Scanoption> createState() => _ScanoptionState();
}

class _ScanoptionState extends State<Scanoption> {
  @override
  Widget build(BuildContext context) {
   return DefaultTabController(length: 2, 
   child: Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: ButtonTheme(
            minWidth: 20,
            height: 20,
           child: MaterialButton(
                 shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
                 ),
           onPressed: () => Navigator.of(context).pop(),
           splashColor: Colors.transparent,
           child: Icon(
             Icons.arrow_back_ios_outlined,
               color: Color(0xFF2a5ece)
           )
           ),
         ),
      title: Container(
        height: 30,
        decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(10),
         border: Border.all(
          width: 0.5,
          color: Color(0xFF2a5ece)
         )
        ),
        child: TabBar(
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFF2a5ece)
          ),
        unselectedLabelColor: Colors.black,
        labelColor: Colors.white,
           labelStyle: TextStyle(
           fontSize: 15,
           fontWeight: FontWeight.w500
                ),
          tabs: [
          Text('My code'),
          Text('Scan'),
        ]
        
        ),
      ),
    actions: [
      IconButton(onPressed: () {},
       icon: Icon(Icons.ios_share,
       color: Color(0xFF2a5ece),
       ))
    ],
    ),
    body: TabBarView(
      children: [
          Mqr(),
          Center(
            child: Text('Chillax ',
            style: TextStyle(
              color: Colors.white24,
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                  ),
            ),
          )
        
      ],
    ),
    ),
   );
  }
}