import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:usim_attendance_app/PresentationLayer/Screen/User/MainPage/MainPage.dart';

import '../About/AboutScreen.dart';







class NavBarStudent extends StatefulWidget {
  const NavBarStudent({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NavBarStudentState createState() => _NavBarStudentState();
}

class _NavBarStudentState extends State<NavBarStudent> {
  final PersistentTabController _controller =
  PersistentTabController(initialIndex: 0);

//Screens for each nav items.
  List<Widget> _navScreens() {
    return [

      const MainPage(),
      const AboutScreen()

    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(LineIcons.home),
        title: ("Home"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.black,
        activeColorSecondary: Colors.black,
      ),
      // PersistentBottomNavBarItem(
      //   icon: const Icon(LineIcons.list),
      //   title: ("Equipment List"),
      //   activeColorPrimary: Colors.white,
      //   inactiveColorPrimary: Colors.black,
      //   activeColorSecondary: Colors.black,
      // ),
      PersistentBottomNavBarItem(
        icon: const Icon(LineIcons.cogs),
        title: ("About"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.black,
        activeColorSecondary: Colors.black,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Center(
            child: PersistentTabView(
              context,
              screens: _navScreens(),
              controller: _controller,
              items: _navBarsItems(),
              confineInSafeArea: true,
              backgroundColor:  Colors.white,
              handleAndroidBackButtonPress: true,
              resizeToAvoidBottomInset: true,
              hideNavigationBarWhenKeyboardShows: true,
              stateManagement: true,
              decoration: const NavBarDecoration(
                //borderRadius: BorderRadius.circular(10.0),
              ),
              popAllScreensOnTapOfSelectedTab: true,
              navBarStyle: NavBarStyle.style13,
            )),
        onWillPop: () async => true);
  }
}
