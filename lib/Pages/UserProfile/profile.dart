// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, non_constant_identifier_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fima/Pages/Settings/settings.dart';
import 'package:fima/tools/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userprofile extends StatefulWidget {
  const Userprofile( {super.key});

  @override
  State<Userprofile> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  
  User? getuser;
  String firstName = '';
  String lastName ='';
  String _fimatag = '';
  String URF = '';
  String accountnum = '';
  String bankName = '';
  String? _profilePictureUrl;
  bool hideBal = false;

  @override
  void initState() {
    super.initState();
    getuser = FirebaseAuth.instance.currentUser;
    getFimaTag();
    updateFimaTag();
    _getProfilePicture();
  }

  final NumberFormat _numberFormat = NumberFormat('#,##0.00');
 
 Future<void> _getProfilePicture() async{
 SharedPreferences prefs = await SharedPreferences.getInstance();
  final profilePictureUrl = prefs.getString('profilePictureUrl_${getuser!.uid}');

  setState(() {
    _profilePictureUrl = profilePictureUrl;
  });
  }

 Future<void> getFimaTag() async {
 SharedPreferences prefs = await SharedPreferences.getInstance();
 String? retrieveFirstName = prefs.getString('savedfirstname_${getuser!.uid}');
 String? retrieveLastName = prefs.getString('savedlastname_${getuser!.uid}');
 String? retrieveFimaTag = prefs.getString('savedfimatag_${getuser!.uid}');

 if(retrieveFirstName != null && retrieveLastName != null && retrieveFimaTag != null){
  //Already saved, use it
  setState(() {
    firstName = retrieveFirstName;
    lastName =  retrieveLastName;
    _fimatag =  retrieveFimaTag;
  });
 }else{
 //Not saved you it
 DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users') // User collection
        .doc('${getuser!.email}') // Replace with your document ID
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
      _fimatag = getFimaTag;
      });

    prefs.setString('savedfirstname_${getuser!.uid}', getFirstName);
    prefs.setString('savedlastname_${getuser!.uid}', getLastName);
    prefs.setString('savedfimaTag_${getuser!.uid}', getFimaTag);
    } else {
    }
 }
 }

 void updateFimaTag() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc('${getuser!.email}')
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
          _fimatag = updatedFimaTag;
        });

        // Cache the updated name
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('savedfirstname_${getuser!.uid}', updatedFirstName);
          prefs.setString('savedlastname_${getuser!.uid}', updatedLastName);
          prefs.setString('savedfimaTag_${getuser!.uid}', updatedFimaTag);
        });
      } else {
        // Clear the cached name
        SharedPreferences.getInstance().then((prefs) {
          prefs.remove('savedfirstname_${getuser!.uid}');
          prefs.remove('savedfastname_${getuser!.uid}');
          prefs.remove('savedfimaTag_${getuser!.uid}');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
    child: Scaffold(
      backgroundColor: MyColors.secondaryColor,
  body: Padding(
    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
    child: SafeArea(
      child: Column(
        children: [
        Padding(
          padding: const EdgeInsets.only(left: 13, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            Text('$firstName $lastName',
            style: TextStyle(
            color: MyColors.textColor1,
            fontWeight: FontWeight.w500,
            fontSize: 19
              )),
        
            Container(
            width: 40,
            height: 39,
            margin:EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(15),
             border: Border.all(
              color: Color.fromARGB(78, 141, 143, 142),
             )
            ),
            child: IconButton(
              highlightColor: Colors.transparent,
              onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context)=> Settingspage()));
              },
           icon: Icon(Icons.settings_outlined,
           color: MyColors.textColorD)),
            )
           ],
          ),
        ),
          Row(
            children: [
        Container(
            margin: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
     shape: BoxShape.circle,
     border: Border.all(
       width: 1.5,
     color: MyColors.lighterpriColor,
     )
            ),
    child:_profilePictureUrl != null
     ? ClipOval(
       child: CachedNetworkImage(
       imageUrl: _profilePictureUrl!,
       fit: BoxFit.cover,
       width: 70,
       height: 70,
           ),
         )
     : CircleAvatar(
       radius: 30,
       backgroundColor: Color.fromARGB(255, 218, 215, 215),
       child: Icon(
         Icons.person,
         size: 50,
         color: Colors.grey,
       ),
       ),
           ),
      Container(
       margin: EdgeInsets.only(left: 4),
       child: Row(
         children: [
          Text('@$_fimatag',
          style: TextStyle(
          color: MyColors.textColor2,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          ),),
         Image.asset('assets/images/verify.png',
         height: 15,
         width: 15,
         color: MyColors.lighterpriColor,
         ),
        SizedBox(
          height: 20,
          child: VerticalDivider(
           color: Colors.grey,
          ),
        ),
       TextButton(
        onPressed: () {},
        child: Text('0 Friends',
        textAlign: TextAlign.left,
        style: TextStyle(
         fontWeight: FontWeight.w400,
         fontSize: 16,
         color: MyColors.textColorD
        ),
      ),
      )
         ],
       ),
       ),
            ],
          ),
      
          SizedBox(
            height: 20,
          ),
      
         
         
   Container(
    margin: EdgeInsets.only(top: 5),
    width: 320,
    height: 40,
    child: OutlinedButton(
     onPressed: () {
      BankTransfer();
     },
  style: ButtonStyle(
   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(13),
      )),
    side: MaterialStateProperty.all<BorderSide>(
     BorderSide(
      color: MyColors.fadeborderline
     )
    ),
  ),
  child:Text('Fund account',
    style: TextStyle(
      color: MyColors.textColor1,
      fontSize: 17,
      fontWeight: FontWeight.bold
    ),
    )
    ),
      ),
     
    
        TabBar(
         indicatorColor: MyColors.textColor2,
         isScrollable: false,
          indicatorWeight: 2,
         unselectedLabelColor: Color(0xff5d5d5d),
          labelColor: MyColors.textColor2,
       labelStyle: TextStyle(
         fontSize: 16,
         fontWeight: FontWeight.w500
       ),
          tabs: [
           Tab(
    text: 'Transactions',
            ),
      
           Tab(
     text: 'Activity',
            ),
          ],
        ),
    
        Expanded(
          child:  TabBarView(
          children:  [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
         children: [
       Container(
      width: 98,
      height: 100,
      decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      ),
     child: Center(
       child: Image.asset('assets/images/em.png',
       scale: 3.4,  
       ),
     ),
   ),

   Text('It\'s empty in here',
     style: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      color: Colors.grey
     ),
   )
         ],
        ),
    
            Center(
     child: Text('No friends yet',
     style: TextStyle(
       color: Colors.white24,
           fontSize: 18,
           fontWeight: FontWeight.w400
         ),
     ),
            )
           ],
           )),
        ],
      ),
    ),
  )
    ));
  }



void BankTransfer(){{
 showModalBottomSheet(
   backgroundColor: MyColors.showbottomsheet,
   isScrollControlled: true,
   enableDrag: true,
   showDragHandle: true,
  shape: RoundedRectangleBorder(
   borderRadius: BorderRadius.only(
    topLeft: Radius.circular(30),
    topRight: Radius.circular(30) )
     ),
 context: context, 
 builder: (BuildContext context) {
   return Padding(
     padding: const EdgeInsets.only(
      left: 20, right: 20, top: 10
     ),
     child: SizedBox(
      height: 280,
      child: Column(
      children: [
      Text('Fund account',
         style: TextStyle(
         fontSize: 20,
         color: MyColors.textColor3,
        fontWeight: FontWeight.w500
         ),
      ),
     SizedBox(
      height: 10
     ),
     Text('Kindly make payment to the account below',
      style: TextStyle(
         fontSize: 15.5,
         color: MyColors.textColorD,
          fontWeight: FontWeight.w400
            ),),

      SizedBox(
        height: 20,
      ),

     Align(
       alignment: Alignment.bottomLeft,
       child: Text('Account number',
        style: TextStyle(
         fontSize: 15,
         fontWeight: FontWeight.w500,
         color: MyColors.textColorD
             ),),
        ),
   
     Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(accountnum,
         style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Color(0xFF000000),
         ),),
   
        IconButton(
          onPressed: () {
         Clipboard.setData(ClipboardData(text: accountnum)).then((value){
        MotionToast(
            displaySideBar: false,
            icon: Icons.done_outline_rounded,
            iconSize: 40,
            primaryColor:  Color(0xff00E676),
            backgroundType: BackgroundType.solid,
            width: 270,
            height: 70,
            description:   Text("Account number copied",
               textAlign: TextAlign.center,
               style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white,
              ),),
            position: MotionToastPosition.top,
            animationType:  AnimationType.fromTop,
            animationDuration: Duration(milliseconds: 0),
            toastDuration: Duration(seconds: 3),
          ).show(context);
            });
          },
          icon: Icon(
            Icons.copy,
            color: Color(0xff00E676),
            size: 19,
          ),
         )
        ],
        ),
     Align(
      alignment: Alignment.bottomLeft,
        child: Text('Account name',
         style: TextStyle(
         fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF696969),
                  ),),
           ),
       SizedBox(
        height: 5,
      ),
   
     Align(
      alignment: Alignment.bottomLeft,
       child: Text('$firstName $lastName',
        style: TextStyle(
         fontSize: 17,
         fontWeight: FontWeight.w500,
         color: MyColors.textColor3,
         ),),
       ),
     SizedBox(
      height: 18,
     ),
      Align(
        alignment: Alignment.bottomLeft,
         child: Text('Bank name',
           style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF696969),
             ),),
           ),
   
      SizedBox(
        height: 5,
      ),
       Align(
        alignment: Alignment.bottomLeft,
         child: Text(bankName,
           style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Color(0xFF000000),
           ),),
       ),
      ],
      ),
     ),
   );
 });
}

}
} 