// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, non_constant_identifier_names, empty_catches
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class BvnVerification extends StatefulWidget {
  final void Function(bool) onBvnVerified;

 const BvnVerification({Key? key, required this.onBvnVerified})
      : super(key: key);
  @override
  State<BvnVerification> createState() => _BvnVerificationState();
}

class _BvnVerificationState extends State<BvnVerification> {
  final getuser = FirebaseAuth.instance.currentUser;
  late final Map<String, dynamic> user;
  String customerID = ''; //Getting customerID
   //FOR TEXTFIELD 
  TextEditingController bvn = TextEditingController(); //Bvn TextField
  TextEditingController DoB = TextEditingController(); //Date of Birth TextField
  TextEditingController gender =TextEditingController(); //Gender field
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now(); //Selected Date of Birth
  bool _buttonDisabled = true;
  bool isLoading = false;
  bool isBvnVerified = false;
  //INITIALIZATION
   @override
  void initState() {
    super.initState();
     bvn.addListener(_checkIfButtonShouldBeEnabled);
     fetchUserProfile();
  }

  @override
  void dispose() {
  bvn.removeListener(_checkIfButtonShouldBeEnabled);
  DoB.dispose();
  gender.dispose();
  super.dispose();
}
  
  void _checkIfButtonShouldBeEnabled() {
    if(mounted){
     setState(() {
      _buttonDisabled = bvn.text.isEmpty 
      || bvn.text.length < 11;
    });
    } 
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white ,
     appBar: !isLoading ? AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: ButtonTheme(
       minWidth: 20,
       height: 20,
       child: MaterialButton(
       shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(50)
        ),
      onPressed: () => Navigator.of(context).pop(),
       splashColor: Colors.transparent,
        child: Icon(
        Icons.arrow_back_ios,
          color: Color(0xFF2a5ece),
           )
           ),
         ),
    ) : null,
  body: isLoading ? Center(
      child: SpinKitThreeBounce(
      color: Color(0xff0145fe),
      size: 70,
      ) )
      : Padding(
      padding: const EdgeInsets.only(left: 25, right:25,
      bottom: 15, top: 15),   
    child: Stack(
    children: 
      [Form(
        key: formKey,
        child: Column(
    children: [  
     Align(
          alignment: Alignment.bottomLeft,
          child: Text('Bvn verification',
          style: TextStyle(
            fontSize: 23,
           color: Color(0xff212437),
            fontWeight: FontWeight.w600
          ),),
        ),
      SizedBox(
        height: 10,
      ),
       Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            'We need your BVN to confirm who you\'re.\n& also create a bank account for you',
            style: TextStyle(
            fontSize: 15.5,
            color: const Color.fromARGB(255, 122, 121, 121),
            fontWeight: FontWeight.w400
          ),)
            ),

        Container(
          width: double.infinity,
          height: 53,
          margin: EdgeInsets.only(top: 15),
          padding: EdgeInsets.only(left: 20, top: 2,),
          decoration: BoxDecoration(
            color: Color(0xffedeef3),
           borderRadius: BorderRadius.circular(14)
          ),
          child: TextFormField(
          controller: bvn,
          cursorColor: Color(0xff0145fe),
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w500,
          ),
        decoration: InputDecoration( 
          labelText: 'BVN',
           floatingLabelBehavior: FloatingLabelBehavior.always,
           labelStyle: TextStyle(
           fontSize: 16,
          fontWeight: FontWeight.w500,
           color: Color(0xffc3c3c3)
            ),
          contentPadding: EdgeInsets.symmetric(vertical: 6),
          hintText: 'e.g 12345678901',
          hintStyle: TextStyle(
            fontSize: 17,
            color: Color(0xffbebfc4),
            fontWeight: FontWeight.w500
          ),
          border: InputBorder.none
          ),
           onChanged: (_) => _checkIfButtonShouldBeEnabled(),
          ),
        ),

  Container(
          width: double.infinity,
          height: 53,
          margin: EdgeInsets.only(top: 15),
          padding: EdgeInsets.only(left: 20, top: 2,),
          decoration: BoxDecoration(
            color: Color(0xffedeef3),
           borderRadius: BorderRadius.circular(14)
          ),
          child: TextFormField(
          controller: DoB,
          onTap: () => _selectDate(context),
          cursorColor: Color(0xff0145fe),
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w500,
          ),
        decoration: InputDecoration( 
          labelText: 'Date of Birth',
           floatingLabelBehavior: FloatingLabelBehavior.always,
           labelStyle: TextStyle(
           fontSize: 16,
          fontWeight: FontWeight.w500,
           color: Color(0xffc3c3c3)
            ),
          contentPadding: EdgeInsets.symmetric(vertical: 6),
          hintText: '1990-07-11',
          hintStyle: TextStyle(
            fontSize: 17,
            color: Color(0xffbebfc4),
            fontWeight: FontWeight.w500
          ),
          border: InputBorder.none
          ),
           onChanged: (_) => _checkIfButtonShouldBeEnabled(),
          ),
        ),


        Container(
          width: double.infinity,
          height: 53,
          margin: EdgeInsets.only(top: 15),
          padding: EdgeInsets.only(left: 20, top: 2,),
          decoration: BoxDecoration(
            color: Color(0xffedeef3),
           borderRadius: BorderRadius.circular(14)
          ),
          child: TextFormField(
          controller: gender,
          cursorColor: Color(0xff0145fe),
          keyboardType: TextInputType.name,
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w500,
          ),
        decoration: InputDecoration( 
          labelText: 'Gender',
           floatingLabelBehavior: FloatingLabelBehavior.always,
           labelStyle: TextStyle(
           fontSize: 16,
          fontWeight: FontWeight.w500,
           color: Color(0xffc3c3c3)
            ),
          contentPadding: EdgeInsets.symmetric(vertical: 6),
          hintText: 'Male',
          hintStyle: TextStyle(
            fontSize: 17,
            color: Color(0xffbebfc4),
            fontWeight: FontWeight.w500
          ),
          border: InputBorder.none
          ),
           onChanged: (_) => _checkIfButtonShouldBeEnabled(),
          ),
        ),
          ]
        ),
      ),

      
  
      Center(
       child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
           ButtonTheme(
            minWidth: double.infinity,
            height: 50,
            splashColor: Colors.transparent,
            child:  MaterialButton(
              focusElevation: 0,
              elevation: 0,
          onPressed: () async{
              upgradeUsertoTier2().then((value){
              FirebaseFirestore.instance
     .collection('Users')
     .doc(getuser!.email)
     .update({
      'isBvnVerified': true,
     });
        savebvn();
       createDepositAccount();

    setState(() {
        isLoading = false;
        isBvnVerified = true; // Update the BVN verification status
      });
    widget.onBvnVerified(true);
      Navigator.of(context).pop();
      MotionToast(
          displaySideBar: false,
          primaryColor:  Color(0xff00E676),
          backgroundType: BackgroundType.solid,
          secondaryColor:  Color(0xff00D36C),
          padding: EdgeInsets.only(
            left: 20,
            right: 20
          ),
          width: 320,
          height: 70,
          description:  Center(
            child: Text("Your account has been verified",
               textAlign: TextAlign.center,
               style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white,
              ),
            ),
          ),
          position: MotionToastPosition.top,
          animationType:  AnimationType.fromTop,
          animationDuration: Duration(milliseconds: 1),
          toastDuration: Duration(seconds: 3),
        ).show(context);
              } );
          
             },
     shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
          ),
          color:  _buttonDisabled ?Color(0x780144FE) :Color(0xff0145fe),
          splashColor: Colors.transparent,
            child: isLoading ?  LoadingAnimationWidget.threeRotatingDots(
               color: Colors.white,
                size: 35,
                 ) :Text('Verify',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),),
            )
           ),],
        ), ),
    ],
        ),
  ),
    );
  }



Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        DoB.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

void fetchUserProfile() async {
  try {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
    .collection('Users').doc(getuser!.email).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      final customerIdvalue = data['anchorcustomer_id'];
      setState(() {
      customerID = customerIdvalue;
      });
    }
  } catch (error) {
  }
}


void savebvn() async{
 await FirebaseFirestore.instance.collection('Users')
 .doc(getuser!.email)
 .update({
  'user_bvn': bvn.text,
  'date_of_birth': DoB.text,
  'gender': gender.text,
 });
}

 Future<void> upgradeUsertoTier2() async{
  setState(() {
    isLoading = true;
   });
  final url = Uri.parse('https://api.sandbox.getanchor.co/api/v1/customers/$customerID/verification/individual');
  final headers = {
    'accept': 'application/json',
    'content-type': 'application/json',
    'x-anchor-key': 'f9Ehq.ef607b1d168cff00c7794f7d96fdaa1f62961e25c1f23fb92711fc054e608494f28b5498c5dbdba1b0c01b563c815994a467',
  };

  final data = jsonEncode({
    "data": {
      "attributes": {
        "level": "TIER_2",
        "level2": {
          "bvn": bvn.text,
          "dateOfBirth": DoB.text,
          "gender": gender.text,
        }
      },
      "type": "Verification"
    }
  });

   // Check if the BVN has already been used
  final existingUser = await FirebaseFirestore.instance
      .collection('Users')
      .where('user_bvn', isEqualTo: bvn.text)
      .get();
  if (existingUser.docs.isNotEmpty) {
    // BVN already used by someone else
       MotionToast(
          displaySideBar: false,
          primaryColor:  Color(0xffff5353),
          backgroundType: BackgroundType.solid,
          secondaryColor:  Color(0xffff0000),
          padding: EdgeInsets.only(
            left: 20,
            right: 20
          ),
          width: 320,
          height: 70,
          description: Padding(
          padding: EdgeInsets.only(left: 15),
            child: Text(
            "This BVN has been used by another user",
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
  } else {
  final response = await http.post( url, headers: headers, body: data,);
  if(response.statusCode == 201){
   final responseData = jsonDecode(response.body);
   print(responseData);
    } else {
      print('Request failed with status: ${response.statusCode}');
      print(response.body);
  }

   setState(() {
  isLoading = false;
 });
  }
  }


  Future<void> createDepositAccount() async {
     setState(() {
      isLoading = true;
    });
  final url = Uri.parse('https://api.sandbox.getanchor.co/api/v1/accounts');
  final headers = {
    'accept': 'application/json',
    'content-type': 'application/json',
    'x-anchor-key': 'f9Ehq.ef607b1d168cff00c7794f7d96fdaa1f62961e25c1f23fb92711fc054e608494f28b5498c5dbdba1b0c01b563c815994a467'
  };

  final data = jsonEncode({
    "data": {
        "type": "DepositAccount",
        "attributes": {
            "productName": "SAVINGS"
        },
        "relationships": {
            "customer": {
                "data": {
                    "id": customerID,
                    "type": "IndividualCustomer"
                }
            }
        }
    }
  });
  
  final response = await http.post(
    url,
    headers: headers,
    body: data,
  );
  
  if (response.statusCode == 200) {
    // Request successful, handle the response here
    final responseBody = jsonDecode(response.body);
    print('successfully created: $responseBody');
     setState(() {
      isLoading = false;
    });
  } else {
    // Request failed, handle the error here
    print('Request failed with status code: ${response.statusCode}');
    print(response.body);
    setState(() {
      isLoading = false;
    });
  }
}

}