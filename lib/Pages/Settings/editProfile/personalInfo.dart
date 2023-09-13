// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, sort_child_properties_last, deprecated_member_use, non_constant_identifier_names, cast_from_null_always_fails
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fima/Pages/Settings/editProfile/editTagname.dart';
import 'package:fima/Pages/Settings/editProfile/editname.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../tools/colors.dart';

class PersonalInfo extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  String firstName = '';
  String lastName = '';
  String fimaname = '' ;
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  TextEditingController changeFimatag = TextEditingController();
  User? currentUser;
  bool _nameAvailable = true;
  bool isLoading = false;

 

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _checkNameAvailability(changeFimatag.text);
    getFimaTag();
    updateFimaTag();
  }

  Future<void> getFimaTag() async {
 SharedPreferences prefs = await SharedPreferences.getInstance();
 String? retrieveFirstName = prefs.getString('savedfirstname_${currentUser!.uid}');
 String? retrieveLastName = prefs.getString('savedlastname_${currentUser!.uid}');
 String? retrieveFimaTag = prefs.getString('savedfimaTag_${currentUser!.uid}');

 if(retrieveFirstName != null && retrieveLastName != null && retrieveFimaTag != null){
  //Already saved, use it
  setState(() {
    firstName = retrieveFirstName;
    lastName =  retrieveLastName;
    fimaname =  retrieveFimaTag;
  });
 }else{
 //Not saved you it
 DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users') // Replace with your collection name
        .doc('${currentUser!.email}') // Replace with your document ID
        .get();

    if (snapshot.exists) {
      // Document exists
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      String getFirstName = data['first_name'];
      String getLastName = data['last_name'];
      String getFimaTag = data['fimaTag'];

      setState(() {
      firstName = getFirstName;
      lastName = getLastName;
      fimaname = getFimaTag;
      });

    prefs.setString('savedfirstname_${currentUser!.uid}', getFirstName);
    prefs.setString('savedlastname_${currentUser!.uid}', getLastName);
    prefs.setString('savedfimaTag_${currentUser!.uid}', getFimaTag);
    } else {
    }
 }
 }

 void updateFimaTag() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc('${currentUser!.email}')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        // Document has changed
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String updatedFirstName = data['first_name'];
        String updatedLastName = data['last_name'];
        String updatedFimaTag = data['fimaTag'];
        setState(() {
          firstName = updatedFirstName;
          lastName = updatedLastName;
          fimaname = updatedFimaTag;
        });

        // Cache the updated name
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('savedfirstname_${currentUser!.uid}', updatedFirstName);
          prefs.setString('savedlastname_${currentUser!.uid}', updatedLastName);
          prefs.setString('savedfimaTag_${currentUser!.uid}', updatedFimaTag);
        });
      } else {
        // Clear the cached name
        SharedPreferences.getInstance().then((prefs) {
          prefs.remove('savedfirstname_${currentUser!.uid}');
          prefs.remove('savedlastname_${currentUser!.uid}');
          prefs.remove('savedfimaTag_${currentUser!.uid}');
        });
      }
    });
  }

 void updateUsername() async{
  if(_firstName.text.isNotEmpty || _lastName.text.isNotEmpty){
  final Username = FirebaseFirestore.instance.collection('Users')
  .doc('${currentUser!.email}');
   
  if(_firstName.text.isNotEmpty){
   Username.update({'first_name': _firstName.text});
  }
  
  if(_lastName.text.isNotEmpty){
   Username.update({'last_name': _lastName.text});
  }
  }else if(_firstName.text.isEmpty || _lastName.text.isEmpty){

  }
 }
 
 @override
  void dispose() {
    changeFimatag.dispose();
    super.dispose();
  }


void _checkNameAvailability(String name) async {
      if(name.length < 3 || name.isEmpty){
        setState(() {
          _nameAvailable = true;
        });
        return;
      }
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('fimaTag', isEqualTo: name)
          .get();

      setState(() {
        _nameAvailable = querySnapshot.docs.isEmpty;
      });
    } 

 Future <void> saveFimaTag(String name) async{
    if(name.length > 2){
     if(_nameAvailable){
      setState(() {
          isLoading = true;
        });
        
      User? currentUser = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('Users')
      .doc(currentUser?.email)
      .update({
        'fimaTag': name,
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
      body: Padding(
        padding: EdgeInsets.only(
         left: 20, right: 20, top: 15
        ),
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
              SizedBox(
                width: 20,
               ),
           Text('Edit profile',
              style: TextStyle(
                color: MyColors.textColor1,
                fontSize: 18,
                fontWeight: FontWeight.w500
              ),)
               ],
             ),
             
           Column(
            children: [
            SizedBox(
             height: 50,
            ),
             GestureDetector(
              onTap: () {
                Navigator.push(context, 
              MaterialPageRoute(builder: (context) => Editusername()));
              },
               child: Container(
               width: double.infinity,
                       height: 85,
                       margin: EdgeInsets.only(top:20),
                       padding: EdgeInsets.only(left: 28, top: 20),
                       decoration: BoxDecoration(
                      color: MyColors.txtfieldcolor,
                borderRadius: BorderRadius.circular(15)
                       ),
                     child: IgnorePointer(
                       ignoring: true,
                       child: TextField(
               controller: _firstName,
               keyboardType: TextInputType.none,
               enabled: false,
               showCursor: false,
                inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')), // Deny whitespace
                       ],
             textCapitalization: TextCapitalization.sentences,
               style: TextStyle(
                  color: MyColors.textColor1,
                  fontWeight: FontWeight.w500
                ),
               decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Full name',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: MyColors.textColor2
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 6),
                hintText: '$firstName $lastName',
                hintStyle: TextStyle(
                  color: MyColors.textColor1,
                  fontSize: 17,
                  fontWeight: FontWeight.w500
                ),
                       suffixIcon: Icon(Icons.arrow_forward_ios,
                       size: 17,
                       color: MyColors.textColorD)
               ),      
                 ),
                     ),
                       ),
             ),
            
            Container(
             width: double.infinity,
            height: 85,
            margin: EdgeInsets.only(top:20),
            padding: EdgeInsets.only(left: 28, top: 20),
            decoration: BoxDecoration(
                    color: MyColors.txtfieldcolor,
              borderRadius: BorderRadius.circular(15)
            ),
          child: IgnorePointer(
            ignoring: true,
            child: TextField(
            enabled: false,
             decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'Email address',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w500,
          color: MyColors.textColor2
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 6),
              hintText: '${currentUser!.email}',
              hintStyle: TextStyle(
               fontSize: 17,
               color: MyColors.textColor1,
               fontWeight: FontWeight.w500
              ),
             ),      
               ),
          ),
            ),
              
             GestureDetector(
              onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: 
             (context) => Edittagname()));
              },
               child: Container(
               width: double.infinity,
                       height: 85,
                       margin: EdgeInsets.only(top:15),
                       padding: EdgeInsets.only(left: 28, top: 20),
                       decoration: BoxDecoration(
                      color: MyColors.txtfieldcolor,
                borderRadius: BorderRadius.circular(15)
                       ),
                     child: IgnorePointer(
                       ignoring: true,
                       child: TextField(
                       enabled: false,
               controller: changeFimatag,
               onTap: () {},
               decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Fimatag',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: MyColors.textColor2
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 6),
                suffixIcon: Icon(Icons.verified,
                size: 18,
                color: MyColors.lighterpriColor,),
                hintText:'@$fimaname',
                hintStyle: TextStyle(
                  color: MyColors.textColor1,
                  fontWeight: FontWeight.w500
                ),
               ),  
                       onChanged: (value) {
                 String name = changeFimatag.text;
                 _checkNameAvailability(name);
                       }    
                 ),
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
}
 
