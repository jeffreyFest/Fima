// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fima/Pages/paybills/buyairtime.dart';
import 'package:fima/Pages/paybills/buydata.dart';
import 'package:flutter/material.dart';

import '../../tools/colors.dart';

class PaybillsOption extends StatefulWidget {
  const PaybillsOption({super.key});

  @override
  State<PaybillsOption> createState() => _PaybillsOptionState();
}

class _PaybillsOptionState extends State<PaybillsOption> {
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
          builder: (context) => Buyairtime()));
         },
         leading:  Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
              color: MyColors.txtfieldcolor,
              shape: BoxShape.circle,
              ),
              child: Center(
           child: Image.asset('assets/images/sim.png',
       scale: 24,
       color: MyColors.textColor2,
       ),
              ),
         ),

      title: Text('Buy Airtime',
      style: TextStyle(
       fontSize: 16,
       color: MyColors.textColor2,
       fontWeight: FontWeight.w500
       ),),

      subtitle: Text('Pay for airtime',
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
         Navigator.push(context, MaterialPageRoute(builder: (context) => 
           BuyData()));
         },
         leading:  Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
              color: MyColors.txtfieldcolor,
              shape: BoxShape.circle,
              ),
              child: Center(
       child: Image.asset('assets/images/mobile-data.png',
       scale: 25,
       color: MyColors.textColor2,
       ),
              ),
         ),

      title: Text('Buy Data',
      style: TextStyle(
       fontSize: 16,
       color: MyColors.textColor2,
       fontWeight: FontWeight.w500
       ),),

      subtitle: Text('Pay for Data',
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
         Navigator.push(context, MaterialPageRoute(builder: (context) => 
           BuyData()));
         },
         leading:  Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
              color: MyColors.txtfieldcolor,
              shape: BoxShape.circle,
              ),
              child: Center(
        child: Icon(Icons.electrical_services_outlined,
         color: MyColors.textColor2,
          )
              ),
         ),

      title: Text('Electricity',
      style: TextStyle(
       fontSize: 16,
       color: MyColors.textColor2,
       fontWeight: FontWeight.w500
       ),),

      subtitle: Text('Buy electricity easily',
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
        
         },
         leading:  Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
              color: MyColors.txtfieldcolor,
              shape: BoxShape.circle,
              ),
              child: Center(
       child: Image.asset('assets/images/television.png',
       scale: 22,
       color: MyColors.textColor2,
       ),
              ),
         ),

      title: Text('Cable Tv',
      style: TextStyle(
       fontSize: 16,
       color: MyColors.textColor2,
       fontWeight: FontWeight.w500
       ),),

      subtitle: Text('Pay with ease',
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
}