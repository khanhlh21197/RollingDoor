import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rollingdoor/Widget/bezierContainer.dart';
import 'package:rollingdoor/helper/constants.dart';
import 'package:rollingdoor/helper/loader.dart';
import 'package:rollingdoor/helper/shared_prefs_helper.dart';
import 'package:rollingdoor/main/home_screen.dart';
import 'package:rollingdoor/model/user.dart';
import 'package:rollingdoor/navigator.dart';
import 'package:rollingdoor/response/LoginPostResponse.dart';
import 'package:rollingdoor/response/LoginResponse.dart';
import 'package:rollingdoor/singup/signup_http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../helper/constants.dart' as Constants;
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  final String title;
  final User registerUser;

  const LoginPage({
    Key key,
    this.title,
    this.registerUser,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SharedPrefsHelper sharedPrefsHelper;
  bool loading = false;
  bool _switchValue = false;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  String iduser;
  var status;
  String playerid = '';
  bool switchValue = false;

  var client = http.Client();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initOneSignal(Constants.one_signal_app_id);
    sharedPrefsHelper = SharedPrefsHelper();
    getSharedPrefs();
  }

  void initOneSignal(oneSignalAppId) async {
    var settings = {
      OSiOSSettings.autoPrompt: true,
      OSiOSSettings.inAppLaunchUrl: true
    };
    OneSignal.shared.init(
      one_signal_app_id,
      iOSSettings: settings,
    );

    status = await OneSignal.shared.getPermissionSubscriptionState();

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
// will be called whenever a notification is received
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      print('Received: ' + notification?.payload?.body ?? '');
    });
// will be called whenever a notification is opened/button pressed.
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('Opened: ' + result.notification?.payload?.body ?? '');
    });
  }

  Future<void> post() async {
    var client = http.Client();
    try {
      var uriResponse = await client.post(
          Uri.parse('http://103.146.23.146:8082/api/Accounts/login'),
          headers: <String, String>{
            'content-type': 'application/json; charset=utf-8',
            // 'Authorization': 'Bearer ${Constants.token}',
          },
          body: loginPostResponseToJson(LoginPostResponse(
              phoneNumber: _emailController.text,
              password: _passwordController.text,
              isRemember: true,
          )),
      );
      print('Response statuscode: ${uriResponse.statusCode}');
      print('Response body: ${uriResponse.body}');

      //khanhlh
      //parse response body to object LoginResponse
      var loginResponse = loginResponseFromJson(uriResponse.body);
      print('login response $loginResponse');
      var token = loginResponse.data.token;

      //save token to sharedPreferences
      sharedPrefsHelper.addStringToSF("token", token);
      print('_LoginPageState.token: $token');

      if (uriResponse.statusCode == 200) {
        print('Login success');
        sharedPrefsHelper.addStringToSF('email', _emailController.text);
        sharedPrefsHelper.addStringToSF('password', _passwordController.text);

        navigatorPushAndRemoveUntil(
          context,
          HomeScreen(),
        );
      } else {
        this._showToast(context);
      }
    } finally {
      client.close();
    }
  }

  Future<void> httpPost() async {
    var url = Uri.parse('http://103.146.23.146:8082/api/Accounts/login');
    var response = await http.post(
      url,
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print(await http.read('http://103.146.23.146:8082/api/Accounts/login'));
  }

  Future<void> get() async {
    var client = http.Client();
    try {
      var uriResponseGet = await client.get(
        Uri.parse('http://103.146.23.146:8082/api/Accounts/register'),
      );
      print('_SignUpPageState.post: $uriResponseGet');
    } finally {
      client.close();
    }
  }

  Future<void> getSharedPrefs() async {
    _emailController.text = await sharedPrefsHelper.getStringValuesSF('email');
    _passwordController.text =
        await sharedPrefsHelper.getStringValuesSF('password');
    _switchValue = await sharedPrefsHelper.getBoolValuesSF('switchValue');
    // if (_emailController.text.isNotEmpty &&
    //     _passwordController.text.isNotEmpty) {
    //   await post();
    // }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login(String message) async {
    hideLoadingDialog();
    print('_LoginPageState.login $message');
    Map responseMap = jsonDecode(message);

    print('_LoginPageState.login iduser: $iduser');

    if (responseMap['result'] == 'true') {
      setState(() {
        loading = false;
      });
      print('Login success');
      if (_switchValue != null) {
        if (_switchValue) {
          await sharedPrefsHelper.addStringToSF('email', _emailController.text);
          await sharedPrefsHelper.addStringToSF(
              'password', _passwordController.text);
          await sharedPrefsHelper.addBoolToSF('switchValue', _switchValue);
        } else {
          await sharedPrefsHelper.removeValues();
        }
      }
      await sharedPrefsHelper.addStringToSF('email', _emailController.text);
      await sharedPrefsHelper.addStringToSF(
          'password', _passwordController.text);
      await sharedPrefsHelper.addBoolToSF('switchValue', _switchValue);
      await sharedPrefsHelper.addBoolToSF('login', true);
      navigatorPushAndRemoveUntil(
        context,
        HomeScreen(
        ),
      );
    } else {
      this._showToast(context);
    }
  }

  void _showToast(BuildContext context) {
    Dialogs.showAlertDialog(
        context, 'Đăng nhập thất bại, vui lòng thử lại sau!');
  }

  Widget _entryField(String title, TextEditingController _controller,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              controller: _controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  void showLoadingDialog() {
    Dialogs.showLoadingDialog(context, _keyLoader);
  }

  void hideLoadingDialog() {
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        post();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightBlueAccent, Colors.blueAccent])),
        child: Text(
          'Đăng nhập',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/techno_me.png'),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'TechNo M&E',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpHttp()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Chưa có tài khoản ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Đăng ký',
              style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: Container(
        height: 100,
        width: 100,
        child: Image.asset(
          "assets/images/garage.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Tên đăng nhập", _emailController),
        _entryField("Mật khẩu", _passwordController, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: height,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer(),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _header(),
                      SizedBox(height: 50),
                      _emailPasswordWidget(),
                      _submitButton(),
                      _divider(),
                      _facebookButton(),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ),
              // Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        ),
      ),
    );
  }
}
