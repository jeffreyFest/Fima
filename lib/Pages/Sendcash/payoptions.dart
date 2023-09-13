// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:fima/Pages/Sendcash/requestOp.dart';
import 'package:fima/Pages/Sendcash/sendOp.dart';
import 'package:fima/tools/colors.dart';
import 'package:flutter/material.dart';

class Payoption extends StatefulWidget {
  const Payoption({super.key});

  @override
  State<Payoption> createState() => _PayoptionState();
}

class _PayoptionState extends State<Payoption> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: MyColors.secondaryColor,
            appBar: AppBar(
              backgroundColor: MyColors.secondaryColor,
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: Container(
                  height: 40,
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: TabBar(
                      isScrollable: false,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 1,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: MyColors.greyColor, // Indicator color
                      ),
                      labelPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      indicatorPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      automaticIndicatorColorAdjustment: false,
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          return states.contains(MaterialState.focused)
                              ? null
                              : Colors.transparent;
                        },
                      ),
                      tabs: [
                        Text('Send'),
                        Text('Bills'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: [SendOption(), PaybillsOption()],
            )));
  }
}
