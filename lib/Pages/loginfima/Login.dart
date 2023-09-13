// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, use_key_in_widget_constructors, non_constant_identifier_names, use_build_context_synchronously, unnecessary_null_comparison, unused_field

import 'package:fima/Pages/Homepage/homeNav.dart';
import 'package:fima/Pages/joinFima/createacct.dart';
import 'package:fima/auth&database/authService.dart';
import 'package:fima/tools/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

import '../../auth&database/emailValidation.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obsecure = false; // Bool to hide the password
  bool _buttonDisabled = true; //Bool to disable button
  bool isLoading = false; //Bool to showing Loadinganimation

  @override
  void initState() {
    super.initState();
    enableBtn();
    _obsecure = true;
  }

  bool enableBtn() {
    return _email.text.isNotEmpty && _password.text.length >= 6;
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
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
                                    builder: ((context) => Createacct())));
                          },
                          child: Text(
                            'Signup',
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: 70,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 28,
                                  color: MyColors.textColor3,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 8),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Welcome back, you have been missed',
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
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  cursorColor: MyColors.primaryColor,
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
                                          color: MyColors.textColorD,
                                          fontWeight: FontWeight.w500),
                                      border: InputBorder.none),
                                  onChanged: ((_) {
                                    setState(() {
                                      enableBtn();
                                    });
                                  })),
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
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.done,
                                  cursorColor: MyColors.lighterpriColor,
                                  style: TextStyle(
                                      fontSize: 16.5,
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
                                      )),
                                  onChanged: ((_) {
                                    setState(() {
                                      enableBtn();
                                    });
                                  })),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: MyColors.textColor3,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
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
                                ? () async {
                                    _LoginFima();
                                  }
                                : null,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: enableBtn()
                                      ? MyColors.textColor2
                                      : MyColors.textColorD,
                                  fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  //Login a user into fima
  void _LoginFima() async {
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
    }

    //Login users to my database
    String? LoginUser = await AuthService.fimaLogin(
      email: email,
      password: password,
    );
    if (LoginUser == 'user-not-found') {
      MotionToast(
        displaySideBar: false,
        icon: Icons.done_outline_rounded,
        iconSize: 40,
        primaryColor: MyColors.errorcolor,
        backgroundType: BackgroundType.solid,
        width: 270,
        height: 70,
        description: Text(
          "Account not found",
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
    } else if (LoginUser == 'wrong-password') {
      //Check the user email has been taken
      MotionToast(
        displaySideBar: false,
        icon: Icons.done_outline_rounded,
        iconSize: 40,
        primaryColor: MyColors.errorcolor,
        backgroundType: BackgroundType.solid,
        width: 270,
        height: 70,
        description: Text(
          "Invalid password,try again",
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
    } else if (LoginUser == null) {
      //Navigate to the HOMEPAGE
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Homenav()), (route) => false);
    }
    setState(() {
      isLoading = false; //stop Loading
    });
  }
}
