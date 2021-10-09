// To parse this JSON data, do
//
//     final userLogin = userLoginFromJson(jsonString);

import 'dart:convert';

UserLogin userLoginFromJson(String str) => UserLogin.fromJson(json.decode(str));

String userLoginToJson(UserLogin data) => json.encode(data.toJson());

class UserLogin {
  UserLogin({
    this.statusCode,
    this.message,
    this.error,
  });

  int statusCode;
  List<String> message;
  String error;

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
    statusCode: json["statusCode"],
    message: List<String>.from(json["message"].map((x) => x)),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": List<dynamic>.from(message.map((x) => x)),
    "error": error,
  };
}