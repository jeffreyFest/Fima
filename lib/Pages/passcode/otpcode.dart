// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, must_be_immutable

import 'dart:async';
import 'package:fima/Pages/joinFima/username.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../tools/colors.dart';

class Verify extends StatefulWidget {
  String phonenumber;
  String email;
  Verify({Key? key, required this.phonenumber, required this.email})
      : super(key: key);

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  TextEditingController otp = TextEditingController();
  bool disable = true; //Bool to disable button
  Timer? _timer;
  int _countdown = 30; // the intitial countdown time
  bool _timerActive = false; // False to disactive timer if the countdown has stopped

  @override
  void initState() {
    super.initState();
    enableBtn(); //For Next button
    startTimer(); //Fot the timer 
  }

  @override
  void dispose() {
    super.dispose();
    otp.dispose();
    _timer?.cancel();
  }
  
  //To start the timer 
  void startTimer() {
    if (!_timerActive) {
      _timerActive = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdown > 0) {
            _countdown--;
          } else {
            _timerActive = false;
            _timer?.cancel(); //Cancel Timer
          }
        });
      });
    }
  }
  

  //Resend the timer
  void resendCode() {
    if (!_timerActive) {
      // Perform the action to resend the code
      setState(() {
        _countdown = 30;
      });
      startTimer();
    }
  }

  bool enableBtn(){
   return otp.text.length == 6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.secondaryColor,
      body: Padding(
        padding: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 15),
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
                        border:
                            Border.all(color: MyColors.textColorD, width: 1)),
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
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Enter OTP',
                      style: TextStyle(
                          fontSize: 28,
                          color: MyColors.textColor3,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: RichText(
                      text: TextSpan(
                          text:
                              'Kindly enter the 6-digit code that was sent to your email.',
                          style: TextStyle(
                              fontSize: 15.5,
                              color: const Color.fromARGB(255, 122, 121, 121),
                              fontWeight: FontWeight.w400),
                          children: [
                            TextSpan(
                              text: '\n',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: MyColors.textColor2,
                                  fontWeight: FontWeight.w500),
                            ),
                          ]),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                        color: MyColors.txtfieldcolor,
                        borderRadius: BorderRadius.circular(14)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: otp,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25,
                              color: MyColors.textColor1,
                              fontWeight: FontWeight.w500),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          cursorColor: MyColors.primaryColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Enter OTP',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: MyColors.textColor2),
                            contentPadding: EdgeInsets.symmetric(vertical: 6),
                            hintText: '000 000',
                            hintStyle: TextStyle(
                                fontSize: 25,
                                color: MyColors.textColorD,
                                fontWeight: FontWeight.w500),
                          ),
                         onChanged: (value) {
                            setState(() {
                              enableBtn(); // Update the button state on password change
                            });
                            },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t receive Otp?',
                        style: TextStyle(
                            fontSize: 14,
                            color: MyColors.textColor3,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      _timerActive
                          ? Container(
                              width: 100,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: Color(0xffedeef3),
                                  borderRadius: BorderRadius.circular(13)),
                              child: Center(
                                  child: Text(
                                'Resend in $_countdown',
                                style: TextStyle(
                                    fontSize: 12.7,
                                    fontWeight: FontWeight.w500),
                              )),
                            )
                          : GestureDetector(
                            onTap:  _timerActive ? null : resendCode,
                            child: Container(
                                width: 100,
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(88, 14, 52, 245),
                                    borderRadius: BorderRadius.circular(13)),
                                child: Center(
                                  child: Text(
                                      'Resend OTP',
                                      style: TextStyle(
                                          fontSize: 12.7,
                                          color: MyColors.textColor3,
                                          fontWeight: FontWeight.w500),
                                    ),
                                ),
                              ),
                          )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                           enableBtn() ? MyColors.lighterpriColor : //for if the button is enable
                            MyColors.disableBtn, //for if the button is disable
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(25), // Set border radius
                          ),
                        ),
                      ),
                      onPressed: enableBtn() ? () async {
                        Navigator.push(
                          context,
                           MaterialPageRoute(
                            builder: (context) => Username(
                              email: widget.email,
                              PhoneNumber: widget.phonenumber)));
                      } : null,
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: enableBtn() ? 
                            MyColors.textColor1 //for if the button is enable
                            : MyColors.textColorD, //for if the button is disable
                           fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
