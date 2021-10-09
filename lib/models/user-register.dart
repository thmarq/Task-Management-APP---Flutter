// To parse this JSON data, do
//
//     final registerUser = registerUserFromJson(jsonString);

import 'dart:convert';

RegisterUser registerUserFromJson(String str) => RegisterUser.fromJson(json.decode(str));

String registerUserToJson(RegisterUser data) => json.encode(data.toJson());

class RegisterUser {
  RegisterUser({
    this.data,
  });

  Data data;

  factory RegisterUser.fromJson(Map<String, dynamic> json) => RegisterUser(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.username,
    this.password,
    this.salt,
    this.id,
  });

  String username;
  String password;
  String salt;
  int id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    username: json["username"],
    password: json["password"],
    salt: json["salt"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "salt": salt,
    "id": id,
  };
}
