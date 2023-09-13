// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, use_key_in_widget_constructors, non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use, unused_field, prefer_const_declarations, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fima/Pages/loginfima/Login.dart';
import 'package:fima/Pages/passcode/otpcode.dart';
import 'package:fima/auth&database/authService.dart';
import 'package:fima/tools/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../auth&database/emailValidation.dart';

class Createacct extends StatefulWidget {
  const Createacct({Key? key}) : super(key: key);

  @override
  State<Createacct> createState() => _CreateacctState();
}

class _CreateacctState extends State<Createacct> {
  String initialCountry = 'NG';
  bool isLoading = false;
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  final TextEditingController phonenumber = TextEditingController();

  //FOR TEXTFIELD
  TextEditingController _email = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obsecure = false;
  TextEditingController _password = TextEditingController();

  //INITIALIZATION
  @override
  void initState() {
    super.initState();
    enableBtn();
    _obsecure = true;
  }

  //To disable/enable the next button
  bool enableBtn() {
    return _email.text.isNotEmpty &&
        phonenumber.text.length >= 10 &&
        _password.text.length >= 6;
  }

  void fcmToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      saveToken(fcmToken);
    }
  }

  void saveToken(String token) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance.collection('Users').doc(user.email).set({
        'email_address': _email.text,
        'phone_number': phonenumber.text,
        'users_fcmToken': token,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.secondaryColor,
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(
              child: SpinKitThreeBounce(
              color: MyColors.lighterpriColor,
              size: 70,
            ))
          : Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 15, top: 15),
              child: SafeArea(
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: MyColors.textColorD, width: 1)),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => Login())));
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 17,
                                color: MyColors.lighterpriColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: Column(children: [
                        SizedBox(
                          height: 70,
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Signup',
                            style: TextStyle(
                                fontSize: 28,
                                color: MyColors.textColor3,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Signup today & Unleash the attractive\nmoney transactions.',
                              style: TextStyle(
                                  fontSize: 15.5,
                                  color: MyColors.textColor2,
                                  fontWeight: FontWeight.w400),
                            )),
                        Container(
                          width: double.infinity,
                          height: 53,
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                              color: MyColors.txtfieldcolor,
                              borderRadius: BorderRadius.circular(14)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 2,
                            ),
                            child: TextFormField(
                              controller: _email,
                              cursorColor: MyColors.primaryColor,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.textColor1),
                              decoration: InputDecoration(
                                  labelText: 'Email address',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.textColor2),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 6),
                                  hintText: 'fima@gmail.com',
                                  hintStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.textColorD,
                                  ),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 53,
                          margin: EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                              color: MyColors.txtfieldcolor,
                              borderRadius: BorderRadius.circular(14)),
                          child: InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              setState(() {
                                this.number = number;
                              });
                            },
                            selectorConfig: SelectorConfig(
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET,
                                useEmoji: true,
                                showFlags: false),
                            ignoreBlank: true,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle:
                                TextStyle(color: MyColors.textColor2),
                            textFieldController: phonenumber,
                            formatInput: false,
                            cursorColor: MyColors.primaryColor,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            spaceBetweenSelectorAndTextField: 0,
                            countries: ['NG'],
                            textStyle: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: MyColors.textColor1),
                            inputDecoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Phone number',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.textColor2),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 6),
                                hintText: '09073276610',
                                hintStyle: TextStyle(
                                    fontSize: 17,
                                    color: MyColors.textColorD,
                                    fontWeight: FontWeight.w500)),
                            onSaved: (PhoneNumber number) {
                              print('On Saved: $number');
                            },
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 53,
                          margin: EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                              color: MyColors.txtfieldcolor,
                              borderRadius: BorderRadius.circular(14)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 3),
                            child: TextFormField(
                              obscureText: _obsecure,
                              controller: _password,
                              cursorColor: MyColors.primaryColor,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.textColor1),
                              decoration: InputDecoration(
                                hintText: 'Enter Password',
                                hintStyle: TextStyle(
                                    fontSize: 17,
                                    color: MyColors.textColorD,
                                    fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                                labelText: 'Password',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.textColor2),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 6),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      _obsecure
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: MyColors.greybg),
                                  onPressed: () {
                                    setState(() {
                                      _obsecure = !_obsecure;
                                    });
                                  },
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  enableBtn(); // Update the button state on password change
                                });
                              },
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  enableBtn()
                                      ? MyColors.lighterpriColor
                                      : MyColors.disableBtn,
                                ),
                                elevation: MaterialStateProperty.all<double>(0),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        25), // Set border radius
                                  ),
                                ),
                              ),
                              onPressed: enableBtn()
                                  ? () {
                                      _fimaSignUp();
                                    }
                                  : null,
                              child: Text(
                                'Next',
                                style: TextStyle(
                                    color: enableBtn()
                                        ? MyColors.textColor1
                                        : MyColors.textColorD,
                                    fontSize: 17),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  //Signup a user to fima
  void _fimaSignUp() async {
    setState(() {
      isLoading = true; //Start Loading
    });

    final String email = _email.text.trim();
    final String password = _password.text.trim();

    // Check if email matches a specific regex pattern
    if (!EmailValidator.isValidEmail(email)) {
      MotionToast(
        displaySideBar: false,
        primaryColor: MyColors.errorcolor,
        backgroundType: BackgroundType.solid,
        width: 270,
        height: 70,
        description: Center(
          child: Text(
            "Invalid email address",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        position: MotionToastPosition.top,
        animationType: AnimationType.fromTop,
        animationDuration: Duration(milliseconds: 0),
        toastDuration: Duration(seconds: 3),
      ).show(context);

      setState(() {
        isLoading = false; //stop Loading
      });

      //Signup users to my database
      String? signUp = await AuthService.fimaSignUp(
        email: email,
        password: password,
      );
      //Check the user email has been taken
      if (signUp == 'email-already-in-use') {
        MotionToast(
          displaySideBar: false,
          icon: Icons.done_outline_rounded,
          iconSize: 40,
          primaryColor: MyColors.errorcolor,
          backgroundType: BackgroundType.solid,
          width: 270,
          height: 70,
          description: Text(
            "Email already in use",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          position: MotionToastPosition.top,
          animationType: AnimationType.fromTop,
          animationDuration: Duration(milliseconds: 0),
          toastDuration: Duration(seconds: 3),
        ).show(context);
      } else if (signUp == null) {
        //Navigate to the HOMEPAGE
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Verify(
                      email: _email.text,
                      phonenumber: phonenumber.text,
                    )));
      }
      setState(() {
        isLoading = false; //stop Loading
      });
    }
  }
}
