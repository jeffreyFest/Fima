import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class sendRequest{
 final auth = FirebaseAuth.instance.currentUser;
 
 Future<Map<String, dynamic>?> bulkRequest({
  required String from,
  required String receivers_Tag,
  required String receivers_fullName,
  required String amount,
  required String reason,
 }) async{
  await FirebaseFirestore.instance.collection('Transactions')
   .doc(auth!.email)
   .collection('Send&Request')
   .add({
    'from': 'dcreator',
    'receivers_Tag': receivers_Tag,
    'receivers_fullName': receivers_fullName,
    'amount': amount,
    'reason': reason,
    'type': 'bulkrequest',
   });
 }
}