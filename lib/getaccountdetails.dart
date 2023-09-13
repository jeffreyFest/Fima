// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fima/tools/timeFormat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Det extends StatefulWidget {
  const Det({Key? key}) : super(key: key);

  @override
  State<Det> createState() => _DetState();
}

class _DetState extends State<Det> {
  final String apiUrl = 
  'https://api.sandbox.getanchor.co/api/v1/transactions?accountId=168780904403423-anc_acc&include=Payment';
  final String apiKey =
      'f9Ehq.ef607b1d168cff00c7794f7d96fdaa1f62961e25c1f23fb92711fc054e608494f28b5498c5dbdba1b0c01b563c815994a467';

  Future<void> fetchData() async {
    try {
      // Create the request headers
      Map<String, String> headers = {
        'accept': 'application/json',
        'x-anchor-key': apiKey,
      };

      // Send the GET request
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        // Request successful, process the response here
        print(response.body);
      } else {
        // Request failed with an error, handle the error here
        print('Request failed with status: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      // Handle any exceptions that occurred during the request
      print('Exception occurred: $e');
    }
  }

 User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter HTTP Request'),
      ),
      body: StreamBuilder<QuerySnapshot>(
       stream: FirebaseFirestore.instance
        .collection('Transactions')
        .doc(user!.email)
        .collection('Send')
        .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
       
       var paymentDocs = snapshot.data!.docs;

       return ListView.builder(
        itemCount: paymentDocs.length,
        itemBuilder: (context, index) {
          var payment = paymentDocs[index];

          var sender = payment['from'];
          var receiver = payment['receivers_Tag'];
          var amount = payment['amount'];
          var reason = payment['reason'];
          var time = payment['timeStamp'];


          return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    // You can use the sender's profile picture here
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    '$sender paid $receiver $reason',
                  ),
                  subtitle: Text('₦$amount'),
                  trailing: Text(formatDateTime(time)),
                ),
              );
        },
       );
      
      },
      ),
     );  
      }
}