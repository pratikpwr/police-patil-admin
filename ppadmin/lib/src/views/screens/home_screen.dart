import 'package:flutter/material.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/views/side_navigation/side_nav_bar.dart';
import 'package:ppadmin/src/views/side_navigation/side_nav_bar_item.dart';

import '../views.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  List<Widget> views =  [
    ArmsScreen(),
    CollectionScreen(),
    MovementScreen(),
    WatchScreen(),
    SocialPlaceScreen(),
    IllegalScreen(),
    CrimesScreen(),
    FiresScreen(),
    DeathScreen(),
    MissingScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SideNavBar(
                selectedIndex: selectedIndex,
                items: [
                  SideNavBarItem(
                      image: ImageConstants.IMG_ARMS, label: ARMS_COLLECTIONS),
                  SideNavBarItem(
                      image: ImageConstants.IMG_COLLECTION,
                      label: COLLECTION_REGISTER),
                  SideNavBarItem(
                      image: ImageConstants.IMG_MOVEMENT,
                      label: MOVEMENT_REGISTER),
                  SideNavBarItem(
                      image: ImageConstants.IMG_WATCH, label: WATCH_REGISTER),
                  SideNavBarItem(
                      image: ImageConstants.IMG_PLACES, label: SOCIAL_PLACES),
                  SideNavBarItem(
                      image: ImageConstants.IMG_ILLEGAL, label: ILLEGAL_WORKS),
                  SideNavBarItem(
                      image: ImageConstants.IMG_CRIMES, label: CRIMES),
                  SideNavBarItem(image: ImageConstants.IMG_FIRE, label: BURNS),
                  SideNavBarItem(
                      image: ImageConstants.IMG_CRIMES_SUB, label: DEATHS),
                  SideNavBarItem(
                      image: ImageConstants.IMG_MISSING, label: MISSING),
                ],
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                }),
            Expanded(child: views.elementAt(selectedIndex))
          ],
        ),
      ),
    );
  }
}
