// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fima/Pages/Findinguser/theprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../UserProfile/profile.dart';

class Findusers extends StatefulWidget {
  const Findusers({super.key});

  @override
  State<Findusers> createState() => _FindusersState();
}

class _FindusersState extends State<Findusers> {
 late Stream<QuerySnapshot> userStream;
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> searchedUsers = [];
  final TextEditingController _searchusers = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

void fetchUsers() {
  userStream = FirebaseFirestore.instance.collection('users').snapshots();
  userStream.listen((QuerySnapshot snapshot) {
    setState(() {
      users = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data;
      }).toList();
    });
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
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
             Icons.close,
               color: Color(0xFF2a5ece),
           )
           ),
         ),
      title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: Color(0xffedeef3),
          borderRadius: BorderRadius.circular(20)
        ),
      child: TextFormField(
       controller: _searchusers,
        keyboardType: TextInputType.name,
        inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[^\w.]')),
        LowercaseTextFormatter()
           ],
        style: TextStyle(
        fontSize: 16.5,
        color:Color.fromARGB(255, 47, 51, 54),
       fontWeight: FontWeight.w500
       ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Search for users',
        prefixIcon: Image.asset('assets/images/mag.png',
      scale: 24,
      color: Color(0xff7d868d),
      ),
      ),
    onChanged: (value){
    setState(() {
      users = [];
    });
    if(value.isNotEmpty){
     searchUsers();
    }
    },
      ),
      ),
    ),
  body: Column(
    children: [

     Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (searchedUsers.isEmpty) {
                    return Center(
                      child: Text('No users found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400
                      ),),
                    );
                  }
                  return ListView.separated(
                    itemCount: searchedUsers.length,
                    separatorBuilder: (context, index) => Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Divider(
                      thickness: 1.0,
                                      ),
                    ),
                    itemBuilder: (context, index) {
                      final user = searchedUsers[index];
                       String firstName = user['First Name'];
                       String lastName = user['Last Name'];
                       String combinedUserNames = '$firstName $lastName';
                       String fimaTag = user['FimaTag'];
                       String usersFcmToken = user['FcmToken'];
                      final profilePicture = user['profilePicture'];

                      return GestureDetector(
                        onTap: () {
                        },
                        child: GestureDetector(
                          onTap: () {
                           final currentUser = FirebaseAuth.instance.currentUser;
                           if (user['userId'] == currentUser?.uid) {
                            Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => Userprofile()));
                             } else {
                             Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Searcheduser(user: user,
                              userName: combinedUserNames,
                              profilePic: user['profilePicture'],
                              FcmToken: usersFcmToken,
                              )));
                            }
                          },
                          child: ListTile(
                            title: Text(combinedUserNames,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              wordSpacing: 0,
                            ),
                            ),
                             leading: profilePicture != null
                              ? Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                  ),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                  imageUrl: profilePicture,
                                  fit: BoxFit.cover,
                                  fadeInDuration: Duration(microseconds: 2),
                                     ),
                                  ),
                              )
                          : Container(
                             decoration: BoxDecoration(
                             shape: BoxShape.circle
                                ),
                            child: CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 218, 215, 215),
                              child: Icon(Icons.person,
                              color: Colors.grey,
                              )
                              ),
                          ),
                            subtitle: Text('@$fimaTag',
                            style: TextStyle(
                              color: Color.fromARGB(255, 98, 98, 98),
                              fontWeight: FontWeight.w400,
                              fontSize: 15
                            ),
                            ),
                            // Add other user information here
                          ),
                        ),
                      );
                    },
                  );
                }
          if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
          );
        }
      )),
    ],
  )
  );
  }

 void searchUsers() {
  if (_searchusers.text.isEmpty) {
    setState(() {
      users = [];
    });
    return;
  }

  FirebaseFirestore.instance
      .collection('users')
      .where('FimaTag', isGreaterThanOrEqualTo: _searchusers.text)
      .where('FimaTag', isLessThanOrEqualTo: '${_searchusers.text}\uf8ff')
      .get()
      .then((QuerySnapshot querySnapshot) {
    setState(() {
      searchedUsers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data;
      }).toList();
    });
  });
}
}

  class LowercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}