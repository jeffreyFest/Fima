// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fima/Pages/Sendcash/InappBulkRequest/getBulkusers.dart';
import 'package:flutter/material.dart';

import '../../tools/colors.dart';
import 'Banktransfer/bankTransfer.dart';
import 'InappTransfer/searchUser.dart';

class SendOption extends StatefulWidget {
  const SendOption({super.key});

  @override
  State<SendOption> createState() => _SendOptionState();
}

class _SendOptionState extends State<SendOption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: MyColors.secondaryColor,
     body: Padding(
      padding: EdgeInsets.only(top: 25, left: 8, right: 8),
      child: Column(
        children: [

        ListTile(
         onTap: () {
          Navigator.push(context, MaterialPageRoute(
          builder: (context) => Searchuser()));
         },
         leading:  Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
              color: MyColors.txtfieldcolor,
              shape: BoxShape.circle,
              ),
              child: Center(
       child: Image.asset('assets/images/fimalogo.png',
       scale: 22,
       color: MyColors.lighterpriColor,
       ),
              ),
         ),

      title: Text('Send to FimaT@g',
      style: TextStyle(
       fontSize: 16,
       color: MyColors.textColor2,
       fontWeight: FontWeight.w500
       ),),

      subtitle: Text('Send to any fima account',
      style: TextStyle(
       fontSize: 12,
       color: MyColors.textColorD,
       fontWeight: FontWeight.w400
       ),
      ),

      trailing: Icon(Icons.arrow_forward_ios_rounded,
      color: MyColors.textColorD,
      size: 20,),
        ),
     
    
    Padding(
      padding: const EdgeInsets.only(top: 10, left: 19),
      child: Align(
      alignment: Alignment.topLeft,
       child: Text('Others',
       style: TextStyle(
       fontSize: 15,
       color: MyColors.textColor2,
       fontWeight: FontWeight.w500
       ),
       )),
    ),
     
    ListTile(
         onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) => 
           Banktransfer()));
         },
         leading:  Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
              color: MyColors.txtfieldcolor,
              shape: BoxShape.circle,
              ),
              child: Center(
       child: Image.asset('assets/images/bank-building.png',
       scale: 23,
       color: MyColors.textColor2,
       ),
              ),
         ),

      title: Text('Bank Account',
      style: TextStyle(
       fontSize: 16,
       color: MyColors.textColor2,
       fontWeight: FontWeight.w500
       ),),

      subtitle: Text('Send to bank account',
      style: TextStyle(
       fontSize: 12,
       color: MyColors.textColorD,
       fontWeight: FontWeight.w400
       ),
      ),

      trailing: Icon(Icons.arrow_forward_ios_rounded,
      color: MyColors.textColorD,
      size: 20,),
        ),

    ListTile(
         onTap: () {
          SplitOp();
         },
         leading:  Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
              color: MyColors.txtfieldcolor,
              shape: BoxShape.circle,
              ),
              child: Center(
       child: Image.asset('assets/images/split.png',
       scale: 23,
       color: Colors.blue,
       ),
              ),
         ),

      title: Text('Split transfer',
      style: TextStyle(
       fontSize: 16,
       color: MyColors.textColor2,
       fontWeight: FontWeight.w500
       ),),

      subtitle: Text('Send to two more fima accounts',
      style: TextStyle(
       fontSize: 12,
       color: MyColors.textColorD,
       fontWeight: FontWeight.w400
       ),
      ),

      trailing: Icon(Icons.arrow_forward_ios_rounded,
      color: MyColors.textColorD,
      size: 20,),
        ),
        ],
      ),
     ),
    );
  }

  void SplitOp(){
    showModalBottomSheet(
       backgroundColor: Color.fromARGB(255, 25, 25, 25),
       isScrollControlled: true,
       enableDrag: true,
       showDragHandle: true,
        context: context,
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), 
      topRight: Radius.circular(30))
        ),
       builder: (Buildcontext) {
        return SizedBox(
      height: 220,
      child: Column(
        children: [
    
      Text('How would you like to split?',
        style: TextStyle(
        fontSize: 20,
        color: MyColors.textColor2,
        fontWeight: FontWeight.w500
        ),),
    GestureDetector(
    onTap: () {
     Navigator.push(context, MaterialPageRoute(builder: (context) => 
     Banktransfer()));
    },
    child: Container(
     width: double.infinity,
     height: 75,
     margin: EdgeInsets.only(left: 15,
      right: 15, top: 20 ),
      decoration: BoxDecoration(
      color: MyColors.lighterpriColor,
       borderRadius: BorderRadius.circular(25)
     ),
    child: Row(
    children: [
     Container(
      width: 40,
      height: 40,
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
       color: MyColors.primaryColor,
       shape: BoxShape.circle
     ),
     child: Center(
      child: Image.asset('assets/images/bank-building.png',
       scale: 22,
       color: MyColors.lighterpriColor,
      )
     ),
     ),
  
    Text('Split payment',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: MyColors.textColor2,
    ),),
     ],
    ),
    ),
  ),

 GestureDetector(
  onTap: () {
     Navigator.push(context, MaterialPageRoute(builder: (context) => 
     InappBulkRequest()));
    },
  child:Container(
       width: double.infinity,
       height: 75,
       margin: EdgeInsets.only(left: 15,
        right: 15, top: 8, bottom: 10),
       decoration: BoxDecoration(
      color: const Color.fromARGB(255, 42, 42, 42),
         borderRadius: BorderRadius.circular(25)
       ),
      child: Row(
      children: [
       Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
         color: MyColors.txtfieldcolor,
         shape: BoxShape.circle
       ),
       child: Center(
        child: Image.asset('assets/images/bank-building.png',
         scale: 22,
         color: MyColors.textColor2,
  
        )
       ),
       ),
      Text('Split request',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: MyColors.textColor3
      ),),
  
       ],
  
      ),
  
    ),
),
  ]),
        );
    });
 }
}