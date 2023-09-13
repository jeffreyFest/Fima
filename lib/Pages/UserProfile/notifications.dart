// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
 String? currentUserEmail;
late Stream<QuerySnapshot<Map<String, dynamic>>> friendRequestsStream;

@override
void initState() {
  super.initState();
  getCurrentUserEmail();
  getFriendRequest();
}

 void getCurrentUserEmail() {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
  setState(() {
  currentUserEmail = currentUser.email ?? '';
      });
    }
  }

void getFriendRequest() {
 friendRequestsStream = FirebaseFirestore.instance
  .collection('friendRequests')
  .doc(currentUserEmail)
  .collection('requests')
  .snapshots();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
   backgroundColor: Colors.white,
   appBar: AppBar(
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
        Icons.arrow_back_ios_outlined,
          color: Color(0xFF2a5ece),
       )
       ),
          ),
      title: Text('Notifications',
       style: TextStyle(
    color: Colors.black87
      )),
   ),
 body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: friendRequestsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final requests = snapshot.data!.docs;
            if (requests.isNotEmpty) {
              return ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index].data();
                  return ListTile(
                    title: Text(request['senderId']),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Accept friend request
                        acceptFriendRequest(request);
                      },
                      child: Text('Accept'),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No friend requests'),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void acceptFriendRequest(Map<String, dynamic> request) {
    final senderId = request['senderId'];
    // Add sender to receiver's friends list
    FirebaseFirestore.instance
        .collection('friends')
        .doc(currentUserEmail)
        .collection('userFriends')
        .doc(senderId)
        .set({'userId': senderId});

    // Add receiver to sender's friends list
    FirebaseFirestore.instance
        .collection('friends')
        .doc(senderId)
        .collection('userFriends')
        .doc(currentUserEmail)
        .set({'userId': currentUserEmail});

    // Delete friend request
    FirebaseFirestore.instance
        .collection('friendRequests')
        .doc(currentUserEmail)
        .collection('requests')
        .doc(senderId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Friend request accepted'),
        ),
      );
    });
  }
}