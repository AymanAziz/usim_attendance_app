import 'dart:convert';

import 'package:equatable/equatable.dart';


Attendance cargoPriceListModelFromJson(String str) =>
    Attendance.fromJson(json.decode(str));

String cargoPriceListModelToJson(Attendance data) => json.encode(data.toJson());

class Attendance {
  /// String admin;
  List<Student> student;

  Attendance({
    /// required this.admin,
    required this.student,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    student: List<Student>.from(json["student"]
        .map((x) => Student.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "student":  List<dynamic>.from(student.map((x) => x.toJson())),
  };
}


class Student {
  String username;
  String email;

  Student({
    required this.username,
    required this.email,
  });

  factory Student.fromJson(Map<String, dynamic> json) =>
      Student(
        username: json["username"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() =>
      {
        "email": email,
        "username": username,
      };
}

/// model for attendance SQLITE
class AttendanceSQLite extends Equatable {
  final int? id;
  final String date;
  final int userId;
  final String name;
  final String labName;
  final String StaffOrUserID;

  const AttendanceSQLite(
      {this.id,
        required this.date,
        required this.userId,
        required this.name,
        required this.labName,
        required this.StaffOrUserID,
      });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'userId': userId,
      'id': id,
      'name': name,
      'labName':labName,
      'StaffOrUserID': StaffOrUserID,
    };
  }

//get data from Repository
  static AttendanceSQLite fromJSON(Map<String, Object?> json) => AttendanceSQLite(
      date: json['date'] as String,
      name: json['name'] as String,
      labName: json['labName'] as String,
      StaffOrUserID: json['StaffOrUserID'] as String,
      userId: json['userId'] as int,
      id: json['id'] as int?);

  @override
// TODO: implement props
  List<Object?> get props =>
      [id, date,userId,name,StaffOrUserID];
}