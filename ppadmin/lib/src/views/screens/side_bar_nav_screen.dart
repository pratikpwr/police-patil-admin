import 'package:flutter/material.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/views/screens/alert_screen.dart';
import 'package:ppadmin/src/views/screens/kayade_screen.dart';
import 'package:ppadmin/src/views/screens/news_screen.dart';
import 'package:ppadmin/src/views/screens/ps_list_screen.dart';
import 'package:ppadmin/src/views/side_navigation/side_nav_bar.dart';
import 'package:ppadmin/src/views/side_navigation/side_nav_bar_item.dart';
import 'package:shared/shared.dart';

import '../views.dart';

class SideBarNavScreen extends StatefulWidget {
  const SideBarNavScreen({Key? key}) : super(key: key);

  @override
  _SideBarNavScreenState createState() => _SideBarNavScreenState();
}

class _SideBarNavScreenState extends State<SideBarNavScreen> {
  int selectedIndex = 0;
  String? userRole;
  bool _isAdmin = false;

  @override
  void initState() {
    getUserRole();
    super.initState();
  }

  getUserRole() async {
    final sharedPrefs = await prefs;
    userRole = sharedPrefs.getString("role");
    _isAdmin = userRole == "admin";
  }

  @override
  Widget build(BuildContext context) {
    List<SideNavBarItem> adminItems = [
      SideNavBarItem(image: ImageConstants.IMG_PLACEHOLDER, label: HOME),
      SideNavBarItem(image: ImageConstants.IMG_ARMS, label: ARMS_COLLECTIONS),
      SideNavBarItem(
          image: ImageConstants.IMG_COLLECTION, label: COLLECTION_REGISTER),
      SideNavBarItem(
          image: ImageConstants.IMG_MOVEMENT, label: MOVEMENT_REGISTER),
      SideNavBarItem(image: ImageConstants.IMG_WATCH, label: WATCH_REGISTER),
      SideNavBarItem(image: ImageConstants.IMG_PLACES, label: SOCIAL_PLACES),
      SideNavBarItem(image: ImageConstants.IMG_ILLEGAL, label: ILLEGAL_WORKS),
      SideNavBarItem(image: ImageConstants.IMG_CRIMES, label: CRIMES),
      SideNavBarItem(image: ImageConstants.IMG_FIRE, label: BURNS),
      SideNavBarItem(image: ImageConstants.IMG_CRIMES_SUB, label: DEATHS),
      SideNavBarItem(image: ImageConstants.IMG_MISSING, label: MISSING),
      SideNavBarItem(image: ImageConstants.IMG_ALERTS, label: NOTICE),
      SideNavBarItem(image: ImageConstants.IMG_NEWS, label: IMP_NEWS),
      SideNavBarItem(image: ImageConstants.IMG_HAMMER, label: LAWS),
      SideNavBarItem(image: ImageConstants.IMG_USERS, label: POLICE_PATIL_APP),
      if (_isAdmin)
        SideNavBarItem(
            image: ImageConstants.IMG_PROFILE, label: POLICE_STATION),
    ];
    List<Widget> adminViews = [
      HomeScreen(),
      ArmsScreen(),
      CollectionScreen(),
      MovementScreen(),
      WatchScreen(),
      SocialPlaceScreen(),
      IllegalScreen(),
      CrimesScreen(),
      FiresScreen(),
      DeathScreen(),
      MissingScreen(),
      AlertScreen(),
      ImpNewsScreen(),
      KayadeScreen(),
      UsersScreen(),
      if (_isAdmin) PoliceStationScreen()
    ];

    return Scaffold(
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SideNavBar(
                selectedIndex: selectedIndex,
                items: adminItems,
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                }),
            Expanded(child: adminViews.elementAt(selectedIndex))
          ],
        ),
      ),
    );
  }
}
