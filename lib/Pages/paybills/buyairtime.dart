// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:fima/tools/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Buyairtime extends StatefulWidget {
  const Buyairtime({super.key});

  @override
  State<Buyairtime> createState() => _BuyairtimeState();
}

class _BuyairtimeState extends State<Buyairtime> {
  TextEditingController mobilenum = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController pinHolder = TextEditingController();

  String selectedAmt = '';
  String? selectedProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: MyColors.secondaryColor,
        elevation: 0,
        leading: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: MyColors.textColor3,
              size: 18,
            )),
        centerTitle: false,
        title: Text(
          'Airtime',
          style: TextStyle(
              color: MyColors.textColor1,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Balance: NGN0.00',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  selectProvider();
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: MyColors.greyColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          selectedProvider ?? 'Select Network',
                          style: TextStyle(
                              fontSize: 16,
                              color: MyColors.textColorD,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        width: 25,
                        height: 25,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 1, color: MyColors.lighterpriColor)),
                        child: Icon(Icons.keyboard_arrow_down_sharp,
                            color: MyColors.lighterpriColor),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Phone Number',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: MyColors.textColor2),
                ),
              ),
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5),
                  child: TextFormField(
                    controller: mobilenum,
                    cursorColor: MyColors.primaryColor,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp('[^0-9]')),
                    ],
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: MyColors.textColor2),
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                      fillColor: MyColors.greyColor,
                      filled: true,
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      hintText: '09073276601',
                      hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: MyColors.textColorD),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none),
                    ),
                  )),
              GestureDetector(
                onTap: () {},
                child: Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 5, top: 4),
                  child: Text(
                    'Select from Contacts',
                    style: TextStyle(
                        fontSize: 13,
                        color: MyColors.textColorD,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Amount',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: MyColors.textColor2),
                ),
              ),
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5),
                  child: TextFormField(
                    controller: amount,
                    keyboardType: TextInputType.number,
                    cursorColor: MyColors.primaryColor,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp('[^0-9]')),
                    ],
                    style: TextStyle(
                        fontSize: 17,
                        color: MyColors.textColor2,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      fillColor: MyColors.greyColor,
                      filled: true,
                      border: InputBorder.none,
                      hintText: '0.00',
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: MyColors.textColorD),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 8, top: 14),
                        child: Text(
                          'NGN',
                          style: TextStyle(
                              color: MyColors.textColorD,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none),
                    ),
                  )),
              SizedBox(
                height: 50,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Quick Amount',
                  style: TextStyle(
                      fontSize: 15,
                      color: MyColors.lighterpriColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAmt = '100';
                        amount.text = selectedAmt;
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: selectedAmt == '100'
                            ? MyColors.primaryColor
                            : MyColors.greyColor,
                      ),
                      child: Center(
                        child: Text(
                          '₦100',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: selectedAmt == '100'
                                ? MyColors.textColor2
                                : MyColors.textColor2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAmt = '200';
                        amount.text = selectedAmt;
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: selectedAmt == '200'
                            ? MyColors.primaryColor
                            : MyColors.greyColor,
                      ),
                      child: Center(
                        child: Text(
                          '₦200',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: selectedAmt == '200'
                                ? MyColors.textColor2
                                : MyColors.textColor2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAmt = '500';
                        amount.text = selectedAmt;
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: selectedAmt == '500'
                            ? MyColors.primaryColor
                            : MyColors.greyColor,
                      ),
                      child: Center(
                        child: Text(
                          '₦500',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: selectedAmt == '500'
                                ? MyColors.textColor2
                                : MyColors.textColor2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAmt = '1000';
                        amount.text = selectedAmt;
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: selectedAmt == '1000'
                            ? MyColors.primaryColor
                            : MyColors.greyColor,
                      ),
                      child: Center(
                        child: Text(
                          '₦1000',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: selectedAmt == '1000'
                                ? MyColors.textColor2
                                : MyColors.textColor2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAmt = '2000';
                        amount.text = selectedAmt;
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: selectedAmt == '2000'
                            ? MyColors.primaryColor
                            : MyColors.greyColor,
                      ),
                      child: Center(
                        child: Text(
                          '₦2000',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: selectedAmt == '2000'
                                ? MyColors.textColor2
                                : MyColors.textColor2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAmt = '3000';
                        amount.text = selectedAmt;
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: selectedAmt == '3000'
                            ? MyColors.primaryColor
                            : MyColors.greyColor,
                      ),
                      child: Center(
                        child: Text(
                          '₦3000',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: selectedAmt == '3000'
                                ? MyColors.textColor2
                                : MyColors.textColor2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAmt = '5000';
                        amount.text = selectedAmt;
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: selectedAmt == '5000'
                            ? MyColors.primaryColor
                            : MyColors.greyColor,
                      ),
                      child: Center(
                        child: Text(
                          '₦5000',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: selectedAmt == '5000'
                                ? MyColors.textColor2
                                : MyColors.textColor2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.only(top: 30),
                child: MaterialButton(
                  elevation: 0,
                  splashColor: Colors.transparent,
                  color: MyColors.lighterpriColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    bottomsheet();
                  },
                  child: Text(
                    'Buy airtime',
                    style: TextStyle(color: Color(0xff010604), fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectProvider() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: MyColors.altsecondaryColor,
        context: context,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        builder: (BuildContext) {
          return SizedBox(
            height: 250,
            child: Padding(
              padding: EdgeInsets.only(right: 15, left: 15, top: 15),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedProvider = 'MTN';
                        });
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffffc403),
                            ),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/images/mtn.png',
                                  scale: 8,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'MTN',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: MyColors.textColor2,
                                fontSize: 18),
                          )
                        ],
                      )),
                  Divider(
                    color: MyColors.divider,
                    thickness: 0.9,
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedProvider = 'Airtel';
                        });
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 241, 35, 35)),
                            child: Center(
                              child: Image.asset(
                                'assets/images/airte.png',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Airtel',
                            style: TextStyle(
                                color: MyColors.textColor2,
                                fontWeight: FontWeight.w400,
                                fontSize: 18),
                          )
                        ],
                      )),
                  Divider(
                    color: MyColors.divider,
                    thickness: 0.9,
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedProvider = '9mobile';
                        });
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyColors.secondaryColor),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/images/9mobile.png',
                                  scale: 8,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '9mobile',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: MyColors.textColor2,
                                fontSize: 18),
                          )
                        ],
                      )),
                  Divider(
                    color: MyColors.divider,
                    thickness: 0.9,
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedProvider = 'Glo';
                        });
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/images/glo.png',
                                  scale: 8,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Glo',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: MyColors.textColor2,
                                fontSize: 18),
                          )
                        ],
                      )),
                ],
              ),
            ),
          );
        });
  }

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
    String? storedPasscode =
        prefs.getString('confirmed_passcode_${currentUser!.uid}');
    if (pinHolder.text == storedPasscode) {
      // Correct PIN, navigate to the next page
      Navigator.pop(context);
    } else {
      // Invalid PIN, show error message
      pinHolder.clear();
      MotionToast(
        displaySideBar: false,
        primaryColor: Color(0xffff5353),
        backgroundType: BackgroundType.solid,
        secondaryColor: Color(0xffea4c4b),
        padding: EdgeInsets.only(left: 20, right: 20),
        width: 270,
        height: 70,
        description: Center(
          child: Text(
            "Invalid Pin, try again",
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

  void bottomsheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Color.fromARGB(255, 19, 21, 21),
        useSafeArea: true,
        enableDrag: true,
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        context: context,
        builder: (context) {
          return Stack(
            children: [
              SizedBox(
                height: 430,
                child: Padding(
                  padding: EdgeInsets.only(left: 15, top: 15, right: 15),
                  child: Column(
                    children: [
                      Text(
                        'PIN',
                        style: TextStyle(
                            color: MyColors.textColorD,
                            fontWeight: FontWeight.bold,
                            fontSize: 19),
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
                            padding: const EdgeInsets.only(top: 10),
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
        });
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
        style: TextStyle(fontSize: 29, fontWeight: FontWeight.w500),
      ),
    );
  }
}
