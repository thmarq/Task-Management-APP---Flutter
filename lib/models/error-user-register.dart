// To parse this JSON data, do
//
//     final registerUserError = registerUserErrorFromJson(jsonString);

import 'dart:convert';

RegisterUserError registerUserErrorFromJson(String str) => RegisterUserError.fromJson(json.decode(str));

String registerUserErrorToJson(RegisterUserError data) => json.encode(data.toJson());

class RegisterUserError {
  RegisterUserError({
    this.statusCode,
    this.message,
    this.error,
  });

  int statusCode;
  String message;
  String error;

  factory RegisterUserError.fromJson(Map<String, dynamic> json) => RegisterUserError(
    statusCode: json["statusCode"],
    message: json["message"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "error": error,
  };
}
