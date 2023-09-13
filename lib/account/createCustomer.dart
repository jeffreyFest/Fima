import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Customer{
  
  //Create a Fima user
  static Future<String?> createCustomer({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,}) async {
   
   final url = Uri.parse('https://api.sandbox.getanchor.co/api/v1/customers');
   final headers = {
    'accept': 'application/json',
    'content-type': 'application/json',
    'x-anchor-key': 'f9Ehq.ef607b1d168cff00c7794f7d96fdaa1f62961e25c1f23fb92711fc054e608494f28b5498c5dbdba1b0c01b563c815994a467',
  };

  final body = jsonEncode({
    "data": {
      "attributes": {

        "fullName": {
         "firstName": firstName,
         "lastName": lastName,
            },
          
        'email': email,
        'phoneNumber': phoneNumber,

        'address': {
          'country': 'NG',
          'state': 'LAGOS',
          'addressLine_1': '1 James street',
          'city': 'Yaba',
          'postalCode': '100032',
        },  
      },

    'type': 'IndividualCustomer',
    
      },
    });

  final response = await http.post(url, headers: headers, body: body);
  
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final customerID = responseData['data']['id'];
    print('Response code: ${response.statusCode}');
    print('Response body: ${response.body}');
    print('Signup successful!');
   
   //Store User data to the Database if the successful
    final getuser = FirebaseAuth.instance.currentUser;
     await FirebaseFirestore.instance.collection('Users')
    .doc('${getuser!.email}')
    .update({
    'first_name': firstName,
    'last_name': lastName,
    'anchorcustomer_id': customerID,
    'user_id': getuser.uid,
     });
  } else {
    print('Signup failed. Error code: ${response.statusCode}');
    print(response.body);
   
  }
  return null;
   } 
}