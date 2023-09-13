// ignore_for_file: unused_field, prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fima/tools/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../tools/formatamount.dart';
import '../../tools/timeFormat.dart';
import '../Findinguser/Findusers.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage>  with SingleTickerProviderStateMixin {
  int? accountBal;
  bool hideBalance = false;
 User? user = FirebaseAuth.instance.currentUser;

  late Animation<double> _animation;
  late AnimationController _animationController;
  late Timer _shakeTimer;

  @override
  void dispose() {
    _shakeTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getBalance();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 7).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    startShakeAnimation();
  }

void startShakeAnimation() {
  _animationController.repeat(reverse: true);
  _shakeTimer = Timer(Duration(seconds: 1), () {
    _animationController.stop();
    Timer(Duration(seconds: 6), () {
      startShakeAnimation();
    });
  });
}


  Future<void> getBalance() async {
    final url = Uri.parse(
        'https://api.sandbox.getanchor.co/api/v1/accounts/balance/168780904403423-anc_acc');

    final header = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'x-anchor-key':
          'f9Ehq.ef607b1d168cff00c7794f7d96fdaa1f62961e25c1f23fb92711fc054e608494f28b5498c5dbdba1b0c01b563c815994a467',
    };

    final response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final availableBal = responseData['data']['availableBalance'];
      print(response.body);
      setState(() {
        accountBal = availableBal;
      });
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.secondaryColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Findusers()));
                      },
                      child: Image.asset('assets/images/notification.png',
                          scale: 24, color: MyColors.textColor2),
                    ), AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_animation.value, 0),
                          child: Container(
                            width: 100,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(123, 51, 50, 50),
                                borderRadius: BorderRadius.circular(13),
                                ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'BALANCE',
                                  style: TextStyle(
                                      color: MyColors.textColorD,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Center(
                                  child: Text(
                                   hideBalance ? '✱✱✱✱' : formatBalance(accountBal),
                                    style: TextStyle(
                                        color: MyColors.textColor1,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        }
                      ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Findusers()));
                      },
                      child: Image.asset('assets/images/mag.png',
                          scale: 30, color: MyColors.textColorD),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                SizedBox(
                  height: 80,
                ),

     Expanded(
       child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
          .collection('Transactions')
          .doc(user!.email)
          .collection('Send&Request')
          .orderBy('timeStamp', descending: true) // Sort by timestamp in descending order
          .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
              return Center(
              );
            }
         
         var paymentDocs = snapshot.data!.docs;

         return ListView.separated(
          itemCount: paymentDocs.length,
          separatorBuilder: (context, index) => Container(
            margin: EdgeInsets.only(left: 70),
            child: Divider(
            thickness: 1.0,
            color: MyColors.divider,
                   ),
                    ),
          itemBuilder: (context, index) {
            var payment = paymentDocs[index];
     
            var sender = payment['from'];
            var receiver = payment['receivers_Tag'];
            var amount = payment['amount'];
            var reason = payment['reason'];
            var time = payment['timeStamp'];
            var type = payment['type'];
            
            var senderName =
            user!.email == user!.email ? 'You' : sender;
            
            var showamount = user!.email == user!.email ? amount : '';
             return ListTile(
            leading: CircleAvatar(
              backgroundColor: MyColors.bottomNav,
              child: Icon(
                Icons.person,
                color: Colors.grey,
              ),
            ),
            title:  RichText(
               text: TextSpan(
               text: senderName,
                style: TextStyle(
                 color: MyColors.textColor2,
                 fontWeight: FontWeight.w500
                ),

               children: [
                 TextSpan(
               text: type == 'request' ? ' requested from ' : ' paid ', // Show "requested" if type is "request", otherwise show "paid"
                style: TextStyle(
                 color: MyColors.textColor2,
                 fontWeight: FontWeight.w400
                ),
                 ),

               TextSpan(
               text:'$receiver',
                style: TextStyle(
                 color: MyColors.textColor2,
                 fontWeight: FontWeight.w500
                ),
                 ),
               ]
               ),
             ),
          
          trailing: Text(
             type == 'request' ? '' : '-₦$showamount', // Show "requested" if type is "request", otherwise show "paid",
            style: TextStyle(
            color:  type == 'request' ? null : Colors.red,// Show "requested" if type is "request", otherwise show "paid",
            fontWeight: FontWeight.w500,
            fontSize: 14
                ),
          ) ,
          subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          SizedBox(
            height: 5,
          ),
          Text(
            DateTime(time), // Assuming you have a function to format the time
             style: TextStyle(
            color: MyColors.textColor2,
             fontWeight: FontWeight.w400,
            fontSize: 11.2
           ),
       ),

      SizedBox(height: 10),
    Text(
      reason,
      style: TextStyle(
        color: MyColors.textColor2,
        fontWeight: FontWeight.w400,
        fontSize: 16
      ),
    ),
  
  SizedBox(
  height: 10,
  ),

  Row(
   children: [
    IconButton(
      onPressed: () {},
       icon: Image.asset('assets/images/like.png',
        color: MyColors.textColor2,
        scale: 25,
       )
       ),
   ],
  )
  ],
),
     );
          },
         );
        
        },
     ),
     )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
