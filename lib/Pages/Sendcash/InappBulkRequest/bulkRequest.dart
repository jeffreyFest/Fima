// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../../../tools/colors.dart';

class Bulkrequest extends StatefulWidget {
  final List<Map<String, dynamic>> selectedContacts;
  const Bulkrequest({super.key, required this.selectedContacts});

  @override
  State<Bulkrequest> createState() => _BulkrequestState();
}

class _BulkrequestState extends State<Bulkrequest> {
  TextEditingController totalamount = TextEditingController();
  List<TextEditingController> amountControllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize amountControllers with the initial values (e.g., 0 for all users)
    totalamount
        .addListener(calculateSplitAmount); // Add listener to totalamount
    amountControllers = List.generate(
        widget.selectedContacts.length, (_) => TextEditingController());
  }

  @override
  void dispose() {
    // Dispose the amountControllers when the screen is disposed
    totalamount.removeListener(
        calculateSplitAmount); // Remove the listener to avoid memory leak
    amountControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void calculateSplitAmount() {
    // Get the total amount entered by the user
    double totalAmount = double.tryParse(totalamount.text) ?? 0;
    int numSelectedUsers = widget.selectedContacts.length;
    if (numSelectedUsers > 0) {
      // Calculate the split amount for each user
      double splitAmount = totalAmount / numSelectedUsers;

      // Update the subamountController for each user
      for (int i = 0; i < amountControllers.length; i++) {
        amountControllers[i].text = splitAmount.toStringAsFixed(2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: MyColors.secondaryColor,
        elevation: 0,
        leading: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: MyColors.textColorD,
              size: 19,
            )),
        title: Text(
          'Request amount',
          style: TextStyle(
              color: MyColors.textColorD,
              fontSize: 18,
              fontWeight: FontWeight.w400),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Total amount',
                style: TextStyle(
                    color: MyColors.textColor2,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.only(top: 10, bottom: 30),
              decoration: BoxDecoration(
                  color: MyColors.txtfieldcolor,
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.only(left: 23),
              child: TextFormField(
                controller: totalamount,
                cursorColor: MyColors.primaryColor,
                keyboardType: TextInputType.name,
                style: TextStyle(
                    fontSize: 16.5,
                    color: MyColors.textColor2,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'e.g 1,000',
                  hintStyle: TextStyle(color: Color.fromARGB(255, 78, 80, 80)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Users',
                style: TextStyle(
                    color: MyColors.textColorD,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: widget.selectedContacts.length,
                    itemBuilder: (context, index) {
                      final user = widget.selectedContacts[index];
                      final String fullName =
                          "${user['first_name']} ${user['last_name']}";
                      TextEditingController subamountController =
                          amountControllers[index];

                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              fullName,
                              style: TextStyle(
                                color: Color.fromARGB(255, 169, 170, 170),
                                fontWeight: FontWeight.w400,
                                wordSpacing: 0,
                              ),
                            ),
                            trailing: Container(
                              width: 80,
                              height: 40,
                              padding: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  color: MyColors.txtfieldcolor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                controller: subamountController,
                                keyboardType: TextInputType.number,
                                cursorColor: MyColors.primaryColor,
                                style: TextStyle(
                                    fontSize: 17,
                                    color: MyColors.textColor2,
                                    fontWeight: FontWeight.w400),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '200',
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 78, 80, 80)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    })),
            Container(
              width: 130,
              height: 55,
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  color: MyColors.txtfieldcolor,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: TextFormField(
                  //controller: subamountController,
                  keyboardType: TextInputType.text,
                  cursorColor: MyColors.primaryColor,
                  style: TextStyle(
                      fontSize: 17,
                      color: MyColors.textColor2,
                      fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'What\'s it for?',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 78, 80, 80)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      MyColors.lighterpriColor),
                  elevation: MaterialStateProperty.all<double>(0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18), // Set border radius
                    ),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Request',
                  style: TextStyle(color: MyColors.textColor1, fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
