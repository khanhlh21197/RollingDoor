// import 'package:flutter/material.dart';
// import 'package:health_care/login/login_page.dart';
// import 'package:health_care/login/welcome_page.dart';
// import 'package:health_care/main/department_list_screen.dart';
// import 'package:health_care/main/department_page.dart';
// import 'package:health_care/main/home_screen.dart';
// import 'package:health_care/splash_screen.dart';
// import 'package:health_care/test_screen.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Airconditional',
//       home: SafeArea(
//         // child: SplashScreen(),
//         // child: HomeScreen(),
//         child: LoginPage(),
//         // child: TestScreen(),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get_mac/get_mac.dart';

import 'package:rollingdoor/helper/constants.dart' as Constants;
import 'package:rollingdoor/login/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // print('_MyAppState.initState MAC: $_platformVersion');
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await GetMac.macAddress;
    } on PlatformException {
      platformVersion = 'Failed to get Device MAC Address.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      Constants.mac = _platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        // title:Text('Điều khiển cửa cuốn'),
        // ),
        body: Center(
          child: LoginPage(),
          // child: HomeScreen(),
        ),
      ),
    );
  }
}