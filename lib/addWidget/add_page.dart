
import 'package:flutter/material.dart';
import 'package:rollingdoor/addWidget/add_device_page.dart';
import 'package:rollingdoor/helper/shared_prefs_helper.dart';
import 'package:rollingdoor/model/door.dart';
import 'package:rollingdoor/navigator.dart';
import 'package:rollingdoor/response/door_response.dart';

import '../helper/constants.dart' as Constants;

class AddScreen extends StatefulWidget {
  final String quyen;

  const AddScreen({Key key, this.quyen}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  static const GET_DEPARTMENT = 'logindiadiem';
  static const LOGIN_DEVICE = 'gettb';

  SharedPrefsHelper sharedPrefsHelper;
  List<String> dropDownItems = List();
  int selectedIndex;


  bool isLoading = false;

  String pubTopic;
  List<Door> doors = List();
  List<Message> tbs = List();


  @override
  void initState() {

    isLoading = false;
    doors.add(Door('TECHNO1', 'A', '', '', 'mac'));
    doors.add(Door('TECHNO2', 'B', '', '', 'mac'));
    doors.add(Door('TECHNO3', 'C', '', '', 'mac'));

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thêm',
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body:
          isLoading ? Center(child: CircularProgressIndicator()) : buildBody(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            horizontalLine(),
            buildButton('Thêm thiết bị', Icons.devices, 2),
            SizedBox(height: 30,),
            buildBodyListDevice(),
          ],
        ),
      ),
    );
  }

  void getDevices() async {
    Door door = Door('', '', '', '', Constants.mac);
    pubTopic = LOGIN_DEVICE;
  }

  Widget buildBodyListDevice() {
    return Container(
      child: Column(
        children: [
          horizontalLine(),
          buildTableTitle(),
          horizontalLine(),
          buildListView(),
          horizontalLine(),
        ],
      ),
    );
  }

  Widget buildTableTitle() {
    return Container(
      color: Colors.white,
      height: 40,
      child: Row(
        children: [
          verticalLine(),
          buildTextLabel('STT', 1),
          verticalLine(),
          buildTextLabel('Mã', 3),
          verticalLine(),
          buildTextLabel('Vị trí', 3),

        ],
      ),
    );
  }

  Widget buildTextLabel(String data, int flexValue) {
    return Expanded(
      child: Text(
        data,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      flex: flexValue,
    );
  }

  Widget buildListView() {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: doors.length,
        itemBuilder: (context, index) {
          return itemView(index);
        },
      ),
    );
  }

  Widget itemView(int index) {
    return InkWell(
      onTap: () async {
        // selectedIndex = index;
        // await showDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     builder: (BuildContext context) {
        //       return Dialog(
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(10.0)),
        //         //this right here
        //         child: Container(
        //           child: Stack(
        //             children: [
        //               EditDeviceDialog(
        //                 thietbi: doors[selectedIndex],
        //                 // dropDownItems: dropDownItems,
        //                 deleteCallback: (param) {
        //                   getDevices();
        //                 },
        //                 updateCallback: (updatedDevice) {
        //                   getDevices();
        //                 },
        //               ),
        //               Positioned(
        //                 right: 0.0,
        //                 child: GestureDetector(
        //                   onTap: () {
        //                     Navigator.of(context).pop();
        //                     getDevices();
        //                   },
        //                   child: Align(
        //                     alignment: Alignment.topRight,
        //                     child: CircleAvatar(
        //                       radius: 14.0,
        //                       backgroundColor: Colors.white,
        //                       child: Icon(Icons.close, color: Colors.black),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       );
        //     });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Column(
          children: [
            Container(
              height: 40,
              child: Row(
                children: [
                  buildTextData('${index + 1}', 1),
                  verticalLine(),
                  buildTextData('${doors[index].matb}', 3),
                  verticalLine(),
                  buildTextData('${doors[index].vitri}', 3),
                  // verticalLine(),
                  // buildEditBtn(index,1),
                ],
              ),
            ),
            horizontalLine(),
          ],
        ),
      ),
    );
  }

  Widget buildEditBtn(int index, int flex) {
    return Expanded(
      child: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () async {

          }),
      flex: flex,
    );
  }

  Widget buildTextData(String data, int flexValue) {
    return Expanded(
      child: Text(
        data,
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
      flex: flexValue,
    );
  }


  Widget verticalLine(){
    return Container(
      height: double.infinity,
      width: 1,
      color: Colors.black,
    );
  }

  Widget horizontalLine() {
    return Container(height: 1, width: double.infinity, color: Colors.black);
  }

  Widget buildButton(String text, IconData icon, int option) {
    return GestureDetector(
      onTap: () {
        switch (option) {
          case 1:
            break;
          case 2:
              navigatorPush(
                  context,
                  AddDeviceScreen(
                    // dropDownItems: dropDownItems,
                  ));
            break;
          case 3:
            break;
        }
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Icon(
              icon,
              size: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }

  void handle(String message) {

    switch (pubTopic) {
      case Constants.GET_DEVICE:
        final doorResponse = doorResponseFromJson(message);
        tbs = doorResponse.message ;
        setState(() {});
        doors.clear();
        tbs.forEach((element) {
          doors.add(Door(element.matb, element.vitri, '', element.id, Constants.mac));
        });
        print('_DetailScreenState.handle addpage doors: ${doors.length}');
        break;
    }
    pubTopic = '';

  }

  void showLoadingDialog() {
    setState(() {
      isLoading = true;
    });
  }

  void hideLoadingDialog() {
    setState(() {
      isLoading = false;
    });
  }

}
