// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fima/Pages/Sendcash/InappTransfer/send.dart';
import 'package:fima/Pages/UserProfile/profile.dart';
import 'package:fima/tools/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Searchuser extends StatefulWidget {
  const Searchuser({Key? key}) : super(key: key);

  @override
  State<Searchuser> createState() => _SearchuserState();
}

class _SearchuserState extends State<Searchuser> {
  late Stream<QuerySnapshot> userStream;
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> searchedUsers = [];
  List<Map<String, dynamic>> selectedContacts = [];
  TextEditingController _searchusers = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    enableBtn(); //automically active button
  }

//Fetch User from the Database
  void fetchUsers() {
    setState(() {
      isLoading = true;
    });
    userStream = FirebaseFirestore.instance.collection('Users').snapshots();
    userStream.listen((QuerySnapshot snapshot) {
      setState(() {
        users = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return data;
        }).toList();
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  bool enableBtn() {
    return selectedContacts.length ==
        1; //enable button if selected user is = 2 or greater than
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.secondaryColor,
      body: Padding(
        padding: EdgeInsets.only(top: 15),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: MyColors.textColorD, width: 1)),
                      child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: MyColors.white,
                            size: 13,
                          )),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Send to Fima',
                      style: TextStyle(
                          color: MyColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 40,
                    margin: EdgeInsets.only(
                        top: 60, bottom: 20, left: 15, right: 15),
                    decoration: BoxDecoration(
                        color: MyColors.txtfieldcolor,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.only(left: 23),
                    child: TextFormField(
                      controller: _searchusers,
                      cursorColor: MyColors.primaryColor,
                      keyboardType: TextInputType.name,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[^\w.]')),
                        LowercaseTextFormatter()
                      ],
                      style: TextStyle(
                          fontSize: 16.5,
                          color: MyColors.textColor2,
                          fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter @Fimatag',
                        hintStyle:
                            TextStyle(color: Color.fromARGB(255, 78, 80, 80)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchedUsers =
                              []; // Clear the searchedUsers list when the text field changes
                        });
                        if (value.isNotEmpty) {
                          searchUsers();
                        }
                      },
                    ),
                  ),
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: userStream,
                          builder: (context, snapshot) {
                            if (isLoading) {
                              // Show the loading indicator while fetching users
                              return Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: SpinKitThreeBounce(
                                    color: MyColors.lighterpriColor,
                                    size: 45,
                                  ));
                            }
                            if (snapshot.hasData) {
                              if (_searchusers.text.isEmpty) {
                                return Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      margin:
                                          EdgeInsets.only(top: 30, bottom: 10),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color.fromARGB(
                                              64, 255, 255, 255)),
                                      child: Icon(
                                        Icons.search,
                                        size: 45,
                                        color: MyColors.secondaryColor,
                                      ),
                                    ),
                                    Text(
                                      'Enter the receivers fimat@g',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                          color: MyColors.textColorD),
                                    ),
                                  ],
                                );
                              } else if (searchedUsers.isEmpty) {
                                //Display this if there is no sure name on the database
                                String incorrectName = _searchusers.text;
                                return Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      margin:
                                          EdgeInsets.only(top: 30, bottom: 10),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color.fromARGB(
                                              64, 255, 255, 255)),
                                      child: Icon(
                                        Icons.search_off_rounded,
                                        size: 45,
                                        color: MyColors.secondaryColor,
                                      ),
                                    ),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          text: 'No user found with the name',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: MyColors.textColorD),
                                          children: [
                                            TextSpan(
                                              text: '\n@$incorrectName',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: MyColors.textColor2,
                                              ),
                                            )
                                          ]),
                                    ),
                                  ],
                                );
                              }

                              return ListView.separated(
                                itemCount: searchedUsers.length,
                                separatorBuilder: (context, index) =>
                                    Container(),
                                itemBuilder: (context, index) {
                                  final user = searchedUsers[index];
                                  String firstName = user['first_name'];
                                  String lastName = user['last_name'];
                                  String combinedUserName =
                                      '$firstName $lastName';
                                  String fimaTag = user['fimaTag'];
                                  final profilePicture = user['profilePicture'];

                                  return GestureDetector(
                                    onTap: () {
                                      final currentUser =
                                          FirebaseAuth.instance.currentUser;
                                      if (user['user_id'] == currentUser?.uid) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Userprofile()));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Payusers(
                                                      Name: combinedUserName,
                                                      fimaTag: fimaTag,
                                                      Profilepic:
                                                          profilePicture,
                                                      fimatransferId: user[
                                                          'fimaaccount_id'],
                                                    )));
                                      }
                                    },
                                    child: ListTile(
                                      title: Text(
                                        combinedUserName,
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 169, 170, 170),
                                          fontWeight: FontWeight.w400,
                                          wordSpacing: 0,
                                        ),
                                      ),
                                      leading: profilePicture != null
                                          ? Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: 1,
                                                      color: MyColors
                                                          .lighterpriColor)),
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: profilePicture,
                                                  fit: BoxFit.cover,
                                                  fadeInDuration:
                                                      Duration(microseconds: 2),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: 1,
                                                      color: MyColors
                                                          .lighterpriColor)),
                                              child: CircleAvatar(
                                                  backgroundColor:
                                                      MyColors.txtDD,
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.grey,
                                                  )),
                                            ),
                                      subtitle: Text(
                                        '@$fimaTag',
                                        style: TextStyle(
                                            color: MyColors.lighterpriColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15),
                                      ),
                                      // Add other user information here
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
                          })),
                ],
              ),

              //Button
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            enableBtn()
                                ? MyColors
                                    .lighterpriColor //button color if enabled
                                : MyColors.disableBtn //button color if disabled
                            ),
                        elevation: MaterialStateProperty.all<double>(0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18), // Set border radius
                          ),
                        ),
                      ),
                      onPressed: enableBtn() ? () {} : null,
                      child: Text(
                        'Pay',
                        style: TextStyle(
                            color: enableBtn()
                                ? MyColors.textColor1 //button color if enabled
                                : MyColors
                                    .textColorD, //button color if disabled
                            fontSize: 17),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void searchUsers() {
    if (_searchusers.text.isEmpty) {
      setState(() {
        searchedUsers =
            []; // Clear the searchedUsers list when the text field changes
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    FirebaseFirestore.instance
        .collection('Users')
        .where('fimaTag', isGreaterThanOrEqualTo: _searchusers.text)
        .where('fimaTag', isLessThanOrEqualTo: '${_searchusers.text}\uf8ff')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        searchedUsers = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return data;
        }).toList();

        isLoading = false;
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
