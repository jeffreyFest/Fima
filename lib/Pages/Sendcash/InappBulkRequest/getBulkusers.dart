// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fima/Pages/Sendcash/InappBulkRequest/bulkRequest.dart';
import 'package:fima/tools/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InappBulkRequest extends StatefulWidget {
  const InappBulkRequest({Key? key}) : super(key: key);

  @override
  State<InappBulkRequest> createState() => _InappBulkRequestState();
}

class _InappBulkRequestState extends State<InappBulkRequest> {
  late Stream<QuerySnapshot> userStream;
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> searchedUsers = []; //List for the searched users
  List<Map<String, dynamic>> selectedContacts =
      []; //List for the selected users
  TextEditingController requestNames =
      TextEditingController(); //TextField Controller
  bool isLoading = false; //boolean for showing the loading animation
  User? currentUser; // To get the currentUser

  @override
  void initState() {
    super.initState();
    fetchUsers(); //automically fetchUser
    enableBtn(); //automically active button
    currentUser =
        FirebaseAuth.instance.currentUser; //automically get currentUser
  }

//Fetch User from the Database
  void fetchUsers() {
    setState(() {
      isLoading = true; //Start loading animation
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
      isLoading = false; //Stop loading animation
    });
  }

  bool enableBtn() {
    return selectedContacts.length >=
        2; //enable button if selected user is = 2 or greater than
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.secondaryColor,
      body: Padding(
        padding: EdgeInsets.only(
          top: 15,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    //Going back to the previous page
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
                            color: MyColors.textColorD,
                            size: 13,
                          )),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Split request',
                      style: TextStyle(
                          color: MyColors.textColorD,
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
                        top: 60, bottom: 8, left: 15, right: 15),
                    decoration: BoxDecoration(
                        color: MyColors.txtfieldcolor,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.only(left: 23),
                    child: TextFormField(
                      controller: requestNames,
                      cursorColor: MyColors.primaryColor,
                      keyboardType: TextInputType.name,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(
                            r'[^\w.]')), //deny special character expect '_'
                        LowercaseTextFormatter() //make all words in Lowercase
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
                          InappBulkRequests(); //get the users from the InappBulkRequest at the top
                        }
                      },
                    ),
                  ),

                  //display the selectedUsers else show an empty sizedBox
                  selectedContacts.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          width: double.infinity,
                          height: 55,
                          color: MyColors.secondaryColor,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: selectedContacts
                                  .map(
                                      (user) => _buildSelectedContactChip(user))
                                  .toList(),
                            ),
                          ),
                        )
                      : SizedBox(),

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
                              //if the textfield is empty display
                              if (requestNames.text.isEmpty) {
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
                                String incorrectName = requestNames.text;
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

                              //return a ListView with this information
                              return ListView.separated(
                                itemCount: searchedUsers.length,
                                separatorBuilder: (context, index) =>
                                    Container(),
                                itemBuilder: (context, index) {
                                  final user = searchedUsers[index];
                                  String firstName = user[
                                      'first_name']; //get the first_name from database
                                  String lastName = user[
                                      'last_name']; //get the last_name from database
                                  String combinedUserName =
                                      '$firstName $lastName'; //combine both the firstName & lastName
                                  String fimaTag = user[
                                      'fimaTag']; //get the fimaTag from database
                                  final profilePicture = user['profilePicture'];
                                  bool isSelected =
                                      selectedContacts.contains(user);

                                  return GestureDetector(
                                    onTap: () {
                                      // Check if the tapped user is the current user
                                      if (user['user_id'] != currentUser?.uid) {
                                        if (isSelected) {
                                          // If already selected, remove it
                                          setState(() {
                                            selectedContacts.remove(user);
                                          });
                                        } else {
                                          // If not selected, check if it's within the limit (5)
                                          if (selectedContacts.length < 5) {
                                            setState(() {
                                              selectedContacts.add(user);
                                            });
                                          } else {
                                            // Show a snackbar or toast indicating that the limit is reached.
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                "You\'ve reached limit to select.",
                                                style:
                                                    TextStyle(fontSize: 15.5),
                                              ),
                                              duration: Duration(seconds: 2),
                                            ));
                                          }
                                        }
                                      }
                                    },

                                    //List of all the searched name
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
                                    ),
                                  );
                                },
                              );
                            }

                            return Center(
                                child: SpinKitThreeBounce(
                              color: MyColors.lighterpriColor,
                              size: 45,
                            ));
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
                                ? MyColors.lighterpriColor
                                : //button color if enabled
                                MyColors.disableBtn //button color if disabled
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
                      onPressed: enableBtn()
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Bulkrequest(
                                      selectedContacts: selectedContacts),
                                ),
                              );
                            }
                          : null,
                      child: Text(
                        'Request',
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

  Widget _buildSelectedContactChip(Map<String, dynamic> user) {
    String combinedUserName = "${user['first_name']} ${user['last_name']}";
    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3),
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 3,
            ),
            Text(
              combinedUserName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedContacts.remove(user);
                });
              },
              child: Icon(Icons.clear_rounded, size: 17),
            ),
            SizedBox(
              width: 2,
            )
          ],
        ),
      ),
    );
  }

  //Get the search result by using the fimaTag
  void InappBulkRequests() {
    if (requestNames.text.isEmpty) {
      setState(() {
        searchedUsers =
            []; // Clear the searchedUsers list when the text field is empty
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    FirebaseFirestore.instance
        .collection('Users')
        .where('fimaTag',
            isGreaterThanOrEqualTo:
                requestNames.text) // Search with the user fimaTag
        .where('fimaTag',
            isLessThanOrEqualTo:
                '${requestNames.text}\uf8ff') // Search with the user fimaTag even if not completed
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
