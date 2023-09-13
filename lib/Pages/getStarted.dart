// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fima/Pages/joinFima/createacct.dart';
import 'package:fima/Pages/loginfima/Login.dart';
import 'package:fima/tools/colors.dart';
import 'package:flutter/material.dart';

class Getstarted extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.secondaryColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 120,
                ),
               Image.asset('assets/images/fimalogo.png',
               color: MyColors.textColor3,),
               SizedBox(
            height: 150,
             child: DefaultTextStyle(
              style: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
               ),
               child: AnimatedTextKit(
              pause: Duration(seconds: 0),
              repeatForever: true,
              animatedTexts: [
                FadeAnimatedText('Bank with ease.\nsocialize with fun!',
                textStyle: TextStyle(
                  color: MyColors.textColor3
                ),
                duration: Duration(seconds: 3),
                fadeOutBegin: 0.8,
                fadeInEnd: 0.7),
                FadeAnimatedText('do it RIGHT!!',
                textStyle: TextStyle(
                  color: MyColors.textColor3
                ),
                duration: Duration(seconds: 3),
                fadeOutBegin: 0.8,
                fadeInEnd: 0.7),
                FadeAnimatedText('do it RIGHT NOW!!!',
                textStyle: TextStyle(
                  color: MyColors.textColor3
                ),
                fadeOutBegin: 0.8,
                fadeInEnd: 0.7),
              ],
               ),
             ),
               ),
              ],
            ),
      
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
         children: [
          Container(
          width: double.infinity,
          height: 50,
          margin: EdgeInsets.only(bottom: 10, top: 20),
          child: ElevatedButton(
            style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              MyColors.lighterpriColor
            ),
             elevation:  MaterialStateProperty.all<double>(0),
             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Set border radius
              ),
            ),
            ),
           onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(
                builder: (context) => Createacct()));
           } ,
           child: Text('Create account',
           style: TextStyle(
         color: MyColors.secondaryColor,
         fontSize: 17
           ),
           ),
          ),
          ),
            
            SizedBox(
              height: 10,
            ),
               Container(
            margin: EdgeInsets.only(left: 30, right: 30),
             child: ButtonTheme(
                  minWidth: double.infinity,
                  height: 46,
                  splashColor: Colors.transparent,
                  child: MaterialButton(
                  splashColor: Colors.transparent,
                  onPressed: () {
                    Navigator.push(context,
                         MaterialPageRoute(
                          builder: (context) => Login()));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                  ),
                   child:  Text(
                    'Login into account',
                       style: TextStyle(
                       fontSize: 17,
                       color: MyColors.textColor2,
                       fontWeight: FontWeight.w500
                        ),
                     ),
                        )
                      ),
               ),
         ],
        ),
          ],
        ),
      ),
    );
  }
}


    