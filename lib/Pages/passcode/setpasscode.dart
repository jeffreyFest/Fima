// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fima/Pages/getStarted.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../tools/colors.dart';
import '../Homepage/homeNav.dart';

class Passcode extends StatefulWidget {
  final ValueChanged<String>? onTextChanged;

  Passcode({super.key, this.onTextChanged});

  @override
  State<Passcode> createState() => _PasscodeState();
}

class _PasscodeState extends State<Passcode> {
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
       ConfirmPasscodeScreen(passcode: pinHolder.text)));
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
        padding: EdgeInsets.only(left: 20, right:20,
        bottom: 15, top: 15),
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
              alignment: Alignment.topLeft,
              child: Text('Set PIN',
              style: TextStyle(
                 fontSize: 23,
                color:MyColors.textColor2,
                 fontWeight: FontWeight.w500
              ),),
            ),
            
             SizedBox(
              height: 10,
           ),
           Align(
             alignment: Alignment.topLeft,
              child: Text('Setup a PIN for accessing your account and perfrom transactions',
              style: TextStyle(
          fontSize: 15.5,
          color: MyColors.textColorD,
          fontWeight: FontWeight.w400
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
                 child: Padding(
              padding: const EdgeInsets.only(),
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
          cursorColor: MyColors.primaryColor,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
              ),
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
        style: TextStyle(fontSize: 29, 
        fontWeight: FontWeight.w500),
      ),
    );
  }
}

class ConfirmPasscodeScreen extends StatefulWidget {
  final passcode;

  ConfirmPasscodeScreen({super.key, required this.passcode});

  @override
  _ConfirmPasscodeScreenState createState() => _ConfirmPasscodeScreenState();
}

class _ConfirmPasscodeScreenState extends State<ConfirmPasscodeScreen> {
 TextEditingController confirmPin = TextEditingController();
 bool isLoading = false;
 
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
      if ( confirmPin.text.length == 4) {
        if ( widget.passcode == confirmPin.text) {
          setState(() {
            isLoading = true;
          });

         storePasscode(confirmPin.text).then((_){
          Future.delayed(
            Duration(seconds: 1 ), () {
            Navigator.push(
             context, MaterialPageRoute(builder: (context) => Homenav()));

          MotionToast(
          displaySideBar: false,
          primaryColor: MyColors.successcolor,
          backgroundType: BackgroundType.solid,
       width: 300,
       height: 60,
       description: Center(
         child: Text(
           "Account created successfully",
           style: TextStyle(
             fontWeight: FontWeight.w500,
             fontSize: 16,
             color: Colors.white,
           ),
         ),
       ),
       position: MotionToastPosition.top,
       animationType: AnimationType.fromTop,
       animationDuration: Duration(milliseconds: 1),
       toastDuration: Duration(seconds: 2),
          ).show(context);
          
           setState(() {
           isLoading = false;
         });
            }
          );
         });  
        } else {
          // Passcodes don't match, show an error message
          confirmPin.clear();
        MotionToast(
          displaySideBar: false,
          primaryColor:  MyColors.errorcolor,
          backgroundType: BackgroundType.solid,
          padding: EdgeInsets.only(
            left: 20,
            right: 20
          ),
          width: 300,
          height: 70,
          description: Center(
              child: Text(
              "Pin doesn't match, try again",
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

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor:MyColors.secondaryColor,
      body: isLoading ? Center(
      child:  SpinKitThreeBounce(
      color: MyColors.primaryColor,
      size: 70,
      ) )
      : Padding(
        padding: EdgeInsets.only(left: 20, right:20,
        bottom: 15, top: 15),
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
            height: 70,
            ),

           Align(
            alignment: Alignment.bottomLeft,
            child: Text('Confirm your PIN',
            style: TextStyle(
               fontSize: 23,
              color:MyColors.textColor2,
               fontWeight: FontWeight.w500
            ),),
            ),
            
             SizedBox(
              height: 10,
           ),

            Align(
              alignment: Alignment.bottomLeft,
              child: Text('Please Re-type your PIN',
              style: TextStyle(
          fontSize: 15.5,
          color: MyColors.textColorD,
          fontWeight: FontWeight.w400
              ),),
          ),
        
          Container(
          width: double.infinity,
          height: 70,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: MyColors.txtfieldcolor,
              borderRadius: BorderRadius.circular(13)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(),
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
                cursorColor: MyColors.primaryColor,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
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
               scale: 18,
               color:MyColors.lighterpriColor))
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
        style: TextStyle(fontSize: 29,
         fontWeight: FontWeight.w500),
      ),
    );
  }

Future<void> storePasscode(String passcode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  User? currentUser = FirebaseAuth.instance.currentUser;
  await prefs.setString('confirmed_passcode_${currentUser!.uid}', passcode);
}
}


class Loginpasscode extends StatefulWidget {
  Loginpasscode({
    super.key,
  });

  @override
  State<Loginpasscode> createState() => _LoginpasscodeState();
}

class _LoginpasscodeState extends State<Loginpasscode> {
  TextEditingController loginPin = TextEditingController();
  String firstName = '';
  User? getuser = FirebaseAuth.instance.currentUser;
  String? _profilePictureUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getFirstName();
    updateFimaTag();
    _getProfilePicture();
  }

  void _onNumpadButtonPressed(String value) {
  if (loginPin.text.length < 4) {
    setState(() {
      loginPin.text += value;
    });
    if (loginPin.text.length == 4) {
        setState(() {
      isLoading = true;
    });
     Future.delayed(Duration(seconds: 1), () {
      _validatePasscode();
     setState(() {
      isLoading = false;
    });
     });   
    } 
  }
}

  void _onCancelPressed() {
    if (loginPin.text.isNotEmpty) {
     setState(() {
      loginPin.text = loginPin.text.substring(0, loginPin.text.length - 1);
    });
    }
  }


Future<void> _validatePasscode() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedPasscode = prefs.getString('confirmed_passcode_${currentUser!.uid}');
  if (loginPin.text == storedPasscode) {
    // Correct PIN, navigate to the next page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Homenav(),
      ),
    );
  } else {
    // Invalid PIN, show error message
    loginPin.clear();
     MotionToast(
          displaySideBar: false,
          primaryColor:  MyColors.errorcolor,
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

  Future<void> _getProfilePicture() async{
 SharedPreferences prefs = await SharedPreferences.getInstance();
  final profilePictureUrl = prefs.getString('profilePictureUrl_${getuser!.uid}');

  setState(() {
    _profilePictureUrl = profilePictureUrl;
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor:MyColors.secondaryColor,
      
      body: isLoading ? Center(
      child:  SpinKitThreeBounce(
      color: MyColors.primaryColor,
      size: 70,
      ) )
      : Padding(
        padding: EdgeInsets.only(left: 25, right:25,
        bottom: 15, top: 15),
        child: SafeArea(
          child: Stack(
            children: [
              
             GestureDetector(
            onTap: () {
             FirebaseAuth.instance.signOut().then((value) {
             Navigator.pushAndRemoveUntil(
             context, MaterialPageRoute(
              builder: (context) => Getstarted()),
                 (route) => false);
                 });
              },
               child: Container(
                width: 95,
                height: 30,
                decoration: BoxDecoration(
                 color: MyColors.bottomNav,
                 borderRadius: BorderRadius.circular(10)
                ),
               child: Center(
                 child: Text(
                   'Log Out',
                    style: TextStyle(
                   fontSize: 17,
                   color: Color.fromARGB(219, 250, 19, 3),
                   fontWeight: FontWeight.w500),
                 ),
               ),
             
               ),
             ),

             
              Column(
                children: [
                SizedBox(
                  height: 90,
                ),
               Align(
                alignment: Alignment.centerLeft,
                 child: Container(
                    decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 border: Border.all(
                   width: 1.5,
                 color: MyColors.primaryColor,
                 )
                    ),
                           child:_profilePictureUrl != null
                 ? ClipOval(
                     child: CachedNetworkImage(
                     imageUrl: _profilePictureUrl!,
                     fit: BoxFit.cover,
                     width: 70,
                     height: 70,
                         ),
                       )
                 : CircleAvatar(
                     radius: 30,
                     backgroundColor: Color.fromARGB(255, 218, 215, 215),
                     child: Icon(
                       Icons.person,
                       size: 50,
                       color: Colors.grey,
                     ),
                   ),
                   ),
               ),
                Container(
               margin: EdgeInsets.only(top: 5),
               alignment: Alignment.centerLeft,
               child: RichText(
                 text: TextSpan(
                   text: 'Hello, $firstName',
                   style: TextStyle(
                     fontSize: 23,
                     color: MyColors.textColor3,
                     fontWeight: FontWeight.bold),
                 ),
               )),
               
               Container(
                width: double.infinity,
                height: 70,
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    color: MyColors.txtfieldcolor,
                    borderRadius: BorderRadius.circular(13)),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(),
                    child: TextField(
                      controller: loginPin,
                      textAlign: TextAlign.center,
                      obscuringCharacter: '●',
                      obscureText: true,
                      style: TextStyle(
                      color: MyColors.primaryColor,
                     fontSize: 25,
                      fontWeight: FontWeight.bold),
                      keyboardType: TextInputType.none,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      cursorColor: MyColors.primaryColor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
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
                    scale: 18,
                    color:MyColors.lighterpriColor))
                  ],
                ),
                TextButton(
               onPressed: () {},
               child: Text(
                 'Forgot PIN?',
                 style: TextStyle(
                  color: MyColors.textColor3,
                  fontSize: 18),
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
        style: TextStyle(fontSize: 29, fontWeight: FontWeight.w500),
      ),
    );
  }


  Future<void> getFirstName() async {
 SharedPreferences prefs = await SharedPreferences.getInstance();
 String? retrieveFirstName = prefs.getString('savedfirstname_${getuser!.uid}');

 if(retrieveFirstName != null){
  //Already saved, use it
  setState(() {
    firstName = retrieveFirstName;
  });
 }else{
 //Not saved you it
 DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users') // Replace with your collection name
        .doc('${getuser!.email}') // Replace with your document ID
        .get();

    if (snapshot.exists) {
      // Document exists
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      String getFirstName = data['first_name'];

      setState(() {
      firstName = getFirstName;
      });

    prefs.setString('savedfirstname_${getuser!.uid}', getFirstName);
    } else {
    }
 }
 }

 void updateFimaTag() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc('${getuser!.email}')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        // Document has changed
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String updatedFirstName = data['first_name'];
        setState(() {
          firstName = updatedFirstName;
        });

        // Cache the updated name
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('savedfirstname_${getuser!.uid}', updatedFirstName);
        });
      } else {
        // Clear the cached name
        SharedPreferences.getInstance().then((prefs) {
          prefs.remove('savedfirstname_${getuser!.uid}');
        });
      }
    });
 }}
