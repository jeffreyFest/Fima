// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fima/Pages/identity%20verification/bvn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../tools/colors.dart';

class VerificationOpt extends StatefulWidget {
  const VerificationOpt({super.key});

  @override
  State<VerificationOpt> createState() => _VerificationOptState();
}

class _VerificationOptState extends State<VerificationOpt> {
  bool isBvnVerified = false;
  bool isIddocument = false;
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadBvnVerificationStatus();
  }
   void updateBvnVerificationStatus(bool verified) {
    setState(() {
      isBvnVerified = verified;
    });
  }

  void _loadBvnVerificationStatus() async {
  try {
    setState(() {
      isLoading = true;
    });
    
    User? getuser = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(getuser!.email)
        .get(GetOptions(source: Source.server));
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      final isBvnVerified = data['isBvnVerified'] ?? false;
      setState(() {
        this.isBvnVerified = isBvnVerified;
      });
    }
  setState(() {
    isLoading = false;
  });
  } catch (error) {
    // Handle error
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
      ) )
      : Padding(padding: 
    EdgeInsets.only(left: 20, right: 20),
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
       ],
             ),
        Column(
          children: [

        SizedBox(
            height: 60,
           ),

        Align(
         alignment: Alignment.centerLeft,
          child: Text('Verification',
          style: TextStyle(
            fontSize: 24,
           color: MyColors.textColor1,
            fontWeight: FontWeight.w600
          ),),
             ),
          SizedBox(
            height: 10,
          ),
      
      Align(
      alignment: Alignment.bottomLeft,
       child: Text(
          'We need you to verify your identity to unlock all features of the app',
        style: TextStyle(
        fontSize: 15.5,
        color: MyColors.textColorD,
        fontWeight: FontWeight.w400
      ),)
        ),
      
      GestureDetector(
          onTap: isBvnVerified ? null : () async{
          final result = await Navigator.push(context, MaterialPageRoute(
            builder: (context) => BvnVerification(
              onBvnVerified: updateBvnVerificationStatus,
            )));
          if (result == true) {
            setState(() {
              isBvnVerified = true; // Update the BVN verification status
             });
            }
          },
          child: Container(
          width: double.infinity,
           height: 75,
           margin: EdgeInsets.only(top:20),
           padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: MyColors.txtfieldcolor,
              borderRadius: BorderRadius.circular(15)
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Text('BVN',
          style: TextStyle(
            fontSize: 17,
            color: MyColors.textColor2,
            fontWeight: FontWeight.w500
          ),),
      
          Container(
           width: 80,
           height: 20,
           margin: EdgeInsets.only(right: 10),
           decoration: BoxDecoration(
            color: isBvnVerified ? Color.fromARGB(240, 109, 252, 109) : Color.fromARGB(242, 255, 121, 121),
            borderRadius: BorderRadius.circular(8)
           ),
           child: isBvnVerified ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
              'verified',
              style: TextStyle(
              color: Colors.black
              ),
              ),
            ],
          ) :
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          SizedBox(
          width: 5,
          ),
          Text('unverified',
           style: TextStyle(
            color: Colors.black
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded,
          color: Colors.black,
          size: 12,)
          ],
          )
          )
          ]),
          ),
      ),
      
       //For ID(identity) verification
      Container(
      width: double.infinity,
       height: 75,
       margin: EdgeInsets.only(top:20),
       padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: MyColors.txtfieldcolor,
            borderRadius: BorderRadius.circular(15)
            ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
      Text('ID Document',
      style: TextStyle(
          fontSize: 17,
          color: MyColors.textColor2,
          fontWeight: FontWeight.w500
      ),),
      
       Container(
           width: 80,
           height: 20,
           margin: EdgeInsets.only(right: 10),
           decoration: BoxDecoration(
            color: isIddocument ? Color.fromARGB(240, 109, 252, 109) : Color.fromARGB(242, 255, 121, 121),
            borderRadius: BorderRadius.circular(8)
           ),
           child: isIddocument ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
              'verified',
              style: TextStyle(
              color: Colors.black
              ),
              ),
            ],
          ) :
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          SizedBox(
          width: 5,
          ),
          Text('unverified',
           style: TextStyle(
            color: Colors.black
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded,
          color: Colors.black,
          size: 12,)
          ],
          )
          )
      ]),
      ),
            ],
          ),
        ],
    ),
  )
     ),
    );
  }
}