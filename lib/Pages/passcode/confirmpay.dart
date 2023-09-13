// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../tools/colors.dart';

class Confirmpay extends StatefulWidget {
  const Confirmpay({super.key});

  @override
  State<Confirmpay> createState() => _ConfirmpayState();
}

class _ConfirmpayState extends State<Confirmpay> {
  TextEditingController pinHolder = TextEditingController();
  
  void _onNumpadButtonPressed(String value) {
    if (pinHolder.text.length < 4) {
      setState(() {
        pinHolder.text += value;
      });
      if (pinHolder.text.length == 4) {
        validatePin();
      }
    }
  }

Future<void> validatePin() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedPasscode = prefs.getString('confirmed_passcode_${currentUser!.uid}');
  if (pinHolder.text == storedPasscode) {
    // Correct PIN, navigate to the next page

  Navigator.pop(context);
  } else {
    // Invalid PIN, show error message
  pinHolder.clear();
     MotionToast(
          displaySideBar: false,
          primaryColor:  Color(0xffff5353),
          backgroundType: BackgroundType.solid,
          secondaryColor:  Color(0xffea4c4b),
          padding: EdgeInsets.only(
            left: 20,
            right: 20
          ),
          width: 270,
          height: 70,
          description: Center(
              child: Text(
              "Invalid Pin, try again",
               textAlign: TextAlign.center ,
               style: TextStyle(
               fontWeight: FontWeight.w500,
                fontSize: 16,
               color: Colors.white,
              ),),
            ),
          position: MotionToastPosition.top,
          animationType:  AnimationType.fromTop,
          animationDuration: Duration(milliseconds: 1),
          toastDuration: Duration(seconds: 3),
        ).show(context);
  }
}

  void _onCancelPressed() {
    if (pinHolder.text.isNotEmpty) {
     setState(() {
      pinHolder.text = pinHolder.text.substring(0, pinHolder.text.length - 1);
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
     children: [
       SizedBox(
        height: 430,
        child: Padding(
          padding: EdgeInsets.only(left: 15, top: 15, right: 15),
          child: Column(
           children: [
            Text('PIN',
            style: TextStyle(
              color: MyColors.textColorD,
             fontWeight: FontWeight.bold,
             fontSize: 19
            ),
            ),
              Container(
                width: 120,
                  height: 40,
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  decoration: BoxDecoration(
                 color: MyColors.txtfieldcolor,
                 borderRadius: BorderRadius.circular(13)),
                  child: Center(
                    child: Padding(
                 padding: const EdgeInsets.only(top:10),
                 child: TextField(
                controller: pinHolder,
                textAlign: TextAlign.center,
                obscuringCharacter: '●',
                obscureText: true,
                style: TextStyle(
                fontSize: 25, 
                color: MyColors.primaryColor,
                fontWeight: FontWeight.bold
                ),
                keyboardType: TextInputType.none,
                inputFormatters: [
               FilteringTextInputFormatter.digitsOnly,
                ],
                cursorColor: MyColors.lighterpriColor,
                decoration: InputDecoration(
               border: InputBorder.none,
                ),
                 ),
                    ),
                  ),
                ),
            
            Column(
                mainAxisAlignment: MainAxisAlignment.end,
               children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKey('1'),
                  _buildKey('2'),
                  _buildKey('3'),
                ],
                 ),
                 Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKey('4'),
                  _buildKey('5'),
                  _buildKey('6'),
                ],
                 ),
                 Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKey('7'),
                  _buildKey('8'),
                  _buildKey('9'),
                ],
                 ),
                 Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 44,
                  ),
                  Center(child: _buildKey('0')),
                  IconButton(
                 onPressed: () {
                  _onCancelPressed();
                 },
                icon: Image.asset('assets/images/clear.png',
                scale: 18,
                color: MyColors.lighterpriColor))
                ],
                 ),     
               ],
                )
           ],
          ),
        ),
       ),
     ],
    );
  }

  Widget _buildKey(String value) {
    return MaterialButton(
      height: 80.0,
      minWidth: 70.0,
      highlightColor: MyColors.lighterpriColor,
      splashColor: Colors.transparent,
      textColor: Colors.white,
      onPressed: () => _onNumpadButtonPressed(value),
      shape: CircleBorder(),
      child: Text(
        value,
        style: TextStyle(fontSize: 29, 
        fontWeight: FontWeight.w500),
      ),
    );
  }
}