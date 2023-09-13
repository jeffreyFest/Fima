// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_typing_uninitialized_variables, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:fima/Pages/Settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../tools/colors.dart';

class CurrentPIN extends StatefulWidget {
  CurrentPIN({super.key,});

  @override
  State<CurrentPIN> createState() => _CurrentPINState();
}

class _CurrentPINState extends State<CurrentPIN> {
  TextEditingController verifyPin = TextEditingController();

  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
  super.dispose();
  verifyPin.dispose();
  }

 void _onNumpadButtonPressed(String value) {
  if (verifyPin.text.length < 4) {
    setState(() {
      verifyPin.text += value;
    });
    if (verifyPin.text.length == 4) {
     _validatePasscode();
    } 
  }
}

 void _onCancelPressed() {
    if (verifyPin.text.isNotEmpty) {
     setState(() {
      verifyPin.text = verifyPin.text.substring(0, verifyPin.text.length - 1);
    });
    }
  }

Future<void> _validatePasscode() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedPasscode = prefs.getString('confirmed_passcode_${currentUser!.uid}');
  if (verifyPin.text == storedPasscode) {
    // Correct PIN, navigate to the next page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChangePIN(),
      ),
    );
  } else {
    // Invalid PIN, show error message
   verifyPin.clear();
   MotionToast(
          displaySideBar: false,
          primaryColor: MyColors.errorcolor,
          backgroundType: BackgroundType.solid,
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.secondaryColor,
      body: Padding(
      padding: EdgeInsets.only(left: 20, right:20, top: 15),
        child: SafeArea(
          child: Stack(
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

        Column(
          children: [

         SizedBox(
          height: 50,
          ),

          Align(
            alignment: Alignment.bottomLeft,
            child: Text('Enter your current PIN',
            style: TextStyle(
            fontSize: 23,
            color: MyColors.textColor2,
             fontWeight: FontWeight.w500
                ),),
            ), 
             Container(
          width: double.infinity,
          height: 70,
          margin: EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
              color: MyColors.txtfieldcolor,
              borderRadius: BorderRadius.circular(13)),
          child: Center(
            child: TextField(
                controller: verifyPin,
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
             ]
             ),
           Column(
            mainAxisAlignment: MainAxisAlignment.end,
             children: [
             Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildKey('1'),
                      _buildKey('2'),
                      _buildKey('3'),
                    ],
                  ),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildKey('4'),
                      _buildKey('5'),
                      _buildKey('6'),
                    ],
                  ),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildKey('7'),
                      _buildKey('8'),
                      _buildKey('9'),
                    ],
                  ),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: 44,),
                      Center(child: _buildKey('0')),
                      IconButton(onPressed: ()
                      {
                      _onCancelPressed();
                      }, 
                      icon: Image.asset('assets/images/clear.png',
                      color: MyColors.lighterpriColor))
                    ],
                  ),
           TextButton(
                onPressed: () {},
                 child: Text('Forgot passcode?',
                 style: TextStyle(
                  color: MyColors.lighterpriColor,
                  fontSize: 18
                 ),
                 ))
          ],
          )
            ],
          ),
        ),
      ),
    );
  }

   Widget _buildKey(String value) {
    return MaterialButton(
      height: 80.0,
      minWidth: 85.0,
      highlightColor: MyColors.lighterpriColor,
      splashColor: Colors.transparent,
      textColor: MyColors.textColor2,
      onPressed: () => _onNumpadButtonPressed(value),
      shape: CircleBorder(),
      child: Text(
        value,
        style: TextStyle(
        fontSize: 29,
        fontWeight: FontWeight.w500),
      ),
    );
  }
}




class ChangePIN extends StatefulWidget {

  ChangePIN({super.key});

  @override
  State<ChangePIN> createState() => _ChangePINState();
}

class _ChangePINState extends State<ChangePIN> {
   TextEditingController pinHolder = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
   super.dispose();
   pinHolder.dispose();
  }

  

  void _onNumpadButtonPressed(String value) {
    if (pinHolder.text.length < 4) {
      setState(() {
        pinHolder.text += value;
      });
      if (pinHolder.text.length == 4) {
        // Passcode entry complete, perform validation or other actions here
        Navigator.push(
       context,
       MaterialPageRoute(
       builder: (context) =>
       ConfirmchangedPIN(passcode: pinHolder.text)));
      }
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
    return Scaffold(
      backgroundColor: MyColors.secondaryColor,
    
   body: Padding(
      padding: EdgeInsets.only(left: 20, right:20, top: 15),
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
             height: 50,
            ),

           Align(
            alignment: Alignment.bottomLeft,
            child: Text('Set new PIN',
            style: TextStyle(
               fontSize: 23,
            color: MyColors.textColor2,
             fontWeight: FontWeight.w500
            ),),
            ),

             SizedBox(
              height: 3,
           ),

           Align(
             alignment: Alignment.bottomLeft,
              child: Text('Enter new PIN code to unlock and perform transaction',
              style: TextStyle(
               fontSize: 15.5,
              color: MyColors.textColorD,
            fontWeight: FontWeight.w400
              ),),
              ),

             Container(
               width: double.infinity,
               height: 70,
               margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: MyColors.txtfieldcolor,
            borderRadius: BorderRadius.circular(13)),
           child: Center(
           child: TextField(
          controller: pinHolder,
          textAlign: TextAlign.center,
          obscuringCharacter: '●',
          obscureText: true,
          style: TextStyle(
          fontSize: 25,
          color: MyColors.primaryColor,
          fontWeight: FontWeight.bold),
          keyboardType: TextInputType.none,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          cursorColor: MyColors.lighterpriColor,
          decoration: InputDecoration(
            border: InputBorder.none,
          )
              ),
                 ),
               ),
               ]),
          Column(
          mainAxisAlignment: MainAxisAlignment.end,
            children: [
          Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               _buildKey('1'),
               _buildKey('2'),
               _buildKey('3'),
             ],
           ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               _buildKey('4'),
               _buildKey('5'),
               _buildKey('6'),
             ],
           ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
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
    );
  }

  Widget _buildKey(String value) {
    return MaterialButton(
      height: 80.0,
      minWidth: 85.0,
      highlightColor: MyColors.lighterpriColor,
      splashColor: Colors.transparent,
      textColor: MyColors.textColor2,
      onPressed: () => _onNumpadButtonPressed(value),
      shape: CircleBorder(),
      child: Text(
        value,
        style: TextStyle(fontSize: 29, fontWeight: FontWeight.w500),
      ),
    );
  }
}


class ConfirmchangedPIN extends StatefulWidget {
  final passcode;

  ConfirmchangedPIN( {super.key, required this.passcode});

  @override
  _ConfirmchangedPINState createState() => _ConfirmchangedPINState();
}

class _ConfirmchangedPINState extends State<ConfirmchangedPIN> {
 TextEditingController confirmPin = TextEditingController();
 
  @override
  void dispose() {
    confirmPin.dispose();
    super.dispose();
  }

  void _onNumpadButtonPressed(String value) {
    if (confirmPin.text.length < 4) {
      setState(() {
        confirmPin.text += value;
      });
      if (confirmPin.text.length == 4) {
        storePasscode(confirmPin.text);
        if (confirmPin.text == widget.passcode) {
         Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder:
         (context) => Settingspage()), (route) => false
         );

      MotionToast(
          displaySideBar: false,
          primaryColor:  MyColors.successcolor,
          backgroundType: BackgroundType.solid,
          padding: EdgeInsets.only(
            left: 20,
            right: 20
          ),
          width: 270,
          height: 70,
          description: Center(
            child: Text(
           "PIN successfully changed",
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
       
        } else {

        confirmPin.clear();
       MotionToast(
          displaySideBar: false,
          primaryColor: MyColors.errorcolor,
          backgroundType: BackgroundType.solid,
          padding: EdgeInsets.only(
            left: 20,
            right: 20
          ),
          width: 270,
          height: 70,
          description: Center(
            child: Text(
           "PIN does\'nt match",
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
    }
  }

 void _onCancelPressed() {
    if (confirmPin.text.isNotEmpty) {
     setState(() {
      confirmPin.text = confirmPin.text.substring(0, confirmPin.text.length - 1);
    });
    }
  }

  Widget _buildKey(String value) {
    return MaterialButton(
      height: 80.0,
      minWidth: 85.0,
      highlightColor: MyColors.lighterpriColor,
      splashColor: Colors.transparent,
      textColor: MyColors.textColor2,
      onPressed: () => _onNumpadButtonPressed(value),
      shape: CircleBorder(),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 29,
        fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: MyColors.secondaryColor,
     body: Padding(
        padding: EdgeInsets.only(left: 20, right:20,
        top: 15
        ),
        child: SafeArea(
          child: Stack(
            children: [
               Column(
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

         SizedBox(
             height: 50,
            ),

           Align(
            alignment: Alignment.bottomLeft,
            child: Text('Please Re-type your PIN',
            style: TextStyle(
               fontSize: 23,
              color: MyColors.textColor2,
             fontWeight: FontWeight.w500
            ),),
      
            ),
          Container(
               width: double.infinity,
               height: 70,
               margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: MyColors.txtfieldcolor,
            borderRadius: BorderRadius.circular(13)),
           child: Center(
           child: TextField(
          controller: confirmPin,
          textAlign: TextAlign.center,
          obscuringCharacter: '●',
          obscureText: true,
          style: TextStyle(
          fontSize: 25,
          color: MyColors.primaryColor,
          fontWeight: FontWeight.bold),
          keyboardType: TextInputType.none,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          cursorColor: MyColors.lighterpriColor,
          decoration: InputDecoration(
            border: InputBorder.none,
          )
              ),
                 ),
               ),
               ]),
        
          Column(
          mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               _buildKey('1'),
               _buildKey('2'),
               _buildKey('3'),
             ],
           ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               _buildKey('4'),
               _buildKey('5'),
               _buildKey('6'),
             ],
           ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              icon:
               Image.asset('assets/images/clear.png',
               color: MyColors.lighterpriColor))
             ],
           ),
        ],
          )
            ],
          ),
        ),
      ),
    );
  }

Future<void> storePasscode(String passcode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  User? currentUser = FirebaseAuth.instance.currentUser;
  await prefs.setString('confirmed_passcode_${currentUser!.uid}', passcode);
}
}