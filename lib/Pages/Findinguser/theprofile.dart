// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, non_constant_identifier_names, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class Searcheduser extends StatefulWidget {
  final Map<String, dynamic> user;
  final String userName;
  final String? profilePic;
  final String FcmToken;
  const Searcheduser({super.key,  required this.user,
   required this.userName,
   required this.profilePic, 
   required this.FcmToken});

  @override
  State<Searcheduser> createState() => _SearcheduserState();
}

class _SearcheduserState extends State<Searcheduser> {
  String _fimaTag = '';
  String fullname = '';
  String FcmToken = '' ;
  bool _friendRequestSent = false;
  
 @override
 void initState() {
   super.initState();
   _fimaTag = widget.user['FimaTag'];
   fullname = widget.userName;
   FcmToken = widget.FcmToken;
  checkFriendRequestStatus();
 }

  @override
  Widget build(BuildContext context) {
  return DefaultTabController(length: 2,
   child: Scaffold(
     backgroundColor: Colors.white,
  body: Padding(
   padding: EdgeInsets.only(left: 15, right: 15, top: 2),
  child: SafeArea(
    child: Column(
      children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Row(
         children: [
         IconButton(
          onPressed: (){
           Navigator.pop(context);
           },
            icon: Icon( Icons.arrow_back_ios,
             size: 18,),
               ),

          SizedBox(
            width: 18,
          ),
          Text(fullname,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 18
                )
          )
         ],
        ),
      ),
        Row(
        children: [
         SizedBox(
          width: 8,
         ),
         if(widget.profilePic != null)
          Container(
             width: 70,
             height: 70,
              decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
             width: 1.5,
              color: Color(0xff0145fe),
          )
            ),
              child: ClipOval(
                child: CachedNetworkImage(
                imageUrl: widget.profilePic!,
                fit: BoxFit.cover,
                fadeInDuration: Duration(microseconds: 2),
                   ),
                ),
            )
          else if(widget.profilePic == null)
         Container(
           decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
          width: 1.5,
          color: Color(0xff0145fe),
          )
            ),
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Color.fromARGB(255, 218, 215, 215),
            child: Icon(Icons.person,
            size: 50,
            color: Colors.grey,
            )
            ),
        ),
         Container(
          margin: EdgeInsets.only(left: 4),
          child: Row(
           children: [
           Text('@$_fimaTag',
            style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.w400,
             ),),
          Image.asset('assets/images/verify.png',
           height: 15,
            width: 15,
            color:  Color(0xff0145fe),
              ),
             ],
            ),
        ),
        SizedBox(
          height: 20,
          child: VerticalDivider(
           color: Colors.grey,
           
          ),
        ),
      TextButton(
        onPressed: () {
        },
        child: Text('0 Friends',
        textAlign: TextAlign.left,
        style: TextStyle(
         fontWeight: FontWeight.w400,
         fontSize: 16,
         color: Color(0xff0145fe)
        ),
      ),
      )
        ],),
  
     _friendRequestSent ?
     Align(
      alignment: Alignment.centerLeft,
       child: Container(
        margin: EdgeInsets.only(left: 6, top: 5),
        width: 100,
        height: 25,
        decoration: BoxDecoration(
         color: Color(0x3900FF00),
         borderRadius: BorderRadius.circular(8)
        ),
        child: Center(
          child: Text('Request sent',
          style: TextStyle(
          fontSize: 14,
          color: Color(0xff00D36C),
          fontWeight: FontWeight.w500,
           ),
          ),
        ),
       ),
     ) :
  
    SizedBox(
      height: 30,
    ),
    Row(
      children: [
        GestureDetector(
           onTap: () {
           },
         child: Container(
         margin: EdgeInsets.only(bottom: 6, top: 6,
         right: 8, left: 8
          ),
          width: 260,
           height: 40,
           decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Color(0xff0145fe),
        ),
      child: Center(
         child: Text(
         'Send or Request',
         style: TextStyle(
         fontSize: 17,
        color: Colors.white,
        fontWeight: FontWeight.w500
        ),
         ),
        ),
  ),
  ),
  
   Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
     color: Color(0xffedeef3),
     borderRadius: BorderRadius.circular(13)
    ),
   child: IconButton(
     onPressed: _friendRequestSent ? unsendFriendRequest : sendFriendRequest,
     icon: Icon(
     _friendRequestSent ? Icons.check : Icons.person_add_rounded,
      color: _friendRequestSent ? Color(0xff0145fe) : Color(0xff0145fe),
     ),
   tooltip: _friendRequestSent ? 'Friend Request Sent' : 'Send Friend Request',
    ),
   )
      ],
    ),
   SizedBox(
    height: 10,
   ),
  TabBar(
    indicatorColor: Color(0xff0145fe),
    indicatorWeight: 2,
    indicatorSize: TabBarIndicatorSize.label,
   unselectedLabelColor: Colors.black,
    labelColor: Colors.black,
    labelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500
       ),
    tabs: [
    Tab(
     text: 'Between you',
    ),
     Tab(
   text: 'Activity',
    ),
     ],
        ),
      ],
    ),
  ),
),
   ));
  }

 void sendFriendRequest() async{
 final senderId = FirebaseAuth.instance.currentUser;
  if(senderId == null) {
   return;
  }
final String receiversId = widget.user['FimaTag'];

   Map<String, dynamic> friendRequestData = {
  'senderId': senderId.email,
  'receiverId': receiversId,
  'status': 'pending',
  'timeSent': DateTime.now()
 };

  // Check if the friend request has already been sent
final querySnapshot = await FirebaseFirestore.instance
 .collection('friendRequests')
 .where('senderId', isEqualTo: senderId.email)
 .where('receiverId', isEqualTo: receiversId)
 .get(); 

 if(querySnapshot.docs.isNotEmpty){
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
            child: Text("Friend request already sent! ",
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
 }else{
  //Send the friend request
  Map<String, dynamic> friendRequestData = {
    'senderId': senderId.email,
    'receiverId': receiversId,
    'status':'pending',
    'timeSent': DateTime.now()
  };
 FirebaseFirestore.instance.collection('friendRequests')
 .doc(senderId.email)
 .collection('requests')
 .doc(receiversId)
 .set(friendRequestData);
  
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
       child: Text("Friend Request sent",
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
 setState(() {
   _friendRequestSent = true;
 });
 }
}

void unsendFriendRequest() {
  final senderId = FirebaseAuth.instance.currentUser;
  if (senderId == null) {
    return;
  }
  final String receiversId = widget.user['FimaTag'];

  FirebaseFirestore.instance
      .collection('friendRequests')
      .doc(senderId.email)
      .collection('requests')
      .doc(receiversId)
      .delete()
      .then((_) {
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
          description: Center(
            child: Text(
            "Friend request unsent",
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
      _friendRequestSent = false;
    });
  });
}

 void checkFriendRequestStatus() async {
    final senderId = FirebaseAuth.instance.currentUser;
    if (senderId == null) {
      return;
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('friendRequests')
        .doc(senderId.email)
        .collection('requests')
        .doc(widget.user['FimaTag'])
        .get();

    if (querySnapshot.exists) {
      setState(() {
        _friendRequestSent = true;
      });
    }
  }

}