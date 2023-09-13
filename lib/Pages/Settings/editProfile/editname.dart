// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, use_key_in_widget_constructors, non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use, unused_field, empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

import '../../../tools/colors.dart';

class Editusername extends StatefulWidget {
  const Editusername({ Key? key }) : super(key: key);

  @override
  State<Editusername> createState() => _EditusernameState();
}

class _EditusernameState extends State<Editusername> {
  //For Firebase authentication
  final getuser = FirebaseAuth.instance.currentUser;
   
   //FOR TEXTFIELD 
   TextEditingController _firstname = TextEditingController();
   TextEditingController _lastname = TextEditingController();
   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   bool _buttonDisabled = true;
   bool isLoading = false;

  //INITIALIZATION
   @override
  void initState() {
    super.initState();
     _firstname.addListener(_checkIfButtonShouldBeEnabled);
    _lastname.addListener(_checkIfButtonShouldBeEnabled);
  }

  @override
  void dispose() {
    _firstname.dispose();
    _lastname.dispose();
    super.dispose();
  }

  void _checkIfButtonShouldBeEnabled() {
    setState(() {
      _buttonDisabled = _firstname.text.isEmpty || _lastname.text.isEmpty;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: MyColors.secondaryColor,
      body: isLoading ? Center(
      child: SpinKitThreeBounce(
      color: MyColors.lighterpriColor,
      size: 70,
      )) :Padding(
       padding: EdgeInsets.only(
        left: 20, right:20,
        top: 15, bottom: 15),
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
            child: Text('Edit your name.',
            style: TextStyle(
         fontSize: 21,
         color: MyColors.textColor1,
         fontWeight: FontWeight.w500
            ),),
          ),
        
         SizedBox(
          height: 10,
         ),
          Container(
            width: double.infinity,
            height: 53,
            decoration: BoxDecoration(
             color: MyColors.txtfieldcolor,
             borderRadius: BorderRadius.circular(14)
            ),
            child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 2,),
         child: TextFormField(
            controller: _firstname,
            keyboardType: TextInputType.emailAddress,
            cursorColor: MyColors.primaryColor,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(
             fontSize: 17,
             color: MyColors.textColor1,
             fontWeight: FontWeight.w500,
            ),
         decoration: InputDecoration( 
            labelText: 'First name',
             floatingLabelBehavior: FloatingLabelBehavior.always,
             labelStyle: TextStyle(
             fontSize: 16,
            fontWeight: FontWeight.w500,
             color: MyColors.textColor2
         ),
            contentPadding: EdgeInsets.symmetric(vertical: 6),
            hintText: 'Jeffrey',  
             hintStyle: TextStyle(
             fontSize: 17,
            fontWeight: FontWeight.w500,
            color: MyColors.textColorD
            ),
            border: InputBorder.none
            ),
             onChanged: (_) => _checkIfButtonShouldBeEnabled(),
         ),
         
            ),
          ),
          
          Container(
            width: double.infinity,
            height: 53,
            margin: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
             color: MyColors.txtfieldcolor,
             borderRadius: BorderRadius.circular(14)
            ),
            child: Padding(
         padding: const EdgeInsets.only(left: 20, top: 2,),
         child: TextFormField(
            controller: _lastname,
            keyboardType: TextInputType.emailAddress,
            cursorColor: MyColors.primaryColor,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(
            fontSize: 17,
            color: MyColors.textColor1,
            fontWeight: FontWeight.w500,
            ),
         decoration: InputDecoration( 
            labelText: 'Last name',
             floatingLabelBehavior: FloatingLabelBehavior.always,
             labelStyle: TextStyle(
             fontSize: 16,
            fontWeight: FontWeight.w500,
             color: MyColors.textColor2
         ),
            contentPadding: EdgeInsets.symmetric(vertical: 6),
            hintText: 'festus',  
            hintStyle: TextStyle(
         fontSize: 17,
         fontWeight: FontWeight.w500,
         color: MyColors.textColorD
            ),
            border: InputBorder.none
            ),
             onChanged: (_) => _checkIfButtonShouldBeEnabled(),
         ),
         
            ),
          ),
            ]
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
            updateName();
           } ,
           child: Text('Update',
           style: TextStyle(
         color: MyColors.secondaryColor,
         fontSize: 17
           ),
           ),
          ),
          ),
            ],
          ),
          ]
         ),
        )
    ),
    );
  }

  void updateName() async{
    setState(() {
     isLoading = true;
    });

 await FirebaseFirestore.instance.collection('Users')
    .doc('${getuser!.email}')
    .update({
      'first_name': _firstname.text,
      'last_name': _lastname.text,
        });
      Navigator.pop(context);
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
           "Name successfully changed",
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
       
           setState(() {
          isLoading = false;
      });
  }
}