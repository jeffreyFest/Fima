// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SendMoney{

 Future<Map<String, dynamic>?> Sendfundsinapp({
    required String receiverTag,
    required String receiversName,
    required String amount,
    required String receiverId,
    required String reason,
  }) async {
 
 final url = Uri.parse('https://api.sandbox.getanchor.co/api/v1/transfers');
 
  final headers = {
    'accept': 'application/json',
    'content-type': 'application/json',
    'x-anchor-key': 'f9Ehq.ef607b1d168cff00c7794f7d96fdaa1f62961e25c1f23fb92711fc054e608494f28b5498c5dbdba1b0c01b563c815994a467',
  };

 final data = jsonEncode({
    'data': {
      'type': 'BookTransfer',
      'attributes': {
        'currency': 'NGN',
        'amount': amount,
        'reason': reason,
      },
      'relationships': {
        'destinationAccount': {
          'data': {
            'type': 'DepositAccount',
            'id': receiverId,
          },
        },
        'account': {
          'data': {
            'type': 'DepositAccount',
            'id': '168780904403423-anc_acc',
          },
        },
      },
    },
  });

 final response = await http.post(url, headers: headers, body: data);
  
  if (response.statusCode == 201) {
  final responseData = jsonDecode(response.body);
  final totalAmount = responseData['data']['attributes']['amount'];
  final timepaid = responseData['data']['attributes']['createdAt'];

 final auth = FirebaseAuth.instance.currentUser;
 await FirebaseFirestore.instance.collection('Transactions')
  .doc(auth?.email)
  .collection('Send&Request')
  .add({
   'from': 'dcreator',
   'receivers_Tag': receiverTag,
   'receivers_fullName':receiversName,
   'amount': amount,
   'type': 'bookTransfer',
   'reason': reason,
   'timeStamp': timepaid,
  });
  
  return {
   'amount': totalAmount,
   'timeStamp': timepaid,
  };
  } else {
    print(response.body);
    print('Request failed with status code: ${response.statusCode}');
  }
  return null;
  }

  Future<Map<String, dynamic>?> NipTransfer({
    required String receiversName,
    required String receiversBank,
    required String amount,
    required String note,
    required String id,
    }) async{
  
  final url = Uri.parse('https://api.sandbox.getanchor.co/api/v1/transfers');

  final header = {
    'accept': 'application/json',
    'content-type': 'application/json',
    'x-anchor-key': 'f9Ehq.ef607b1d168cff00c7794f7d96fdaa1f62961e25c1f23fb92711fc054e608494f28b5498c5dbdba1b0c01b563c815994a467',
  };

  final bodyData = jsonEncode({
    "data": {
      "type": "NIPTransfer",
        "attributes": {
         "amount": amount,
         "currency": "NGN",
         "reason": note,
    },
   "relationships": {
     "account": {
       "data": {
       "id": "168780904403423-anc_acc",
       "type": "DepositAccount"
        }
      },
   "counterParty": {
      "data": {
        "id": id,
        "type": "CounterParty"
          }
       }
   }
    }
  });
 
 final response = await http.post(url, headers: header, body: bodyData);
 
 if(response.statusCode == 201){
  final responseData = jsonDecode(response.body);
  final totalAmount = responseData['data']['attributes']['amount'];
  final timepaid = responseData['data']['attributes']['createdAt'];

  return {
   'amount': totalAmount,
   'timeStamp': timepaid,
  };
  
 }else{
  print(response.statusCode);
  print(response.body);
 }

 return null;
  }
}