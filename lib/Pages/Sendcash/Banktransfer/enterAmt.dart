// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, non_constant_identifier_names, must_be_immutable, unnecessary_null_comparison, library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use
import 'dart:convert';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fima/Pages/Homepage/homeNav.dart';
import 'package:fima/account/sendmoneyAPI.dart';
import 'package:fima/tools/timeFormat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../tools/colors.dart';
import '../../../tools/zigzag.dart';

class EnterAmt extends StatefulWidget {

 final String counterId;
 String? accountName;
 String? bankName;
 String acctNumber;
  EnterAmt({Key? key,
  required this.counterId,
  required this.accountName,
  required this.bankName, 
  required this.acctNumber
  })
   : super(key: key);

 @override
  State<EnterAmt> createState() => _EnterAmtState();
}

class _EnterAmtState extends State<EnterAmt> with WidgetsBindingObserver{

 TextEditingController amount = TextEditingController(); //For Amount 
TextEditingController note = TextEditingController(); //Leaving a note
TextEditingController pinHolder = TextEditingController();
final FocusNode _focusNode = FocusNode();

 int? accountBal;
 bool hideBal = false;
 String counterpartyId = '';
 String accoutName = '';
 String bankName = '';
 String accountNumber = '';
 bool showEmojiPicker = false; // Track the visibility of the emoji picker
 bool isLoading = false;
 String time = '';
 int? amountSent;


@override
void initState() {
  super.initState();
  isPayButtonEnabled();
  enableBtn();
  getBalance();
  WidgetsBinding.instance.addObserver(this);
  counterpartyId = widget.counterId;
  accoutName = widget.accountName!;
  bankName = widget.bankName!;
  accountNumber = widget.acctNumber;
}

@override
  void dispose() {
  WidgetsBinding.instance.removeObserver(this);
  note.dispose();
  super.dispose();
  }

bool enableBtn(){
  return amount.text.isNotEmpty && note.text.isNotEmpty;
}

@override
  void didChangeMetrics() {
    // Called when the keyboard visibility changes
    final isKeyboardVisible = WidgetsBinding.instance.window.viewInsets.bottom != 0;
    if (isKeyboardVisible) {
      setState(() {
        showEmojiPicker = false;
      });
    }
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
     padding: const EdgeInsets.only(
       top: 15
    ),
    child: SafeArea(
      child: Stack(
       alignment: AlignmentDirectional.topCenter,
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
          ],
        ),

      Container(
       margin: EdgeInsets.only(
        left: 20,right: 20
       ),
        child: Column(
         children: [
           SizedBox(
            height: 50,
          ),
        
         Align(
          alignment: Alignment.centerLeft,
           child: Text(accoutName,
            style: TextStyle(
             fontSize: 27,
             color: MyColors.textColor2,
             fontWeight: FontWeight.bold
               ),),
         ),
      
         SizedBox(
          height: 8,
         ),
      
         Align(
          alignment: Alignment.centerLeft,
          child: Text('$bankName($accountNumber)',
            style: TextStyle(
             fontSize: 13.7,
             color: MyColors.textColor2,
             fontWeight: FontWeight.w500
               ),),
         ),
          Container(
           width: double.infinity,
           height: 55,
           margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
             color: MyColors.txtfieldcolor,
             borderRadius: BorderRadius.circular(14)
             ),
           child: Center(
             child: TextFormField(
              controller: amount,
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
         amount.value = amount.value.copyWith(
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
               top: 10
              ),
              decoration: BoxDecoration(
               color: MyColors.txtfieldcolor,
                borderRadius: BorderRadius.circular(10)
              ),
               child: Padding(
                 padding: const EdgeInsets.only(left: 10),
                 child: TextField(
                  controller: note,
                   enableInteractiveSelection: false,
                   keyboardType: TextInputType.name,
                   textInputAction: TextInputAction.done,
                   cursorColor: MyColors.lighterpriColor,
                  style: TextStyle(
                      fontSize: 17,
                      color: MyColors.textColor2,
                    ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                     hintText: 'Add a note',
                    hintStyle: TextStyle(
                     color: MyColors.textColor2,
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
           icon: Icon(
            Icons.emoji_emotions_outlined
            )),
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
           Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       GestureDetector(
        onTap: () {
        setState(() {
          hideBal = !hideBal;
        });
      },
         child: Text(
          'Available Balance: ',
           style: TextStyle(
            fontSize: 15,
            color: MyColors.textColor2,
            fontWeight: FontWeight.w400
           ),
         ),
       ),
      
     GestureDetector(
       onTap: () {
        setState(() {
          hideBal = !hideBal;
        });
        }, 
     child: Text(
      hideBal ? '✱✱✱✱' : formatBalance(accountBal ?? 0),
        style: TextStyle(
        fontSize: 15,
        color: const Color.fromARGB(255, 125, 124, 124),
        fontWeight: FontWeight.w400
         ),
    ))
      ],
      ),

          Container(
          width: double.infinity,
          height: 50,
          margin: EdgeInsets.only(bottom: 10, top: 20,
          left: 20, right: 20),

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
           onPressed: enableBtn() ? (){
            bottomsheet();
           } :null,
           child: Text('Pay',
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
         )
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

  void _onNumpadButtonPressed(String value) {
    if (pinHolder.text.length < 4) {
      setState(() {
        pinHolder.text += value;
      });
      if (pinHolder.text.length == 4) {
        validatePin();
      }
    }
  }

Future<void> validatePin() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedPasscode = prefs.getString('confirmed_passcode_${currentUser!.uid}');
  if (pinHolder.text == storedPasscode) {
    // Correct PIN, navigate to the next page
    setState(() {
      isLoading = true;
    });

   nipTransfer().then((value){
    Navigator.push(context,
      MaterialPageRoute(builder: 
     (context) => Paymentsuccesful(
      amountsent: amountSent, 
      accountName: accoutName,
      reason: note.text,
      timeSent: time
      ))
      );
    });
    
  Navigator.pop(context);
  } else {
    // Invalid PIN, show error message
  pinHolder.clear();
     MotionToast(
          displaySideBar: false,
          primaryColor:  Color(0xffff5353),
          backgroundType: BackgroundType.solid,
          secondaryColor:  Color(0xffea4c4b),
          padding: EdgeInsets.only(
            left: 20,
            right: 20
          ),
          width: 270,
          height: 70,
          description: Center(
              child: Text(
              "Invalid Pin, try again",
               textAlign: TextAlign.center ,
               style: TextStyle(
               fontWeight: FontWeight.w500,
                fontSize: 16,
               color: Colors.white,
              ),),
            ),
          position: MotionToastPosition.top,
          animationType:  AnimationType.fromTop,
          animationDuration: Duration(milliseconds: 1),
          toastDuration: Duration(seconds: 3),
        ).show(context);
  }
}

  void _onCancelPressed() {
    if (pinHolder.text.isNotEmpty) {
     setState(() {
      pinHolder.text = pinHolder.text.substring(0, pinHolder.text.length - 1);
    });
    }
  }

 bool isPayButtonEnabled() {
 if(amount.text.length > 99 && note.text.isNotEmpty){
  return true; // Button is enabled
 }else{
  return false; // Button is disabled
 }
 }

 String formatBalance(int balance) {
  final formatter = NumberFormat.currency(locale: 'en_US', symbol: '₦');
  return formatter.format(balance);
}

String formatAmountWithCommas(String value) {
  final formatter = NumberFormat('#,##0.00', 'en_US');
  final parsedValue = double.tryParse(value);
  if (parsedValue != null) {
    if (parsedValue % 1 == 0) {
      // Format as whole number without decimal places
      return formatter.format(parsedValue).split('.').first;
    } else {
      // Format with decimal places
      return formatter.format(parsedValue);
    }
  }
  return value;
}

Future<void> nipTransfer() async {
  final formattedAmount = amount.text.replaceAll(',', ''); // Remove commas from the formatted amount

  final result = await SendMoney().NipTransfer(
    receiversName: accoutName,
    receiversBank: bankName,
    amount: formattedAmount,
    note: note.text,
    id: counterpartyId, 
  );
 
 if (result != null) {
    int amountsent = result['amount'];
    String timepaid = result['timeStamp'];

    setState(() {
      amountSent = amountsent;
      time = timepaid;
    });
  }
}

 Future<void> getBalance() async{
  final url = Uri.parse('https://api.sandbox.getanchor.co/api/v1/accounts/balance/1688828017333134-anc_acc');

  final header = {
    'accept': 'application/json',
    'content-type': 'application/json',
    // My request API key
    'x-anchor-key': 'f9Ehq.ef607b1d168cff00c7794f7d96fdaa1f62961e25c1f23fb92711fc054e608494f28b5498c5dbdba1b0c01b563c815994a467',
  };

  final response = await http.get(url, headers: header);

  if(response.statusCode == 200){
   final responseData = json.decode(response.body);
   final availableBal = responseData['data']['availableBalance'];
   print(response.body);
   setState(() {
    accountBal = availableBal;
    isLoading = false;
   });
  }else{
   print(response.body);
  }
 }

  void bottomsheet(){
  showModalBottomSheet(isScrollControlled: true,
    backgroundColor: MyColors.showbottomsheet,
        useSafeArea: true,
        enableDrag: true,
        elevation: 2,
        shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
         topRight: Radius.circular(30) )
      ),
     context: context,
     builder: (context) {
   return Stack(
     children: [
       SizedBox(
        height: 430,
        child: isLoading ? Center(
         child: SpinKitThreeBounce(
        color: MyColors.lighterpriColor,
        size: 50,
        )
          ) : Padding(
          padding: EdgeInsets.only(left: 15, top: 15, right: 15),
          child: Column(
           children: [
            Text('PIN',
            style: TextStyle(
              color: MyColors.textColorD,
             fontWeight: FontWeight.bold,
             fontSize: 19
            ),
            ),
              Container(
                width: 120,
                  height: 40,
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  decoration: BoxDecoration(
                 color: MyColors.pinfield,
                 borderRadius: BorderRadius.circular(13)),
                  child: Center(
                    child: Padding(
                 padding: const EdgeInsets.only(top:10),
                 child: TextField(
                controller: pinHolder,
                textAlign: TextAlign.center,
                obscuringCharacter: '●',
                obscureText: true,
                style: TextStyle(
                fontSize: 25, 
                color: MyColors.primaryColor,
                fontWeight: FontWeight.bold
                ),
                keyboardType: TextInputType.none,
                inputFormatters: [
               FilteringTextInputFormatter.digitsOnly,
                ],
                cursorColor: MyColors.lighterpriColor,
                decoration: InputDecoration(
               border: InputBorder.none,
                ),
                 ),
                    ),
                  ),
                ),
            
            Column(
                mainAxisAlignment: MainAxisAlignment.end,
               children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKey('1'),
                  _buildKey('2'),
                  _buildKey('3'),
                ],
                 ),
                 Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKey('4'),
                  _buildKey('5'),
                  _buildKey('6'),
                ],
                 ),
                 Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKey('7'),
                  _buildKey('8'),
                  _buildKey('9'),
                ],
                 ),
                 Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 44,
                  ),
                  Center(child: _buildKey('0')),
                  IconButton(
                 onPressed: () {
                  _onCancelPressed();
                 },
                icon: Image.asset('assets/images/clear.png',
                scale: 18,
                color: MyColors.lighterpriColor))
                ],
                 ),     
               ],
                )
           ],
          ),
        ),
       ),
     ],
   );

    });
 }
 
 Widget _buildKey(String value) {
    return MaterialButton(
      height: 80.0,
      minWidth: 85.0,
      highlightColor: MyColors.lighterpriColor,
      splashColor: Colors.transparent,
      textColor: MyColors.textColor2,
      onPressed: () => _onNumpadButtonPressed(value),
      shape: CircleBorder(),
      child: Text(
        value,
        style: TextStyle(fontSize: 29, 
        fontWeight: FontWeight.w500),
      ),
    );
  }
}



class Paymentsuccesful extends StatefulWidget {
  final String accountName;
  final String reason;
  final String timeSent;
  final int? amountsent;
  const Paymentsuccesful({super.key,
   required this.accountName, required this.reason, required this.timeSent, required this.amountsent });

  @override
  State<Paymentsuccesful> createState() => _PaymentsuccesfulState();
}

class _PaymentsuccesfulState extends State<Paymentsuccesful> {

  String accountName = '';
  String reason = '';
  String timeSent = '';
  int? amountSent;

   String formatBalance(int moneysent) {
  final formatter = NumberFormat.currency(locale: 'en_US', symbol: '₦');
  return formatter.format(moneysent).replaceAll('.00', '');
  }


  @override
  void initState() {
  super.initState();
   amountSent = widget.amountsent;
   accountName = widget.accountName;    
   reason = widget.reason;
   timeSent = widget.timeSent;
  }

  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: MyColors.lighterpriColor,

    body: Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 30
      ),
      child: SafeArea(
       child: Stack(
         children: [
              ClipPath(
              clipper: ZigZagClipper(),
               child: ClipRRect(
                  child: Container(
                    height: 400,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20,left: 5, right: 5),
                    child: Card(
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.only(
                       topLeft: Radius.circular(20.0),
                       topRight: Radius.circular(20.0),
                          ),
                      ),
                      elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20
                    ),
                    child: Stack(
                     alignment: AlignmentDirectional.topCenter,
                     children: [
                      Column(
                       children: [
                      Image.asset('assets/images/chec.png',
                       color: MyColors.lighterpriColor,
                       scale: 10,
                      ),
                    
                     Text('Money sent',
                     style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: MyColors.pinfield
                      ),
                     ),
                    
                    SizedBox(
                      height: 40,
                    ),
                  
                     Text('Amount',
                     style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: MyColors.textColorD
                      )
                     ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(formatBalance(amountSent!),
                      style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28
                      )),
                    
                    SizedBox(
                    height: 10,
                    ),
       
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Summary',
                       style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: MyColors.textColor2
                        )
                      ),
                    ),
                    Container(
                     width: double.infinity,
                     height: 60,
                     margin: EdgeInsets.only(top: 8),
                     decoration: BoxDecoration(
                      color: Color.fromARGB(45, 127, 137, 132),
                      borderRadius: BorderRadius.circular(10)
                     ),
                  
                  child: Center(
                      child: RichText(
                       textAlign: TextAlign.center,
                       text: TextSpan(
                     text: 'Sent to ',
                      style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 15
                   ),
                children: [
                     TextSpan(
                     text:accountName,
                    style: TextStyle(
                    color: MyColors.primaryColor,
                     fontWeight: FontWeight.w400,
                     fontSize: 16
                   ),
               ),
               TextSpan(
                 text: ' for\n',
                 style: TextStyle(
                 color: Colors.black87,
                 fontWeight: FontWeight.w400,
                 fontSize: 16
            ),
         ),

         TextSpan(
          text: "'$reason'",
            style: TextStyle(
              color: MyColors.primaryColor,
              fontWeight: FontWeight.w400,
              fontSize: 16
            ),
         ),
         ]
             ),
               ),)
         ),
        
        SizedBox(
         height: 10,
        ),
          Text (
            formatDateTime(timeSent),
             textAlign: TextAlign.center,
             style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w400,
              fontSize: 14
            ),
        )
           ], ),
       
                  Column(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     Container(
                  width: double.infinity,
                  height: 45,
                  margin: EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                       MyColors.secondaryColor
                      ),
                     elevation:  MaterialStateProperty.all<double>(0),
                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Set border radius
                      ),
                    ),
                    ),
                   onPressed:() {
                   },
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                      Icon(Icons.share),
                       SizedBox(
                        width: 6,
                       ),
                       Text('Share',
                       style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                       ),
                       ),
                     ],
                   ),
                  ),
                  ),
                   ],
                  )
                     ],
                    ),
                  ),
                    ),
                  ),
                    ),
                  ),

                 Column(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                       Color.fromARGB(53, 55, 255, 161)
                      ),
                     elevation:  MaterialStateProperty.all<double>(0),
                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Set border radius
                      ),
                    ),
                    ),
                   onPressed:() {
                    Navigator.pushAndRemoveUntil(context,
                     MaterialPageRoute(builder: 
                    (context) => Homenav()), (route) => false
                  );
                   },
                   child: Text('Done',
                       style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                       ),
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
}