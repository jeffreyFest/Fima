// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, non_constant_identifier_names

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fima/Pages/Settings/editProfile/personalInfo.dart';
import 'package:fima/Pages/identity%20verification/verificationOpt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../tools/colors.dart';
import '../getStarted.dart';
import 'changepin.dart';

class Settingspage extends StatefulWidget {
  const Settingspage({super.key});

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {
  String? imageUrl;
  String firstName = '';
  String lastName = '';
  String fimaname = '';
  File? _image;
  String? _profilePictureUrl;

  final FirebaseAuth auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _getname();
    getFimaTag();
    updateFimaTag();
    _getProfilePicture();
  }

  Future<void> _pickedImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });

      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    FirebaseAuth.instance.currentUser!.updatePhotoURL(
      _profilePictureUrl,
    );

    final storegRef = FirebaseStorage.instance
        .ref()
        .child('Profile_pictures')
        .child('${_user!.email}');

    final uploadTask = storegRef.putFile(_image!);
    final snapshot = await uploadTask.whenComplete(() {});

    if (snapshot.state == TaskState.success) {
      final downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _profilePictureUrl = downloadUrl;
      });
    }

    await FirebaseFirestore.instance
        .collection('Users')
        .doc('${_user!.email}')
        .update({'profilePicture': _profilePictureUrl});

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'profilePictureUrl_${_user!.uid}', _profilePictureUrl!);
  }

  Future<void> _getProfilePicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final profilePictureUrl =
        prefs.getString('profilePictureUrl_${_user!.uid}');

    setState(() {
      _profilePictureUrl = profilePictureUrl;
    });
  }

  _getname() {
    User? user = auth.currentUser;
    setState(() {
      _user = user;
    });
  }

  Future<void> getFimaTag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? retrieveFirstName = prefs.getString('savedfirstname_${_user!.uid}');
    String? retrieveLastName = prefs.getString('savedlastname_${_user!.uid}');
    String? retrieveFimaTag = prefs.getString('savedfimaTag_${_user!.uid}');

    if (retrieveFirstName != null &&
        retrieveLastName != null &&
        retrieveFimaTag != null) {
      //Already saved, use it
      setState(() {
        firstName = retrieveFirstName;
        lastName = retrieveLastName;
        fimaname = retrieveFimaTag;
      });
    } else {
      //Not saved you it
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users') // Replace with your collection name
          .doc('${_user!.email}') // Replace with your document ID
          .get();

      if (snapshot.exists) {
        // Document exists
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String getFirstName = data['first_name'];
        String getLastName = data['last_name'];
        String getFimaTag = data['fimaTag'];

        setState(() {
          firstName = getFirstName;
          lastName = getLastName;
          fimaname = getFimaTag;
        });

        prefs.setString('savedfirstname_${_user!.uid}', getFirstName);
        prefs.setString('savedlastname_${_user!.uid}', getLastName);
        prefs.setString('savedfimaTag_${_user!.uid}', getFimaTag);
      } else {}
    }
  }

  void updateFimaTag() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc('${_user!.email}')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        // Document has changed
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String updatedFirstName = data['first_name'];
        String updatedLastName = data['last_name'];
        String updatedFimaTag = data['fimaTag'];
        setState(() {
          firstName = updatedFirstName;
          lastName = updatedLastName;
          fimaname = updatedFimaTag;
        });

        // Cache the updated name
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('savedfirstname_${_user!.uid}', updatedFirstName);
          prefs.setString('savedlastname_${_user!.uid}', updatedLastName);
          prefs.setString('savedfimaTag_${_user!.uid}', updatedFimaTag);
        });
      } else {
        // Clear the cached name
        SharedPreferences.getInstance().then((prefs) {
          prefs.remove('savedfirstname_${_user!.uid}');
          prefs.remove('savedlastname_${_user!.uid}');
          prefs.remove('savedfimaTag_${_user!.uid}');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0c0c0c),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 20,
                  right: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                          color: MyColors.textColor1,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close_rounded,
                        color: MyColors.white,
                        size: 25,
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    width: double.infinity,
                    height: 283,
                    margin: EdgeInsets.only(left: 18, right: 18),
                    padding: EdgeInsets.only(top: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: MyColors.greyColor,
                    ),
                    child: Column(
                      children: [
                        showProfilepic(),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '$firstName $lastName',
                          style: TextStyle(
                              color: MyColors.textColor1,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5.5,
                        ),
                        Text(
                          '@$fimaname',
                          style: TextStyle(
                              color: MyColors.textColor2,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 15, bottom: 10, left: 20, right: 20),
                          width: double.infinity,
                          height: 43,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PersonalInfo()));
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xff454648)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                              ),
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                    color: MyColors.textColor1,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              )),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Divider(
                            thickness: 1,
                            color: Color.fromARGB(255, 39, 40, 43),
                          ),
                        ),
                        ListTile(
                          onTap: () => _pickedImage(ImageSource.gallery),
                          leading: Container(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Image.asset('assets/images/addphoto.png',
                                  color: MyColors.lighterpriColor, scale: 18),
                            ),
                          ),
                          title: Text(
                            'Add a profile photo',
                            style: TextStyle(
                                fontSize: 16,
                                color: MyColors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            'Help people find you',
                            style: TextStyle(
                                fontSize: 14,
                                color: MyColors.textColorD,
                                fontWeight: FontWeight.w400),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: MyColors.textColorD,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  //KYC Verification Placeholder
                  Container(
                    width: double.infinity,
                    height: 70,
                    margin: EdgeInsets.only(left: 18, right: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: MyColors.greyColor,
                    ),
                    child: Center(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerificationOpt()));
                        },
                        leading: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: MyColors.lighterpriColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.verified,
                              color: MyColors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          'KYC verification',
                          style: TextStyle(
                              fontSize: 16,
                              color: MyColors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          'To get full access',
                          style: TextStyle(
                              fontSize: 14,
                              color: MyColors.textColorD,
                              fontWeight: FontWeight.w400),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: MyColors.textColorD,
                          size: 16,
                        ),
                      ),
                    ),
                  ),

                  //General setting field
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 30, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ACCOUNT & SETTINGS',
                        style: TextStyle(
                            color: MyColors.textColorD,
                            fontSize: 11,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    height: 290,
                    color: MyColors.greyColor,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            security();
                          },
                          leading: Icon(
                            Icons.key,
                            color: MyColors.white,
                          ),
                          title: Text(
                            'Security',
                            style: TextStyle(
                                fontSize: 16,
                                color: MyColors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: MyColors.textColorD,
                            size: 16,
                          ),
                        ),

                        ListTile(
                          onTap: () {},
                          leading: Icon(
                            Icons.group,
                            color: MyColors.white,
                          ),
                          title: Text(
                            'Benficiaries',
                            style: TextStyle(
                                fontSize: 16,
                                color: MyColors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: MyColors.textColorD,
                            size: 16,
                          ),
                        ),

                        // Notifications setting
                        ListTile(
                          onTap: () {},
                          leading: Icon(
                            Icons.notifications,
                            color: MyColors.white,
                          ),
                          title: Text(
                            'Notifications',
                            style: TextStyle(
                                fontSize: 16,
                                color: MyColors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: MyColors.textColorD,
                            size: 16,
                          ),
                        ),

                        ListTile(
                          onTap: () {},
                          leading: Icon(
                            Icons.headset_mic,
                            color: MyColors.white,
                          ),
                          title: Text(
                            'Help & Support',
                            style: TextStyle(
                                fontSize: 16,
                                color: MyColors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: MyColors.textColorD,
                            size: 16,
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: Icon(
                            Icons.library_books,
                            color: MyColors.white,
                          ),
                          title: Text(
                            'About us',
                            style: TextStyle(
                                fontSize: 16,
                                color: MyColors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: MyColors.textColorD,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      signoutOption();
                    },
                    child: Container(
                        width: 180,
                        height: 70,
                        margin: EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                            color: MyColors.bottomNav,
                            borderRadius: BorderRadius.circular(23)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logout.png',
                              scale: 25,
                              color: Color.fromARGB(219, 250, 19, 3),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Log Out',
                              style: TextStyle(
                                  color: MyColors.textColor3,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        )),
                  ),

                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signoutOption() {
    showModalBottomSheet(
        backgroundColor: MyColors.showbottomsheet,
        context: context,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        builder: (Buildcontext) {
          return SizedBox(
            height: 280,
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(children: [
                SizedBox(
                  height: 20,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Logout',
                      style: TextStyle(
                          fontSize: 22,
                          color: MyColors.textColor1,
                          fontWeight: FontWeight.w500),
                    )),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                        text: 'Oh no! You\'re leaving....\n',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: MyColors.textColorD,
                        ),
                        children: [
                          TextSpan(
                            text: 'Are you sure?',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: MyColors.textColorD),
                          )
                        ]),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: ButtonTheme(
                      minWidth: double.infinity,
                      height: 55,
                      splashColor: Colors.transparent,
                      child: MaterialButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut().then((value) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Getstarted()),
                                (route) => false);
                          });
                        },
                        elevation: 0,
                        focusElevation: 0,
                        splashColor: Colors.transparent,
                        color: Color.fromARGB(219, 196, 22, 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23)),
                        child: Text(
                          'Yes, Logout me',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Nah, just kidding ',
                    style: TextStyle(
                        color: MyColors.textColorD,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                ),
              ]),
            ),
          );
        });
  }

  Widget showProfilepic() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 29,
              backgroundColor: Colors.grey[200],
              child: _image != null
                  ? ClipOval(
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    )
                  : (_profilePictureUrl != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: _profilePictureUrl!,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                        )
                      : Icon(Icons.person, size: 40, color: Colors.grey)),
            ),
            Positioned(
                top: 33,
                left: 30,
                child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: MyColors.lighterpriColor,
                        shape: BoxShape.circle),
                    child: Icon(
                      Icons.camera_alt,
                      color: MyColors.white,
                      size: 16,
                    )))
          ],
        ),
      ],
    );
  }

  void security() {
    showModalBottomSheet(
        backgroundColor: MyColors.showbottomsheet,
        context: context,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        builder: (Buildcontext) {
          return SizedBox(
              height: 250,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Security',
                          style: TextStyle(
                              fontSize: 22,
                              color: MyColors.textColor1,
                              fontWeight: FontWeight.w500),
                        )),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CurrentPIN()));
                      },
                      child: Container(
                          width: double.infinity,
                          height: 75,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                              color: MyColors.txtfieldcolor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Change PIN',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: MyColors.textColor2,
                                      fontWeight: FontWeight.w500),
                                ),
                                Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: MyColors.textColorD,
                                      size: 18,
                                    ))
                              ])),
                    ),

                    //For ID(identity) verification
                    Container(
                      width: double.infinity,
                      height: 75,
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          color: MyColors.txtfieldcolor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Change Password',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: MyColors.textColor2,
                                  fontWeight: FontWeight.w500),
                            ),
                            Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: MyColors.textColorD,
                                  size: 18,
                                ))
                          ]),
                    ),
                  ],
                ),
              ));
        });
  }
}
