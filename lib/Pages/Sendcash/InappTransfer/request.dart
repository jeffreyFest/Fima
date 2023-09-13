// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, non_constant_identifier_names, must_be_immutable, unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fima/Pages/Homepage/homeNav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../tools/colors.dart';
import '../../../tools/formatamount.dart';

class Requestmoney extends StatefulWidget {
  String fimaTag;
  String? Profilepic;
  String Name;
 Requestmoney({Key? key, required this.fimaTag,
  required this.Profilepic, 
  required this.Name}) : super(key: key);

  @override
  _RequestmoneyState createState() => _RequestmoneyState();
}

class _RequestmoneyState extends State<Requestmoney> {
TextEditingController amt = TextEditingController();
TextEditingController note =TextEditingController();
String? fimatag;
 bool showEmojiPicker = false;
 final _focusNode = FocusNode();
 bool isLoading = false;

@override
void initState() {
  super.initState();
  fimatag = widget.fimaTag; 
}
 @override
  void dispose() {
  note.dispose();
  _focusNode.dispose();
  super.dispose();
  }
  
  bool enableBtn(){
  return amt.text.isNotEmpty &&
  note.text.isNotEmpty;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: MyColors.secondaryColor,
    body: isLoading ? Center(
         child: SpinKitThreeBounce(
        color: MyColors.lighterpriColor,
        size: 50,
        )
          ) : Padding(
             padding: const EdgeInsets.only( top: 15
            ),
            child: SafeArea(
      child: Stack(
          children: [

       Row(
         children: [
           Container(
            width: 30,
            height: 30,
            margin: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: MyColors.textColorD,
                width: 1
              )
            ),
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
          width: 15,
         ),
        Text('Request',
        style: TextStyle(
          color: MyColors.textColor2,
          fontSize: 17,
          fontWeight: FontWeight.w500
        ),)
         ],
       ),
         
      Padding(
        padding: const EdgeInsets.only(
          left: 20, right: 20
        ),
        child: Column(
          children: [
            SizedBox(
            height: 65,
          ),
         Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            RichText(text: TextSpan(
             text: widget.Name,
              style: TextStyle(
              fontSize: 22,
              color: MyColors.textColor2,
              fontWeight: FontWeight.w500
             ),
            children: [
             TextSpan(
              text: '\n@$fimatag',
            style: TextStyle(
            fontSize: 16,
           color: MyColors.primaryColor,
            fontWeight: FontWeight.w500
          ),
             )
            ]
            ),
            ),
             
             widget.Profilepic != null
                ? 
            Center(
              child: Container(
           width: 40,
           height: 40,
          decoration: BoxDecoration(
          shape: BoxShape.circle,
            ),
           child: ClipOval(
          child: CachedNetworkImage(
          imageUrl: widget.Profilepic!,
          fit: BoxFit.cover,
          fadeInDuration: Duration(microseconds: 2),
            ),
              ),
           ),
            ) :
                 Center(
           child: Container(
            width: 40,
            height: 40,
           decoration: BoxDecoration(
           shape: BoxShape.circle,
           border: Border.all(
            width: 1,
             )
           ),
                child: CircleAvatar(
                 backgroundColor: MyColors.txtDD,
                 child: Icon(Icons.person,
                 color: Colors.grey,
            )
             ),
               ),
                 ),
           ]
          ),
        
          Container(
           width: double.infinity,
           height: 60,
           margin: EdgeInsets.only(top: 30,
           ),
            decoration: BoxDecoration(
             color: MyColors.txtfieldcolor,
             borderRadius: BorderRadius.circular(14)
             ),
           child: Center(
             child: TextFormField(
              controller: amt,
              cursorColor: MyColors.lighterpriColor,
              keyboardType: TextInputType.number,
              inputFormatters: [
               FilteringTextInputFormatter.digitsOnly
              ],
              textInputAction: TextInputAction.next,
              style: TextStyle(
                  color: MyColors.textColor2,
                  fontSize: 20,
                  fontWeight: FontWeight.w400
                 ),
              decoration: InputDecoration(
               border: InputBorder.none,
               prefixIcon: Padding(
                 padding: const EdgeInsets.only(
                  right: 8,
                  top: 14,
                  left: 8
                 ),
                 child: Text('NGN',
                 style: TextStyle(
                  color: MyColors.textColorD,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                 ),
                 ),
               ),
              hintText: '0.00',
              hintStyle: TextStyle(
                color: MyColors.textColor2,
                fontSize: 20,
                fontWeight: FontWeight.w400
                 ),
              ),
           onChanged: (value) {
         setState(() {
           enableBtn();
         });
         final formattedAmount = formatAmountWithCommas(value);
         amt.value = amt.value.copyWith(
        text: formattedAmount,
        selection: TextSelection.collapsed(offset: formattedAmount.length),
          );
          },
             ),
           ),
              ),
         Container(
        width: double.infinity,
        height: 45,
        margin: EdgeInsets.only(
        top: 10, 
          ),
           decoration: BoxDecoration(
        color: MyColors.txtfieldcolor,
        borderRadius: BorderRadius.circular(10)
              ),
               child: Padding(
         padding: const EdgeInsets.only(left: 10),
         child: TextField(
           controller: note,
           focusNode: _focusNode,
           cursorColor: MyColors.lighterpriColor,
           keyboardType: TextInputType.name,
           textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.newline,
          style: TextStyle(
            color: MyColors.textColor2,
              fontSize: 17,
            ),
          decoration: InputDecoration(
            border: InputBorder.none,
             hintText: 'Add a note',
            hintStyle: TextStyle(
             color: Color.fromARGB(255, 78, 80, 80),
              fontSize: 17,
            ),
          suffixIcon: IconButton(
            color: MyColors.primaryColor,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
           _focusNode.unfocus(); // Hide the default keyboard
            setState(() {
          showEmojiPicker = !showEmojiPicker;
        });
      
        // Hide/show the keyboard
        if (showEmojiPicker) {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        } else {
          SystemChannels.textInput.invokeMethod('TextInput.show');
        }
      },
           icon: Icon(Icons.emoji_emotions_outlined)),
          ),
          onChanged: ((_) {
            setState(() {
           enableBtn();
         });
          }),
         ),
               )
              ),
            ],
              ),
      ),
      
    Column(
      mainAxisAlignment: MainAxisAlignment.end,
       children: [
       Container(
          width: double.infinity,
          height: 50,
          margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: ElevatedButton(
            style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              enableBtn() ? 
              MyColors.lighterpriColor :
              MyColors.disableBtn
            ),
             elevation:  MaterialStateProperty.all<double>(0),
             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25), // Set border radius
              ),
            ),
            ),
           onPressed: enableBtn() ? () async {
               setState(() {
                isLoading = true;
          });

      // Save the requested amount and note to Firestore
      final amount = double.parse(amt.text.replaceAll(',', '')); // Remove commas from the formatted amount
      final noteText = note.text;
      final currentDateTime = DateTime.now();
     
     // Convert DateTime to the desired timestamp format "2023-07-28T14:28:24.632422"
      String timestampString = currentDateTime.toUtc().toIso8601String();

      try {
        final auth = FirebaseAuth.instance.currentUser;
        final docRef = await FirebaseFirestore.instance.collection('Transactions')
        .doc(auth?.email)
        .collection('Send&Request')
        .add({
          'from': 'dcreator',
          'receivers_Tag': fimatag, 
          'receivers_fullName': widget.Name,
          'amount': amount,
          'reason': noteText,
          'type': 'request',
          'timeStamp': timestampString
        });

        setState(() {
          isLoading = false;
        });

        // Show a success notification or perform any other actions after successful request

        // Navigate back to the previous screen after the request is successful
    
      requestSuccesful(amt.text);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        // Handle any errors that occur during the request process
        print('Error: $e');
      }
    }
  : null,
           child: Text('Request',
           style: TextStyle(
         color: enableBtn() ? 
          MyColors.textColor1 
           :MyColors.textColorD,
         fontSize: 17
           ),
           ),
          ),
          ),
        
        Offstage(
         offstage: !showEmojiPicker,
        child: SizedBox(
          height: 270,
          child: EmojiPicker(
           textEditingController: note,
           onBackspacePressed: _onBackspacePressed,
           config: Config(
            columns: 7,
            verticalSpacing: 0,
            horizontalSpacing: 0,
            bgColor: MyColors.showbottomsheet,
            indicatorColor: MyColors.lighterpriColor,
            iconColorSelected: MyColors.primaryColor,
            backspaceColor: Colors.grey,
            enableSkinTones: true,
            recentTabBehavior: RecentTabBehavior.POPULAR,
            recentsLimit: 20,
            tabIndicatorAnimDuration: Duration(microseconds: 1),
            buttonMode: ButtonMode.CUPERTINO
           ),
          ),
        ),
       ),
 
            ],
          ),
          ],
          ),
            ),
          ),
  );
  }
  
  _onBackspacePressed() {
    note
      ..text = note.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: note.text.length));
  }
 
 void requestSuccesful(String amount){
  showModalBottomSheet(
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: MyColors.showbottomsheet,
        useSafeArea: true,
        enableDrag: true,
        elevation: 2,
        shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
         topRight: Radius.circular(30) )
      ),
    context: context, 
    builder: ((context) {
     return SizedBox(
      height: 300,
       child: Stack(
        alignment: Alignment.topCenter,
        children: [
      Column(
       children: [
        SizedBox(
            height: 29,
          ),
        Image.asset(
           'assets/images/check.png',
           color: MyColors.lighterpriColor,
           scale: 5.5,
          ),
      
      SizedBox(
        height: 30,
      ),
    
       Text('You\'ve requested ₦$amount from\n@$fimatag',
       textAlign: TextAlign.center,
       style: TextStyle(
        color: MyColors.textColor2,
        fontWeight: FontWeight.w400,
        fontSize: 19.3
       ),),
       ],
      ),

      Column(
      mainAxisAlignment: MainAxisAlignment.end,
       children: [
       Container(
          width: double.infinity,
          height: 50,
          margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: ElevatedButton(
            style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
             Color.fromARGB(255, 31, 31, 31)
            ),
             elevation:  MaterialStateProperty.all<double>(0),
             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Set border radius
              ),
            ),
            ),
           onPressed:() {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Homenav()));
           },
           child: Text('Done',
           style: TextStyle(
         color: MyColors.textColor1,
         fontSize: 17
           ),
           ),
          ),
          ),
        ]),
        ],
       ),   
      );
    }));
 }
}