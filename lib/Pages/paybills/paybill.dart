// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:fima/Pages/paybills/buyairtime.dart';
import 'package:fima/Pages/paybills/buydata.dart';
import 'package:flutter/material.dart';

class Paybill extends StatefulWidget {
  const Paybill({Key? key}) : super(key: key);

  @override
  State<Paybill> createState() => _PaybillState();
}

class _PaybillState extends State<Paybill>
    with SingleTickerProviderStateMixin {
  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
   elevation: 0,
   backgroundColor: Colors.white,
   leading:ButtonTheme(
    minWidth: 20,
    height: 20,
   child: MaterialButton(
 shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50)
 ),
   onPressed: () => Navigator.of(context).pop(),
   splashColor: Colors.transparent,
   child: Icon(
 Icons.arrow_back_ios_outlined,
   color: Color(0xff0145fe),
   )
   ),
  ),
  title: Text('Pay bills',
   style: TextStyle(
 color: Colors.black
  )),
 ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 20, right: 20, top: 15
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 40,
                  child: TabBar(
                    indicator: BoxDecoration(
                     color: Color.fromARGB(210, 1, 68, 254),
                     borderRadius: BorderRadius.circular(20),
                    ),
                  indicatorSize: TabBarIndicatorSize.tab,
                   unselectedLabelStyle: TextStyle(color: Colors.grey,
                  fontWeight: FontWeight.w500
                      ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                   isScrollable: true,
                  tabs: [
                      Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone),
                          SizedBox(width: 5),
                          Text('Airtime'),
                        ],
                      ),
                      ),
                      Tab(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mobile_friendly),
                        SizedBox(width: 5),
                        Text('Data'),
                      ],
                      ),
                      ),
                      Tab(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.electrical_services_rounded),
                        SizedBox(width: 5),
                        Text('Electricity'),
                      ],
                      ),
                      ),
                      Tab(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.tv),
                        SizedBox(width: 5),
                        Text('Cable Tv'),
                      ],
                      ),
                      ),
                      ],
                    ),
                ),
            Expanded(
             child: TabBarView(
              children: [
              Buyairtime(),
              BuyData(),
              Text('Electricity'),
              Text('Cable Tv')
             ]),
            )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
