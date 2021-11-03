import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rollingdoor/addWidget/add_page.dart';
import 'package:rollingdoor/helper/bottom_navigation_bar.dart';
import 'package:rollingdoor/helper/constants.dart';
import 'package:rollingdoor/helper/constants.dart' as Constants;
import 'package:rollingdoor/helper/loader.dart';
import 'package:rollingdoor/helper/shared_prefs_helper.dart';
import 'package:rollingdoor/main/detail_screen.dart';
import 'package:rollingdoor/main/user_profile_page.dart';
import 'package:rollingdoor/response/GetDeviceResponse.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.loginResponse, this.index}) : super(key: key);

  final Map loginResponse;
  final int index;

  @override
  _HomeScreenState createState() => _HomeScreenState(loginResponse);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState(this.loginResponse);

  final Map loginResponse;
  int _selectedIndex = 0;
  int quyen;
  SharedPrefsHelper sharedPrefsHelper;

  var client = http.Client();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = List();
  static List<BottomNavigationBarItem> bottomBarItems = List();
  static List<CustomBottomNavigationItem> items = List();

  @override
  void initState() {
    sharedPrefsHelper = SharedPrefsHelper();

    //khanhlh
    getDevices();

    // initBottomBarItems(loginResponse['quyen']);
    initBottomBarItems(1);

    // initWidgetOptions(loginResponse['quyen']);
    initWidgetOptions(1);
    // sharedPrefsHelper.addStringToSF('khoa', loginResponse['khoa']);
    // if (widget.index == null) {
    //   _selectedIndex = 0;
    // } else {
    //   _selectedIndex = widget.index;
    // }
    // getPermission();
    super.initState();
  }

  Future getDevices() async {
    String token = sharedPrefsHelper.getStringValuesSF('token');
    final response = await client.get(
        'http://103.146.23.146:8082/api/Devices/get-all-devices',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    print('Token : ${token}');

    print('device response: $response');

    if (response.statusCode == "200") {
      var deviceResponse = getDeviceResponseFromJson(response.body);

      var devices = deviceResponse.data;

      print('$devices');
    } else {
      this._showToast(context, response.statusCode);
    }
  }

  void _showToast(BuildContext context, message) {
    Dialogs.showAlertDialog(context, 'message');
  }

  void getPermission() async {
    // quyen = await sharedPrefsHelper.getIntValuesSF('quyen');
    quyen = 1;
    print(
        '_HomeScreenState.getPermission ${quyen.runtimeType} - $_selectedIndex');
    initBottomBarItems(quyen);
    initWidgetOptions(quyen);
    // sharedPrefsHelper.addStringToSF('khoa', loginResponse['khoa']);
  }

  void initBottomBarItems(int quyen) {
    switch (quyen) {
      case 1:
        bottomBarItems = [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
            ),
            label: 'Thiết bị',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Thêm',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_box_outlined,
            ),
            label: 'Cá nhân',
          ),
        ];

        items = [
          CustomBottomNavigationItem(
              icon: Icons.account_circle_outlined, label: 'Cảnh báo'),
          CustomBottomNavigationItem(icon: Icons.menu, label: 'Thiết bị'),
          CustomBottomNavigationItem(
              icon: Icons.meeting_room_outlined, label: 'địa điểm'),
          CustomBottomNavigationItem(icon: Icons.add, label: 'Thêm'),
          CustomBottomNavigationItem(
              icon: Icons.account_box_outlined, label: 'Cá nhân'),
        ];
        break;
      case 2:
        bottomBarItems = [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.details,
            ),
            label: 'Cảnh báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
            ),
            label: 'Danh sách',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Thêm',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_box_outlined,
            ),
            label: 'Cá nhân',
          ),
        ];

        items = [
          CustomBottomNavigationItem(icon: Icons.details, label: 'Cảnh báo'),
          CustomBottomNavigationItem(icon: Icons.menu, label: 'Danh sách'),
          CustomBottomNavigationItem(icon: Icons.add, label: 'Thêm'),
          CustomBottomNavigationItem(
              icon: Icons.account_box_outlined, label: 'Cá nhân'),
        ];
        break;
    }
  }

  void initWidgetOptions(int quyen) {
    print('_HomeScreenState.initWidgetOptions ${Constants.mac}');
    switch (quyen) {
      case 1:
        _widgetOptions = <Widget>[
          DetailScreen(),
          AddScreen(),
          UserProfilePage(
              // switchValue: false,
              ),
        ];
        break;
      case 2:
        break;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      bottomNavigationBar: bottomBar(),
    );
  }

  Widget buildBody() {
    print('_HomeScreenState.buildBody ${_widgetOptions.length}');
    return Container(
      child: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  Widget bottomBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        // sets the background color of the `BottomNavigationBar`
        canvasColor: Colors.blue,
        // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        primaryColor: Colors.red,
        textTheme: Theme.of(context).textTheme.copyWith(
              caption: new TextStyle(color: Colors.white),
            ),
      ),
      child: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: bottomBarItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildBottomNavigator(int currentIndex) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      child: Container(
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: Card(
          elevation: 5,
          color: BACKGROUND_COLOR,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            height: 60,
            child: CustomBottomNavigationBar(
              selectedItemColor: FORE_TEXT_COLOR,
              overlayColor: PRIMARY_COLOR,
              currentIndex: currentIndex,
              backgroundColor: Colors.transparent,
              onChange: (index) {
                _selectedIndex = index;
                // changePageViewPage(index);
              },
              children: items,
            ),
          ),
        ),
      ),
    );
  }
}
