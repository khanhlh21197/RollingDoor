// To parse this JSON data, do
//
//     final getDeviceResponse = getDeviceResponseFromJson(jsonString);

import 'dart:convert';

GetDeviceResponse getDeviceResponseFromJson(String str) => GetDeviceResponse.fromJson(json.decode(str));

String getDeviceResponseToJson(GetDeviceResponse data) => json.encode(data.toJson());

class GetDeviceResponse {
  GetDeviceResponse({
    this.statusCode,
    this.success,
    this.data,
    this.message,
  });

  int statusCode;
  bool success;
  List<Device> data;
  String message;

  factory GetDeviceResponse.fromJson(Map<String, dynamic> json) => GetDeviceResponse(
    statusCode: json["statusCode"],
    success: json["success"],
    data: List<Device>.from(json["data"].map((x) => Device.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Device {
  Device({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
