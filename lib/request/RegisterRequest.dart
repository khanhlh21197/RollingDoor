// To parse this JSON data, do
//
//     final registerRequest = registerRequestFromJson(jsonString);

import 'dart:convert';

RegisterRequest registerRequestFromJson(String str) => RegisterRequest.fromJson(json.decode(str));

String registerRequestToJson(RegisterRequest data) => json.encode(data.toJson());

class RegisterRequest {
  RegisterRequest({
    this.phoneNumber,
    this.password,
    this.confirmPassword,
  });

  String phoneNumber;
  String password;
  String confirmPassword;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => RegisterRequest(
    phoneNumber: json["phoneNumber"],
    password: json["password"],
    confirmPassword: json["confirmPassword"],
  );

  Map<String, dynamic> toJson() => {
    "phoneNumber": phoneNumber,
    "password": password,
    "confirmPassword": confirmPassword,
  };
}
