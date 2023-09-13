// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, use_key_in_widget_constructors, non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fima/Pages/passcode/setpasscode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../tools/colors.dart';
import '../../tools/lowercaseText.dart';

class Fimaname extends StatefulWidget {
  const Fimaname({Key? key}) : super(key: key);

  @override
  State<Fimaname> createState() => _FimanameState();
}

class _FimanameState extends State<Fimaname> {
  User? getUser = FirebaseAuth.instance.currentUser; // For Firebase auth
  late final Map<String, dynamic> user; // Retrieving from data
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';

  final TextEditingController _tagname = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _nameAvailable = true;
  bool _buttonDisabled = true;
  bool _showSuffixIcon = false;
  bool _shownameAva = false;
  bool isLoading = false;
  bool Loading = false; // For checking name

  @override
  void initState() {
    super.initState();
    _checkNameAvailability();
    enableBtn();
  }

  @override
  void dispose() {
    _tagname.dispose();
    super.dispose();
  }

  // Check if button is disabled/enabled
  bool enableBtn() {
    return _tagname.text.length >= 3 && _nameAvailable;
  }

  void _checkNameAvailability() async {
    if (_tagname.text.length < 3 || _tagname.text.isEmpty) {
      setState(() {
        _showSuffixIcon = false;
        _shownameAva = false;
        _nameAvailable = true;
        Loading = true;
      });
      return;
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('fimaTag', isEqualTo: _tagname.text)
        .get();

    setState(() {
      _showSuffixIcon = true;
      _shownameAva = true;
      _nameAvailable = querySnapshot.docs.isEmpty;
      Loading = false;
    });
  }

  // Save FimaTag name to Database
  Future<void> saveFimaTag(String name) async {
    if (name.length > 2) {
      if (_nameAvailable) {
        setState(() {
          isLoading = true;
        });

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(getUser?.email)
            .update({
          'fimaTag': name,
        }).then((value) {
          Navigator.push(
          context, MaterialPageRoute(builder: (context) => Passcode()));
        });

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.secondaryColor,
      body: isLoading
          ? Center(
              child: SpinKitThreeBounce(
              color: MyColors.lighterpriColor,
              size: 70,
            ))
          : SafeArea(
              child: Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 30),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Create a @Fimatag',
                            style: TextStyle(
                                fontSize: 24,
                                color: MyColors.textColor1,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Your Fimatag will be used for your transactions',
                            style: TextStyle(
                                fontSize: 15.5,
                                color: MyColors.textColor2,
                                fontWeight: FontWeight.w400),
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
                              padding: const EdgeInsets.only(left: 8, top: 4),
                              child: TextFormField(
                                  controller: _tagname,
                                  textCapitalization: TextCapitalization.none,
                                  cursorColor: MyColors.primaryColor,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'[^\w.]')),
                                    LowercaseTextFormatter()
                                  ],
                                  maxLines: 1,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.textColor1,
                                  ),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.alternate_email,
                                        color: MyColors.textColor3,
                                        size: 20,
                                      ),
                                      suffixIcon: _showSuffixIcon
                                          ? Loading // Show loading indicator if isLoading is true
                                              ? SizedBox(
                                                  width: 18.0,
                                                  height: 18.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      MyColors.lighterpriColor,
                                                    ),
                                                  ),
                                                )
                                              : _nameAvailable
                                                  ? Icon(
                                                      Icons.check_circle,
                                                      size: 18,
                                                      color: MyColors
                                                          .lighterpriColor,
                                                    )
                                                  : Icon(
                                                      Icons.warning_rounded,
                                                      size: 18,
                                                      color: Colors.red,
                                                    )
                                          : null,
                                      labelText: 'Fimatag',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: MyColors.textColor2),
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 6),
                                      hintText: 'jefree',
                                      hintStyle: TextStyle(
                                          fontSize: 16.5,
                                          color: MyColors.textColorD,
                                          fontWeight: FontWeight.w500),
                                      border: InputBorder.none),
                                  onChanged: (value) {
                                    setState(() {
                                      enableBtn();
                                      _checkNameAvailability();
                                    });
                                  }),
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: _shownameAva
                              ? _nameAvailable
                                  ? Text(
                                      'FimaTag is available!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: MyColors.lighterpriColor),
                                    )
                                  : Text(
                                      'FimaTag is taken!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: Colors.red),
                                    )
                              : null,
                        ),
                      ],
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
                                      saveFimaTag(_tagname.text);
                                    }
                                  : null,
                              child: Text(
                                'Next',
                                style: TextStyle(
                                    color: enableBtn()
                                        ? MyColors.textColor3
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
}
