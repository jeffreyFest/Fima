// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, use_key_in_widget_constructors, non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../tools/colors.dart';

class Edittagname extends StatefulWidget {
  const Edittagname({ Key? key }) : super(key: key);
  

  @override
  State<Edittagname> createState() => _EdittagnameState();
}

class _EdittagnameState extends State<Edittagname> {
    //User authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _tagname = TextEditingController();

   GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 
   bool _nameAvailable = true; 
   bool _buttonDisabled = true;
   bool _showSuffixIcon = false;
   bool _shownameAva = false;
   bool isLoading = false;

   @override
  void initState() {
    super.initState();
  }


  void _checkIfButtonShouldBeEnabled() {
    setState(() {
     _tagname.text.length <3 
      || _tagname.text.isEmpty ;
    });
  }

  void _checkNameAvailability(String name) async {
      if(name.length < 3 || name.isEmpty){
        setState(() {
          _showSuffixIcon = false;
          _shownameAva = false;
          _nameAvailable = true;
        });
        return;
      }
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('fimaTag', isEqualTo: name) 
          .get();

      setState(() {
        _showSuffixIcon = true;
        _shownameAva = true;
        _nameAvailable = querySnapshot.docs.isEmpty;
      });
    } 

 Future <void> saveFimaTag(String name) async{
    if(name.length > 2){
     if(_nameAvailable){
      setState(() {
          isLoading = true;
        });
      User? getUser = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('Users')
      .doc(getUser?.email)
      .update({
        'fimaTag': name,
      }).then((value) {
       Navigator.pop(context);
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
      body: isLoading ? Center(
      child: SpinKitThreeBounce(
      color: MyColors.lighterpriColor,
      size: 70,
      )) : Padding(
        padding: const EdgeInsets.only(left: 20, right:20,
         bottom: 15, top: 15),
        child: SafeArea(
          child: Stack(
            children:  [
            
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
            child: Text('Update Fimatag',
            style: TextStyle(
              fontSize: 24,
              color: MyColors.textColor1,
              fontWeight: FontWeight.w500
            ),),
          ),
        
              SizedBox(
          height: 10,
              ),
                Align(
                  alignment: Alignment.bottomLeft,
                        child: Text('Your FimaTag will be used for your transactions',
                        style: TextStyle(
                          fontSize: 15.5,
                          color: MyColors.textColor2,
                          fontWeight: FontWeight.w400
                        ),),
                   ),
              
                      Container(
                        width: double.infinity,
                        height: 53,
                        margin: EdgeInsets.only(top:15),
                        decoration: BoxDecoration(
                          color: MyColors.txtfieldcolor,
                         borderRadius: BorderRadius.circular(14)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, top: 4),
                          child: TextFormField(
                            controller: _tagname,
                            textCapitalization: TextCapitalization.none,
                            cursorColor: MyColors.primaryColor,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'[^\w.]')),
                              LowercaseTextFormatter()
                            ],
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              fontSize: 17,
                              color: MyColors.textColor1,
                              fontWeight: FontWeight.w500
                            ),
                          decoration: InputDecoration( 
                            prefixIcon: Icon(Icons.alternate_email,
                            color: MyColors.textColor3,
                            size: 20,
                            ),
                            suffixIcon: _showSuffixIcon ?
                            _nameAvailable
                               ? Icon(Icons.check_circle, color: MyColors.lighterpriColor)
                              : Icon(Icons.warning_rounded, color: Colors.red) : null,
                             labelText: 'Fimatag',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                               labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                                color: MyColors.textColor2
                                 ),
                             contentPadding: EdgeInsets.symmetric(vertical: 6),
                            hintText: 'jefree',  
                            hintStyle: TextStyle(
                              fontSize: 16.5,
                              color: MyColors.textColorD,
                              fontWeight: FontWeight.w500
                            ),
                            border: InputBorder.none
                            ),
                          onChanged: (value) {
                           _checkIfButtonShouldBeEnabled();
                            String name = _tagname.text;
                           _checkNameAvailability(name);
                         }
                          ),
                        )
                        ), 
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: _shownameAva
                      ? _nameAvailable ?
                       Text(
                     'FimaTag is available!',
                      style: TextStyle(
                      fontWeight: FontWeight.bold,
                       fontSize: 16.0,
                       color: MyColors.lighterpriColor
                    ),
                    ):
                      Text('FimaTag is taken!',
                      style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.red
                    ),
                    ) : null,
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
           onPressed: _nameAvailable ? (){
             final name = _tagname.text;
             saveFimaTag(name);
              } : null ,
           child: Text('Update',
           style: TextStyle(
         color: MyColors.secondaryColor,
         fontSize: 17
           ),
           ),
          ),
          ),
        ], ), ),
            ],
          ),
        ),
      ),
    );
  }
}


class LowercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}