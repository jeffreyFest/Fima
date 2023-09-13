// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, non_constant_identifier_names, must_be_immutable, unnecessary_null_comparison, use_build_context_synchronously, deprecated_member_use

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fima/account/sendmoneyAPI.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../tools/colors.dart';
import '../../../tools/formatamount.dart';
import '../../../tools/timeFormat.dart';
import '../../../tools/zigzag.dart';
import '../../Homepage/homeNav.dart';

class Payusers extends StatefulWidget {
  String fimatransferId;
  String fimaTag;
  String? Profilepic;
  String Name;

  Payusers({
    Key? key,
    required this.fimaTag,
    required this.Profilepic,
    required this.Name,
    required this.fimatransferId,
  }) : super(key: key);

  @override
  _PayusersState createState() => _PayusersState();
}

class _PayusersState extends State<Payusers> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    enableBtn();
    fimatag = widget.fimaTag;
    receiversID = widget.fimatransferId;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    note.dispose();
    super.dispose();
  }

  TextEditingController amt = TextEditingController(); //Amount field
  TextEditingController note = TextEditingController(); //Note field
  TextEditingController pinHolder = TextEditingController(); //Confirm Pay pin

  String? fimatag; //for the Fimatag name
  String receiversID = ''; //Users Fimaacount_Id
  int? amountSent;
  String timePaid = '';
  bool isLoading = false;
  bool showEmojiPicker = false; // Track the visibility of the emoji picker
  final FocusNode _focusNode = FocusNode();

  bool enableBtn() {
    return amt.text.isNotEmpty && note.text.isNotEmpty;
  }

  @override
  void didChangeMetrics() {
    // Called when the keyboard visibility changes
    final isKeyboardVisible =
        WidgetsBinding.instance.window.viewInsets.bottom != 0;
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
      appBar: AppBar(
        backgroundColor: MyColors.secondaryColor,
        elevation: 1,
        shadowColor: Color.fromARGB(255, 127, 127, 127),
        leading: IconButton(
            onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
        title: Text(
          widget.Name,
          style: TextStyle(
              fontSize: 18, color: MyColors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: isLoading
          ? Center(
              child: SpinKitThreeBounce(
              color: MyColors.lighterpriColor,
              size: 50,
            ))
          : Padding(
              padding: const EdgeInsets.only(top: 15),
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: TextFormField(
                            controller: amt,
                            cursorColor: MyColors.lighterpriColor,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                                color: MyColors.textColor3,
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    right: 8, top: 14, left: 8),
                                child: Text(
                                  'NGN',
                                  style: TextStyle(
                                      color: MyColors.textColor3,
                                      fontSize: 16.4,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              hintText: '0.00',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 78, 80, 80),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                            onChanged: (value) {
                              setState(() {
                                enableBtn();
                              });
                              final formattedAmount =
                                  formatAmountWithCommas(value);
                              amt.value = amt.value.copyWith(
                                text: formattedAmount,
                                selection: TextSelection.collapsed(
                                    offset: formattedAmount.length),
                              );
                            },
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Color.fromARGB(255, 39, 40, 43),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: TextField(
                            controller: note,
                            focusNode: _focusNode,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.newline,
                            cursorColor: MyColors.lighterpriColor,
                            style: TextStyle(
                              color: MyColors.textColor3,
                              fontSize: 17,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Add a note or emoji',
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 78, 80, 80),
                                fontSize: 17,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    right: 8, top: 14, left: 8),
                                child: Text(
                                  'For',
                                  style: TextStyle(
                                      color: MyColors.textColor3,
                                      fontSize: 16.4,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            onChanged: ((_) {
                              setState(() {
                                enableBtn();
                              });
                            }),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Color.fromARGB(255, 39, 40, 43),
                        ),
                        Padding(
                            padding:
                                EdgeInsets.only(left: 20, right: 15, top: 10),
                            child: Row(
                              children: [
                                Text(
                                  'Send as',
                                  style: TextStyle(
                                      color: MyColors.textColor3,
                                      fontSize: 16.4,
                                      fontWeight: FontWeight.w500),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 85,
                                    height: 27,
                                    margin: EdgeInsets.only(left: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color.fromARGB(248, 79, 79, 79),
                                    ),
                                    child: Center(
                                        child: Text(
                                      'Single',
                                      style: TextStyle(
                                          color: MyColors.textColor1,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 85,
                                    height: 27,
                                    margin: EdgeInsets.only(left: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color.fromARGB(248, 79, 79, 79),
                                    ),
                                    child: Center(
                                        child: Text(
                                      'Bulk',
                                      style: TextStyle(
                                          color: MyColors.textColor1,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    )),
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 50,
                          margin:
                              EdgeInsets.only(bottom: 10, left: 20, right: 20),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  enableBtn()
                                      ? MyColors.lighterpriColor
                                      : MyColors.disableBtn),
                              elevation: MaterialStateProperty.all<double>(0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      18), // Set border radius
                                ),
                              ),
                            ),
                            onPressed: enableBtn()
                                ? () {
                                    bottomsheet();
                                  }
                                : null,
                            child: Text(
                              'Pay',
                              style: TextStyle(
                                  color: enableBtn()
                                      ? MyColors.textColor1
                                      : MyColors.textColorD,
                                  fontSize: 17),
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

  ///Correct formatting the number ton have comma
  String formatBalance(int balance) {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '₦');
    return formatter.format(balance);
  }

  //Api call to fima to fima account
  Future<void> Fima2Fima() async {
    final formattedAmount =
        amt.text.replaceAll(',', ''); // Remove commas from the formatted amount
    // final timeSent = formatDateTime(timePaid);

    final result = await SendMoney().Sendfundsinapp(
      receiverTag: fimatag!,
      receiversName: widget.Name,
      amount: formattedAmount,
      receiverId: receiversID,
      reason: note.text,
    );

    if (result != null) {
      int amountsent = result['amount'];
      String timepaid = result['timeStamp'];

      setState(() {
        amountSent = amountsent;
        timePaid = timepaid;
      });
    }
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
    String? storedPasscode =
        prefs.getString('confirmed_passcode_${currentUser!.uid}');
    if (pinHolder.text == storedPasscode) {
      // Correct PIN, navigate to the next page
      setState(() {
        isLoading = true;
      });

      Fima2Fima().then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InappPaymentsuccessful(
                      amountsent:
                          amountSent, // the amount that'll show in the receipt
                      accountName: fimatag,
                      reason: note.text,
                      timeSent: timePaid,
                    )));
      });
      Navigator.pop(context);
      pinHolder.clear();
    } else {
      // Invalid PIN, show error message
      pinHolder.clear();
      MotionToast(
        displaySideBar: false,
        primaryColor: Color(0xffff5353),
        backgroundType: BackgroundType.solid,
        secondaryColor: Color(0xffea4c4b),
        padding: EdgeInsets.only(left: 20, right: 20),
        width: 270,
        height: 70,
        description: Center(
          child: Text(
            "Invalid Pin, try again",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        position: MotionToastPosition.top,
        animationType: AnimationType.fromTop,
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

  void bottomsheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: MyColors.showbottomsheet,
        useSafeArea: true,
        enableDrag: true,
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        context: context,
        builder: (context) {
          return Stack(
            children: [
              SizedBox(
                height: 430,
                child: isLoading
                    ? Center(
                        child: SpinKitThreeBounce(
                        color: MyColors.lighterpriColor,
                        size: 50,
                      ))
                    : Padding(
                        padding: EdgeInsets.only(left: 15, top: 15, right: 15),
                        child: Column(
                          children: [
                            Text(
                              'PIN',
                              style: TextStyle(
                                  color: MyColors.textColorD,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19),
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
                                  padding: const EdgeInsets.only(top: 10),
                                  child: TextField(
                                    controller: pinHolder,
                                    textAlign: TextAlign.center,
                                    obscuringCharacter: '●',
                                    obscureText: true,
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: MyColors.primaryColor,
                                        fontWeight: FontWeight.bold),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildKey('1'),
                                    _buildKey('2'),
                                    _buildKey('3'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildKey('4'),
                                    _buildKey('5'),
                                    _buildKey('6'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildKey('7'),
                                    _buildKey('8'),
                                    _buildKey('9'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 44,
                                    ),
                                    Center(child: _buildKey('0')),
                                    IconButton(
                                        onPressed: () {
                                          _onCancelPressed();
                                        },
                                        icon: Image.asset(
                                            'assets/images/clear.png',
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
      minWidth: 70.0,
      highlightColor: MyColors.lighterpriColor,
      splashColor: Colors.transparent,
      textColor: MyColors.textColor2,
      onPressed: () => _onNumpadButtonPressed(value),
      shape: CircleBorder(),
      child: Text(
        value,
        style: TextStyle(fontSize: 29, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class InappPaymentsuccessful extends StatefulWidget {
  final String? accountName;
  final int? amountsent;
  final String reason;
  final String timeSent;
  InappPaymentsuccessful({
    super.key,
    required this.amountsent,
    required this.accountName,
    required this.reason,
    required this.timeSent,
  });

  @override
  State<InappPaymentsuccessful> createState() => _InappPaymentsuccessfulState();
}

class _InappPaymentsuccessfulState extends State<InappPaymentsuccessful> {
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
    accountName = widget.accountName!;
    reason = widget.reason;
    timeSent = widget.timeSent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lighterpriColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: SafeArea(
          child: Stack(
            children: [
              ClipPath(
                clipper: ZigZagClipper(),
                child: ClipRRect(
                  child: Container(
                    height: 400,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20, left: 5, right: 5),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  'assets/images/chec.png',
                                  color: MyColors.lighterpriColor,
                                  scale: 10,
                                ),
                                Text(
                                  'Money sent',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: MyColors.pinfield),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Text('Amount',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: MyColors.textColorD)),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(formatBalance(amountSent!),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28)),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Summary',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: MyColors.textColor2)),
                                ),
                                Container(
                                    width: double.infinity,
                                    height: 60,
                                    margin: EdgeInsets.only(top: 8),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(45, 127, 137, 132),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            text: 'Sent to ',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15),
                                            children: [
                                              TextSpan(
                                                text: '@$accountName',
                                                style: TextStyle(
                                                    color:
                                                        MyColors.primaryColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                              ),
                                              TextSpan(
                                                text: ' for\n',
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                              ),
                                              TextSpan(
                                                text: "'$reason'",
                                                style: TextStyle(
                                                    color:
                                                        MyColors.primaryColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                              ),
                                            ]),
                                      ),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  formatDateTime(timeSent),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 45,
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              MyColors.secondaryColor),
                                      elevation:
                                          MaterialStateProperty.all<double>(0),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              15), // Set border radius
                                        ),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.share),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          'Share',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
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
                            Color.fromARGB(53, 55, 255, 161)),
                        elevation: MaterialStateProperty.all<double>(0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15), // Set border radius
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Homenav()),
                            (route) => false);
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
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
