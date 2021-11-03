
import 'dart:async';
import 'dart:convert';

import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:rollingdoor/helper/config.dart';
import 'package:rollingdoor/helper/models.dart';
import 'package:rollingdoor/helper/shared_prefs_helper.dart';
import 'package:rollingdoor/login/login_page.dart';
import 'package:rollingdoor/model/door.dart';
import 'package:rollingdoor/model/thietbi.dart';
import 'package:rollingdoor/navigator.dart';
import 'package:rollingdoor/response/door_response.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../helper/constants.dart' as Constants;
import '../rolling_door_remote.dart';

class DetailScreen extends StatefulWidget {

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  final sharedPrefs = SharedPrefsHelper();
  List<Message> tbs = List();
  List<Door> doors = List();
  String email;
  String iduser;
  String pubTopic;
  bool isLoading = true;

  var dropDownProducts = [''];
  String _selectedProduct;
  String _selectedDevice;
  var itemColor;

  @override
  void initState() {
    getSharedPrefs();

    isLoading = false;
    doors.add(Door('TECHNO1', 'A', '', '', 'mac'));
    doors.add(Door('TECHNO2', 'B', '', '', 'mac'));
    doors.add(Door('TECHNO3', 'C', '', '', 'mac'));

    // initMqtt();
    super.initState();
  }

  void getDevices() async {
    Door door = Door('', '', '', iduser, Constants.mac);
    pubTopic = Constants.GET_DEVICE;
    showLoadingDialog();
  }

  void getSharedPrefs() async {
    email = await sharedPrefs.getStringValuesSF('email');
    iduser = await sharedPrefs.getStringValuesSF('iduser');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giám sát thiết bị'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                navigatorPushAndRemoveUntil(context, LoginPage());
              }),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return buildItem(index);
              },
              itemCount: doors.length,
            ),
          )
        ],
      ),
    );
  }

  Widget buildItem(int index) {
    return GestureDetector(
      onTap: () {
        navigatorPush(context, RollingDoor(mathietbi: doors[index].matb,));
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey),
          color: Colors.white,
        ),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Text(doors[index].matb ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 20,),
            Image.asset(
              'assets/images/garage_open.png',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  void showLoadingDialog() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration(seconds: 3), hideLoadingDialog);
  }

  void hideLoadingDialog() {
    setState(() {
      isLoading = false;
    });
  }


  void changeItemColor(ThietBi element) {
    Future.delayed(Duration(milliseconds: 500), () {
      element.color = Colors.white;
      setState(() {});
    });
  }

  void handle(String message) {
    try {
      switch (pubTopic) {
        case Constants.GET_DEVICE:
          final doorResponse = doorResponseFromJson(message);
          tbs = doorResponse.message ;
          setState(() {});
          doors.clear();
          tbs.forEach((element) {
            doors.add(Door(element.matb, element.vitri, '', element.id, Constants.mac));
          });
          print('_DetailScreenState.handle doors: ${doors.length}');
          break;
      }
      pubTopic = '';
    } catch (e) {
      print('_DetailScreenState.handle $e');
    }
  }

  Widget clayContainer(String nhietdo) {
    double nd = double.tryParse(nhietdo);
    return ClayContainer(
      height: 50,
      width: 50,
      color: primaryColor,
      borderRadius: 10,
      child: Padding(
        padding: EdgeInsets.all(4),
        child: SleekCircularSlider(
          appearance: CircularSliderAppearance(
            customColors: CustomSliderColors(
              progressBarColors: gradientColors,
              hideShadow: true,
              shadowColor: Colors.transparent,
            ),
            infoProperties: InfoProperties(
                mainLabelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                modifier: (double value) {
                  final roundedValue = nd.ceil().toInt().toString();
                  return '$roundedValue \u2103';
                }),
          ),
          // onChange: (double value) {
          //   print(value);
          // }
        ),
      ),
    );
  }

  Widget sleek(String nhietdo) {
    double nd = double.tryParse(nhietdo);
    if (nd >= 200) nd = 200;
    return Container(
      width: 95,
      height: 95,
      child: SleekCircularSlider(
        appearance: CircularSliderAppearance(
          customColors: CustomSliderColors(
            progressBarColors: gradientColors,
            hideShadow: true,
            shadowColor: Colors.transparent,
          ),
          customWidths: CustomSliderWidths(progressBarWidth: 10),
          infoProperties: InfoProperties(
              mainLabelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              modifier: (double value) {
                final roundedValue = nd.ceil().toInt().toString();
                return '$roundedValue \u2103';
              }),
        ),
        min: 0,
        max: 200,
        initialValue: nd,
      ),
    );
  }
}

ScaleResponse scaleResponseFromJson(String str) =>
    ScaleResponse.fromJson(json.decode(str));

String scaleResponseToJson(ScaleResponse data) => json.encode(data.toJson());

class ScaleResponse {
  ScaleResponse({
    this.matb,
    this.nhietdo,
  });

  String matb;
  String nhietdo;

  factory ScaleResponse.fromJson(Map<String, dynamic> json) => ScaleResponse(
        matb: json["matb"],
        nhietdo: json["nhietdo"],
      );

  Map<String, dynamic> toJson() => {
        "matb": matb,
        "nhietdo": nhietdo,
      };
}
