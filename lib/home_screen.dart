import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'provider/navigation.dart';
import 'provider/theme_provider.dart';
import 'widget/dialog.dart';
import 'package:provider/provider.dart';
import 'networkutil/get_method.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  void handleAppLifecycleState() async {
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      log("$msg", name: "lifecycle");
      if ("$msg" == "${AppLifecycleState.resumed}") {}
      return null;
    });
  }

  @override
  void initState() {
    SchedulerBinding.instance.endOfFrame.then((value) async {
      fetchProfile(context);
      handleAppLifecycleState();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, Navigation>(
        builder: (context, theme, nav, child) {
      return WillPopScope(
        onWillPop: () async {
          dialogCloseAplikasi(context);
          return false;
        },
        child: (() {
          List<BottomNavigationBarItem> listBottomNav = [];
          final List<Widget> viewContainer = [];
          // listBottomNav.add(BottomNavigationBarItem(
          //   icon: const Icon(
          //     JeteIcon.home,
          //   ),
          //   label: context.strLocal.dashboard,
          // ));
          // viewContainer.add(const MenuDashboard());
          // listBottomNav.add(const BottomNavigationBarItem(
          //   icon: Icon(
          //     JeteIcon.record,
          //   ),
          //   label: "Record",
          // ));
          // viewContainer.add(const MenuRecord());
          // // if ("${loc.deviceInfo['mSupportAppSport']}" == "1") {
          // //   listBottomNav.add(BottomNavigationBarItem(
          // //     icon: const Icon(
          // //       FontAwesomeIcons.personRunning,
          // //     ),
          // //     label: context.strLocal.sport,
          // //   ));
          // //   viewContainer.add(const MenuSport());
          // // }
          // listBottomNav.add(BottomNavigationBarItem(
          //   icon: const Icon(
          //     FontAwesomeIcons.calendar,
          //   ),
          //   label: context.strLocal.calender,
          // ));
          // viewContainer.add(const MenuCalender());
          // listBottomNav.add(BottomNavigationBarItem(
          //   icon: const Icon(
          //     JeteIcon.device,
          //   ),
          //   label: context.strLocal.device,
          // ));
          // viewContainer.add(const MenuDevice());
          // listBottomNav.add(BottomNavigationBarItem(
          //   icon: const Icon(
          //     FontAwesomeIcons.a,
          //     color: Colors.transparent,
          //   ),
          //   label: context.strLocal.account,
          // ));
          // viewContainer.add(const MenuAccount());
          return Scaffold(
            backgroundColor: theme.colorBackground,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: theme.colorBackground,
              currentIndex: nav.currentNavigation,
              selectedItemColor: theme.colorPrimary,
              unselectedItemColor: theme.colorGrey,
              type: BottomNavigationBarType.fixed,
              onTap: (index) async {
                nav.setNavigation(val: index);
              },
              items: listBottomNav,
            ),
            body: viewContainer[nav.currentNavigation],
          );
        })(),
      );
    });
  }
}
