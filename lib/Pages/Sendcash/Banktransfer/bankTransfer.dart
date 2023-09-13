// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'dart:convert';
import 'package:fima/Pages/Sendcash/Banktransfer/enterAmt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

import '../../../tools/colors.dart';

class Banktransfer extends StatefulWidget {
  const Banktransfer({super.key});

  @override
  State<Banktransfer> createState() => _BanktransferState();
}

class _BanktransferState extends State<Banktransfer> {
  
  List<Map<String, dynamic>> banks = [];
  TextEditingController accountNum = TextEditingController();
  TextEditingController searchBank = TextEditingController();
  String? selectedBank;
  String? selectedBankCode;
  String? accountName;
  String? searchQuery;
  List<Map<String, dynamic>> filteredBanks = [];
  bool isLoading = false; // for fetching Bank
  bool Loading = false; //for verifing Bank
  bool verifiedAccount = false;
  

  //For activating the button if it's meet the field requirement
 bool isNextButtonEnabled() {
  if (selectedBank != null && accountNum.text.length == 10 && verifiedAccount) {
    return true;  // Button is enabled
  } else {
    return false; // Button is disabled
  }
}

late String accountNumber = accountNum.text;
 String counterPartyId = '';
  
  @override
  void initState() {
    super.initState();

    //Fetching the List of banks automatically 
     fetchBanksData().then((data) {
    setState(() {
      banks = data;
      filteredBanks = data;
      isLoading = false;
    });
  });

  isNextButtonEnabled();
  }


  @override
  Widget build(BuildContext context) {
   return Scaffold(
   backgroundColor: MyColors.secondaryColor,
  body: Padding(
    padding: const EdgeInsets.only(
      left: 20, right: 20, top: 15
    ),
    child: SafeArea(
      child: Stack(
         children: [
     Row(
     children: [
       Container(
        width: 30,
        height: 30,
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
        width: 20,
       ),
       Text('Transfer to Bank',
        style: TextStyle(
          color: MyColors.textColor2,
          fontSize: 18,
          fontWeight: FontWeight.w500
        ),)
          ],
        ),

         Column(
         children: [
           SizedBox(
              height: 50,
            ),

           GestureDetector(
         onTap: () {
         showModalBottomSheet(
          backgroundColor: MyColors.showbottomsheet,
         isScrollControlled: true,
        useSafeArea: true,
        shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
         topRight: Radius.circular(30) )
       ),
            context: context,
           builder: (context) {
            return selectBank();
           });
         },
         child: Container(
           width: double.infinity,
           height: 55,
           margin: EdgeInsets.only(top:20),
           decoration: BoxDecoration(
           color: MyColors.txtfieldcolor,
         borderRadius: BorderRadius.circular(20)
           ),
           child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Padding(
         padding: const EdgeInsets.only(left: 15),
         child: Text(
           selectedBank ?? 'Select bank',
           style: TextStyle(
           fontSize: 16,
           color: MyColors.textColor3,
           fontWeight: FontWeight.w400
           ),
         ),
           ),
      Container(
        margin: EdgeInsets.only(right: 10),
        child: Icon(
          Icons.keyboard_arrow_down_sharp,
          color: MyColors.textColorD,
        ),
        )
         ],
           ),
         ),
           ),
       
       Container(
         width: double.infinity,
         height: 55,
         margin: EdgeInsets.only(top:20),
         padding: EdgeInsets.only(top: 8, left: 15),
         decoration: BoxDecoration(
           color: MyColors.txtfieldcolor,
           borderRadius: BorderRadius.circular(20)
         ),
         child: TextFormField(
          controller: accountNum,
          keyboardType: TextInputType.phone,
          cursorColor:  MyColors.lighterpriColor ,
          inputFormatters: [
             FilteringTextInputFormatter.deny(RegExp('[^0-9]')),
          ],
           style: TextStyle(
           fontSize: 16,
           fontWeight: FontWeight.w400,
           color: MyColors.textColor3
           ),
           textAlign: TextAlign.justify,
          decoration: InputDecoration(
           border: InputBorder.none,
           hintText: 'Account number',
           hintStyle: TextStyle(
           fontSize: 16,
           color: Color(0xff838484),
           fontWeight: FontWeight.w400
          ),
           suffixIcon: IconButton(
            onPressed: () {
             pasteAccountNumber();
            },
            icon: Image.asset(
              'assets/images/past.png',
                scale: 28,
                color: MyColors.lighterpriColor,
             ),
           )
          ),
        onChanged: (value) {
         setState(() {
           accountName = null;
         });
         verifyAccount();
        },
         )
           ),
        
        if (accountName != null) ...[
          const SizedBox(height: 10),
          Container(
            child: Row(
            children: [
             Icon(Icons.verified_rounded,
             size: 18,
             color:  MyColors.lighterpriColor),
             SizedBox(
              width: 5,
             ),
             Text('$accountName'.toUpperCase(),
             style: TextStyle(
              color:  MyColors.lighterpriColor,
              fontSize: 14,
              fontWeight: FontWeight.w500
             ),
             )
            ],
            ),
          )
          ],
      SizedBox(
        height: 20,
      ),
        if(Loading)
        Center(
         child: SpinKitThreeBounce(
        color:  MyColors.lighterpriColor,
        size: 50,
        )
          ),
      
      Container(
       margin: EdgeInsets.only(top: 150),
      alignment: Alignment.centerLeft,
        child: Text('Recent',
        style: TextStyle(
         color: MyColors.textColor2,
         fontSize: 17,
         fontWeight: FontWeight.w400
        ),),
      ),
         ],
           ),
      
         Column(
         mainAxisAlignment: MainAxisAlignment.end,
         children: [
          Container(
          width: double.infinity,
          height: 50,
          margin: EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
            style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              isNextButtonEnabled()? MyColors.lighterpriColor 
              : MyColors.disableBtn,
              ),
             elevation:  MaterialStateProperty.all<double>(0),
             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25), // Set border radius
              ),
            ),
            ),
           onPressed: isNextButtonEnabled() ? () {
            if(verifiedAccount){
            counterParty().then((_){
              Navigator.push(context,
               MaterialPageRoute(builder: (context) => EnterAmt(
                counterId: counterPartyId,
                accountName: accountName,
                bankName: selectedBank,
                acctNumber: accountNumber
               )));
            });   
            }
           } : null,
           child: Text( 'Next',
           style: TextStyle(
         color:  isNextButtonEnabled() ?
               MyColors.textColor1
                : MyColors.textColorD,
           fontSize: 17
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

void pasteAccountNumber() async {
    ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null) {
    final pastedText = clipboardData.text?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
       setState(() {
        accountNum.text = pastedText;
      });
    if (pastedText.length == 10) {
      verifyAccount();
    }
    }
  }

//Calling the fetch bank API to get all banks
Future<List<Map<String, dynamic>>> fetchBanksData() async {
   setState(() {
     isLoading = true; //show loading if fetching banks
    });

  final url = Uri.parse('https://api.getanchor.co/api/v1/banks'); //fetch bank url
  final headers = {
    'accept': 'application/json',
    'content-type': 'application/json',
    //My request API key
    'x-anchor-key': 'f9Ehq.ef607b1d168cff00c7794f7d96fdaa1f62961e25c1f23fb92711fc054e608494f28b5498c5dbdba1b0c01b563c815994a467',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
   final data = json.decode(response.body);
   final banksData = data['data'] as List<dynamic>;
   final List<Map<String, dynamic>> fetchedBanks = [];
   for (var bank in banksData) {
      final bankName = bank['attributes']['name']; // For getting the bank name
      final bankCode = bank['attributes']['nipCode']; // // For getting the bankCode
      fetchedBanks.add({'name': bankName, 'nipCode': bankCode});
    }

  fetchedBanks.sort((a, b) => a['name'].compareTo(b['name']));

    setState(() {
     isLoading = false; // Don't show loading after fetching banks
    });
  return fetchedBanks;
  } else {
     setState(() {
     isLoading = false;
    });
      throw Exception('Failed to fetch banks');
  }
}

//Verify Users Account Infomr
Future<void> verifyAccount() async {
 if(accountNum.text.length == 10 && selectedBankCode != null){
  setState(() {
   Loading = true;
  });

  final url = Uri.parse('https://api.sandbox.getanchor.co/api/v1/payments/verify-account/$selectedBankCode/$accountNumber');
  final headers = {
   'x-anchor-key': 'f9Ehq.ef607b1d168cff00c7794f7d96fdaa1f62961e25c1f23fb92711fc054e608494f28b5498c5dbdba1b0c01b563c815994a467',
  };
 
  final response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
  final data = json.decode(response.body);
  final maindata = data['data']['attributes'];
  final useraccountName = maindata['accountName'];
    setState(() {
      accountName = useraccountName;
      Loading = false;
      verifiedAccount = true; // Set verification status to true
      });
  } else{
    if(response.statusCode == 404){
     MotionToast(
          displaySideBar: false,
          primaryColor:  Color(0xffff5353),
          backgroundType: BackgroundType.solid,
          width: 320,
          height: 70,
          description: Center(
            child: Text(
            "Incorrect account details, Please try again",
             style: TextStyle(
             fontWeight: FontWeight.w400,
              fontSize: 15.5,
              color: Colors.white,
            ),),
          ),
          position: MotionToastPosition.top,
          animationType:  AnimationType.fromTop,
          animationDuration: Duration(milliseconds: 1),
          toastDuration: Duration(seconds: 3),
        ).show(context);

      print(response.body);
       setState(() {
       Loading = false;
     });
    }
  }

 }else{
  setState(() {
    accountName = null;
    Loading = false;
    verifiedAccount = false;
  });
 }
}

//Automatically verify account number
void verifyautomatically(){
  verifyAccount();
}

//CounterParty for bank tranfers
Future<void> counterParty() async {
  final url = Uri.parse('https://api.sandbox.getanchor.co/api/v1/counterparties');

  final header = {
    'accept': 'application/json',
    'content-type': 'application/json',
    // My request API key
    'x-anchor-key': 'f9Ehq.ef607b1d168cff00c7794f7d96fdaa1f62961e25c1f23fb92711fc054e608494f28b5498c5dbdba1b0c01b563c815994a467',
  };

  final data = jsonEncode({
    "data": {
      "type": "CounterParty",
      "attributes": {
        "accountName": accountName,
        "accountNumber": accountNumber,
        "bankCode": selectedBankCode,
      }
    }
  });

  final response = await http.post(url, headers: header, body: data);

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final counterId = responseData['data']['id'];
    print('Counter ID: $counterId');
    print(response.body);
  } else {
   // Handle the error case
   print(response.body);
   final responseData = json.decode(response.body);
    final counterId = responseData['data']['id'];
    setState(() {
      counterPartyId = counterId;
    });
  }
}


  void onBankSelected(String bankName, String bankCode) {
    setState(() {
      selectedBank = bankName;
      selectedBankCode = bankCode;
    });
  }

  void clearSearch() {
    setState(() {
      searchBank.clear();
      banks.clear();
    });
    fetchBanksData().then((sortedBanks) {
      setState(() {
        banks = sortedBanks;
        filteredBanks = sortedBanks;
      });
    });
  }



Widget selectBank() {
  return SizedBox(
    height: 600,
    child: isLoading ? Center(
      child:  SpinKitThreeBounce(
      color:  MyColors.lighterpriColor,
      size: 60,
      ) )
      :Column(
        children: [
    ListTile(
       trailing:  Padding(
         padding: EdgeInsets.only(right: 10, top: 10),
         child: IconButton(
        icon: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(8),
       color: Color(0xFFEFEFEF)
            ),
       child: Icon(Icons.close,
       color: Color.fromARGB(255, 41, 53, 87)
          ),
        ),
       onPressed: () {
       Navigator.of(context).pop(); // Close the bottom sheet
               },
         ),
       ),
         ),
      Text('Select Bank',
         style: TextStyle(
         fontSize: 22,
         color: MyColors.textColor1,
        fontWeight: FontWeight.w500
         ),
      ),
          Container(
            width: double.infinity,
            height: 45,
            margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
           padding: EdgeInsets.only(top: 8),
           decoration: BoxDecoration(
          color: MyColors.txtfieldcolor,
         borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: searchBank,
              cursorColor:  MyColors.lighterpriColor,
              keyboardType: TextInputType.text,
               style: TextStyle(
               fontSize: 16,
               color: MyColors.textColor2
               ),  
               textAlign: TextAlign.justify,
              decoration: InputDecoration(
                border: InputBorder.none,
                 hintText: 'Search bank',
                 hintStyle: TextStyle(
                 fontSize: 16,
                 color:  MyColors.textColorD,
                 fontWeight: FontWeight.w400,
                   ),
               prefixIcon: Image.asset(
             'assets/images/mag.png',
             scale: 26,
             color:  MyColors.lighterpriColor,
           ),
              ),
            onChanged: (value){
              setState(() {
              searchQuery = value;
              filteredBanks = banks
              .where((bank) =>
               bank['name']
               .toLowerCase()
               .contains(value.toLowerCase()))
              .toList();
              });
            },
            ),
          ),
          Expanded(
            child: ListView(
              children: filteredBanks.map((bank){
                return ListTile(
                  title: Text(bank['name'],
                  style: TextStyle(
                    color: MyColors.textColor3,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w400
                  ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedBank = bank['name'];
                      selectedBankCode = bank['nipCode'];
                    });
                    Navigator.pop(context); // Close the modal
                  },
                  selected: selectedBankCode == bank['nipCode'],
                );
              }).toList()
            ),
          ),
        ],
    ),
  );
}
}
