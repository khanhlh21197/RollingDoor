// To parse this JSON data, do
//
//     final loginRequest = loginRequestFromJson(jsonString);

import 'dart:convert';

LoginRequest loginRequestFromJson(String str) => LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
  LoginRequest({
    this.phoneNumber,
    this.password,
    this.isRemember,
  });

  String phoneNumber;
  String password;
  bool isRemember;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
    phoneNumber: json["phoneNumber"],
    password: json["password"],
    isRemember: json["isRemember"],
  );

  Map<String, dynamic> toJson() => {
    "phoneNumber": phoneNumber,
    "password": password,
    "isRemember": isRemember,
  };
}
