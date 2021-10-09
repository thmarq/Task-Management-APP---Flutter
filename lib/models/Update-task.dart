// To parse this JSON data, do
//
//     final updateTask = updateTaskFromJson(jsonString);

import 'dart:convert';

UpdateTask updateTaskFromJson(String str) => UpdateTask.fromJson(json.decode(str));

String updateTaskToJson(UpdateTask data) => json.encode(data.toJson());

class UpdateTask {
  UpdateTask({
    this.data,
  });

  Data data;

  factory UpdateTask.fromJson(Map<String, dynamic> json) => UpdateTask(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.name,
    this.description,
    this.userId,
    this.status,
  });

  int id;
  String name;
  String description;
  int userId;
  String status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    userId: json["userId"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "userId": userId,
    "status": status,
  };
}
