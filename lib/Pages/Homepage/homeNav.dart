// ignore_for_file: prefer_const_constructors

import 'package:fima/Pages/Homepage/MainHome.dart';
import 'package:fima/Pages/Sendcash/payoptions.dart';
import 'package:flutter/material.dart';

import '../../tools/colors.dart';
import '../UserProfile/profile.dart';

class Homenav extends StatefulWidget {
  const Homenav({
    Key? key,
  }) : super(key: key);
  @override
  State<Homenav> createState() => _HomenavState();
}

class _HomenavState extends State<Homenav> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Mainpage(),
    Payoption(),
    Text('Tracking & reminder'),
    Userprofile(),
  ];

  List<BottomNavigationBarItem> bottomNavBarItems = [
    BottomNavigationBarItem(
        icon: Image.asset(
          'assets/images/hom.png',
          scale: 22,
          color: MyColors.textColorD,
        ),
        activeIcon: Image.asset(
          'assets/images/hom.png',
          color: MyColors.primaryColor,
          scale: 22,
        ),
        label: ''),
    BottomNavigationBarItem(
        icon: Image.asset('assets/images/naira.png',
            color: MyColors.textColorD, scale: 20),
        activeIcon: Image.asset(
          'assets/images/naira.png',
          color: MyColors.primaryColor,
          scale: 20,
        ),
        label: ''),
    BottomNavigationBarItem(
        icon: Image.asset('assets/images/pie-chart.png',
            color: MyColors.textColorD, scale: 25),
        activeIcon: Image.asset(
          'assets/images/pie-chart.png',
          color: MyColors.primaryColor,
          scale: 25,
        ),
        label: ''),
    BottomNavigationBarItem(
        icon: Image.asset('assets/images/user.png',
            color: MyColors.textColorD, scale: 25),
        activeIcon: Image.asset(
          'assets/images/user.png',
          color: MyColors.primaryColor,
          scale: 25,
        ),
        label: ''),
  ];

  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        height: 62,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BottomNavigationBar(
            selectedItemColor: MyColors.primaryColor,
            unselectedItemColor: MyColors.textColor2,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            iconSize: 26,
            elevation: 0,
            backgroundColor: MyColors.greyColor,
            items: bottomNavBarItems,
            currentIndex: _selectedIndex,
            onTap: _onNavBarItemTapped,
          ),
        ),
      ),
    );
  }
}
