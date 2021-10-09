// To parse this JSON data, do
//
//     final loginSuccess = loginSuccessFromJson(jsonString);

import 'dart:convert';

LoginSuccess loginSuccessFromJson(String str) => LoginSuccess.fromJson(json.decode(str));

String loginSuccessToJson(LoginSuccess data) => json.encode(data.toJson());

class LoginSuccess {
  LoginSuccess({
    this.accessToken,
  });

  String accessToken;

  factory LoginSuccess.fromJson(Map<String, dynamic> json) => LoginSuccess(
    accessToken: json["accessToken"],
  );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
  };
}
