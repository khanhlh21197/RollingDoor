

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rollingdoor/helper/loader.dart';
import 'package:rollingdoor/helper/models.dart';
import 'package:rollingdoor/helper/shared_prefs_helper.dart';
import 'package:rollingdoor/model/door.dart';
// import 'package:rollingdoor/request/DeviceRequest.dart';
import 'package:rollingdoor/response/CreateDeviceResponse.dart';
import 'package:rollingdoor/response/door_response.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../helper/constants.dart' as Constants;
import 'package:http/http.dart' as http;

class AddDeviceScreen extends StatefulWidget {
  final List<String> dropDownItems;

  const AddDeviceScreen({Key key, this.dropDownItems}) : super(key: key);

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  SharedPrefsHelper sharedPrefsHelper;

  final scrollController = ScrollController();
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final vitriController = TextEditingController();

  String currentSelectedValue;

  @override
  void initState() {
    // initMqtt();
    sharedPrefsHelper = SharedPrefsHelper();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thêm thiết bị',
        ),
        centerTitle: true,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: Scrollbar(
          isAlwaysShown: true,
          controller: scrollController,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                idDeviceContainer(
                  'Mã thiết bị *',
                  Icon(Icons.vpn_key),
                  TextInputType.visiblePassword,
                  idController,
                ),
                buildTextField(
                  'Vị trí',
                  Icon(Icons.add_location),
                  TextInputType.text,
                  vitriController,
                ),
                buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget idDeviceContainer(String labelText, Icon prefixIcon,
      TextInputType keyboardType, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 44,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        autocorrect: false,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: labelText,
          // labelStyle: ,
          // hintStyle: ,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.qr_code),
            onPressed: () async {
              String cameraScanResult = await scanner.scan();
              controller.text = cameraScanResult;
            },
          ),
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, Icon prefixIcon,
      TextInputType keyboardType, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 44,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        autocorrect: false,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: labelText,
          // labelStyle: ,
          // hintStyle: ,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 20,
          ),
          // suffixIcon: Icon(Icons.account_balance_outlined),
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }

  Widget buildButton() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 32,
      ),
      child: Row(
        children: [
          Expanded(
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
          ),
          Expanded(
            child: RaisedButton(
              onPressed: () {
                // tryAdd();
                // tryAddDevice();
              },
              color: Colors.blue,
              child: Text('Lưu'),
            ),
          ),
        ],
      ),
    );
  }

  // void tryAdd() {
  //   if (idController.text.isEmpty || vitriController.text.isEmpty) {
  //     Dialogs.showAlertDialog(context, 'Vui lòng nhập đủ thông tin!');
  //     return;
  //   }
  //   Door door =
  //       Door(idController.text, vitriController.text, '', '', Constants.mac);
  //   publishMessage('registertb', jsonEncode(door));
  // }

  void showLoadingDialog() {
    Dialogs.showLoadingDialog(context, _keyLoader);
  }

  void hideLoadingDialog() {
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  // Future<void> initMqtt() async {
  //   mqttClientWrapper =
  //       MQTTClientWrapper(() => print('Success'), (message) => handle(message));
  //   await mqttClientWrapper.prepareMqttClient(Constants.mac);
  // }

  void handle(String message) {
    final doorResponse = doorResponseFromJson(message);
    if (doorResponse.result == 'true' && doorResponse.errorCode == '0') {
      Navigator.pop(context);
    }
  }

  // Future<void> publishMessage(String topic, String message) async {
  //   if (mqttClientWrapper.connectionState ==
  //       MqttCurrentConnectionState.CONNECTED) {
  //     mqttClientWrapper.publishMessage(topic, message);
  //   } else {
  //     await initMqtt();
  //     mqttClientWrapper.publishMessage(topic, message);
  //   }
  // }

  // Future<void> tryAddDevice() async {
  //   var client = http.Client();
  //   try {
  //     var token = await sharedPrefsHelper.getStringValuesSF("token");
  //     print('$token');
  //
  //     Map<String, String> requestHeaders = {
  //       'Content-type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': '${token}'
  //     };
  //
  //     var function = Func(
  //         id: 0, deviceId: 0, functionCode: "string", functionName: "string");
  //
  //     var deviceRequest = DeviceRequest(
  //       id: 0,
  //       name: "string",
  //       icon: "string",
  //       functions: [function],
  //     );
  //
  //     var uriResponse = await client.post(
  //       Uri.parse('http://103.146.23.146:8082/api/Devices/create-device'),
  //       headers: requestHeaders,
  //       // headers: {
  //       //   HttpHeaders.authorizationHeader: '$token',
  //       // },
  //       body: deviceRequestToJson(deviceRequest),
  //     );
  //     print('Response statuscode: ${uriResponse.statusCode}');
  //     print('Response body: ${uriResponse.body}');
  //
  //     //parse response body to object DeviceResponse
  //     var deviceResponse = deviceResponseFromJson(uriResponse.body);
  //     print('$deviceResponse');
  //
  //     if (uriResponse.statusCode == 200) {
  //       print('add success');
  //       Navigator.pop(context);
  //
  //     } else {}
  //   } finally {
  //     client.close();
  //   }
  // }

  @override
  void dispose() {
    scrollController.dispose();
    nameController.dispose();
    idController.dispose();
    vitriController.dispose();
    super.dispose();
  }
}
