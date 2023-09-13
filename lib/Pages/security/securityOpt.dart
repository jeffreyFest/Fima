// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'package:flutter/material.dart';

import '../../tools/colors.dart';

class SecurityOpt extends StatelessWidget {
  const SecurityOpt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: MyColors.secondaryColor,
 body: Padding(padding: 
    EdgeInsets.only(left: 20, right: 20),
  child: SafeArea(
    child: Stack(
      children: [
        Row(
     children: [
       Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(   
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: MyColors.textColorD,
            width: 1
          )
        ),
        child: IconButton(
         highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: () {
          Navigator.pop(context);
          },
       icon: Icon(
        Icons.arrow_back_ios_new,
        color: MyColors.textColorD,
        size: 13,
         )),
       ),
       ],
             ),
        Column(
          children: [

        SizedBox(
            height: 60,
           ),

        Align(
         alignment: Alignment.centerLeft,
          child: Text('Verification',
          style: TextStyle(
            fontSize: 24,
           color: MyColors.textColor1,
            fontWeight: FontWeight.w600
          ),),
             ),
          SizedBox(
            height: 10,
          ),
      
      Align(
      alignment: Alignment.bottomLeft,
       child: Text(
          'We need you to verify your identity to unlock all features of the app',
        style: TextStyle(
        fontSize: 15.5,
        color: MyColors.textColorD,
        fontWeight: FontWeight.w400
      ),)
        ),
      
      GestureDetector(
          onTap: (){
          },
          child: Container(
          width: double.infinity,
           height: 75,
           margin: EdgeInsets.only(top:20),
           padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: MyColors.txtfieldcolor,
              borderRadius: BorderRadius.circular(15)
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Text('Change PIN',
          style: TextStyle(
            fontSize: 17,
            color: MyColors.textColor2,
            fontWeight: FontWeight.w500
          ),),
      
         
         Container(
           margin: EdgeInsets.only(right: 10),
           child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: MyColors.textColorD,
            size: 18,
           )
          )
            ]
          )
          ),
      ),
      
       //For ID(identity) verification
      Container(
      width: double.infinity,
       height: 75,
       margin: EdgeInsets.only(top:20),
       padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: MyColors.txtfieldcolor,
            borderRadius: BorderRadius.circular(15)
            ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
      Text('Change Password',
      style: TextStyle(
          fontSize: 17,
          color: MyColors.textColor2,
          fontWeight: FontWeight.w500
      ),),
      
       Container(
           margin: EdgeInsets.only(right: 10),
           child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: MyColors.textColorD,
            size: 18,
           )
          )
      ]),
      ),
            ],
          ),
        ],
    ),
  )
     ),
    );
  }
}
  