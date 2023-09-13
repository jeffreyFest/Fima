// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:fima/tools/colors.dart';
import 'package:flutter/material.dart';

class ShowconnectContact extends StatefulWidget {
  const ShowconnectContact({super.key});

  @override
  _ShowconnectContactState createState() => _ShowconnectContactState();
}

class _ShowconnectContactState extends State<ShowconnectContact> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
           text:'Fima is more fun with\n your ',
          style: TextStyle(
            color: MyColors.textColor1,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
           text:'friends.',
         style: TextStyle(
                  color: MyColors.textColor1,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
            )  
          ]
            ),
          ),

      Container(
        width: double.infinity,
        height: 45,
        margin: EdgeInsets.only(left: 40, right: 40, top:10),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            elevation: 0,
          side: BorderSide(color: MyColors.fadeborderline,),
          ),
          onPressed: () {},
           child: Text(
              'Connect with friends',
              style: TextStyle(
                fontSize: 16,
                color: MyColors.textColor1,
                fontWeight: FontWeight.w500,
              ),
            ),),
      )
        ]
      )
    );
  }
}
