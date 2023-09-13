// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, use_key_in_widget_constructors, non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use, unused_field, empty_catches, must_be_immutable
import 'package:fima/account/createCustomer.dart';
import 'package:fima/tools/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Username extends StatefulWidget {
  String PhoneNumber;
  String email;
  Username({Key? key, required this.PhoneNumber, required this.email})
      : super(key: key);

  @override
  State<Username> createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  //FOR TEXTFIELD
  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _buttonDisabled = true;
  bool isLoading = false;

  String phoneNumber = '';
  String emailaddress = '';
  //INITIALIZATION
  @override
  void initState() {
    super.initState();
    phoneNumber = widget.PhoneNumber;
    emailaddress = widget.email;
    enableBtn();
  }

  @override
  void dispose() {
    _firstname.dispose();
    _lastname.dispose();
    super.dispose();
  }

  //Bool to check if to enable/disable Button
  bool enableBtn() {
    return _firstname.text.isNotEmpty &&
        _firstname.text.length <= 12 &&
        _lastname.text.isNotEmpty &&
        _lastname.text.length <= 12;
  }
  
  //Create the user and also store the usersdata
  void Createfimauser() async {
    setState(() {
      isLoading = true; // Start showing the loading spinner
    });

    await Customer.createCustomer(
      firstName: _firstname.text,
      lastName: _lastname.text,
      email: emailaddress,
      phoneNumber: phoneNumber,
    );

    setState(() {
      isLoading = false; // Stop showing the loading spinner
    });
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
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 15, top: 30),
                  child: Stack(children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'What\'s your name?',
                            style: TextStyle(
                                fontSize: 25,
                                color: MyColors.textColor3,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          height: 53,
                          decoration: BoxDecoration(
                              color: MyColors.txtfieldcolor,
                              borderRadius: BorderRadius.circular(14)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 2,
                            ),
                            child: TextFormField(
                              controller: _firstname,
                              cursorColor: MyColors.lighterpriColor,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.textColor1),
                              decoration: InputDecoration(
                                  labelText: 'First name',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.textColor2),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 6),
                                  hintText: 'Jeffrey',
                                  hintStyle: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.textColorD),
                                  border: InputBorder.none),
                              onChanged: (value) {
                                setState(() {
                                  enableBtn(); // Update the button state on password change
                                });
                              },
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
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 2,
                            ),
                            child: TextFormField(
                              controller: _lastname,
                              cursorColor: MyColors.lighterpriColor,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                fontSize: 17,
                                color: MyColors.textColor1,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                  labelText: 'Last name',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.textColor2),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 6),
                                  hintText: 'festus',
                                  hintStyle: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.textColorD),
                                  border: InputBorder.none),
                              onChanged: (value) {
                                setState(() {
                                  enableBtn(); // Update the button state on password change
                                });
                              },
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
                                ? (){
                                Createfimauser();
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
                  ]),
                ),
              ));
  }
}
