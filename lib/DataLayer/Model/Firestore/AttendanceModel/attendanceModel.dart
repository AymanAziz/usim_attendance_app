import 'package:cloud_firestore/cloud_firestore.dart';

class ListMain{
  final List<AttendanceModel> attendance;

  ListMain({required this.attendance});
}
class AttendanceModel
{
  // Timestamp? date;
  String? email;
  String? username;

  // AttendanceModel({this.date, this.email, this.attend});
  AttendanceModel({ this.email, this.username});

  //save data to firebase
  Map<String, dynamic> toMap() {
    return {
      // 'username': date,
      'email': email,
      'username': username,
    };
  }


  //get data from Repository
  factory AttendanceModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> firestore) =>
      AttendanceModel(
        email: firestore.data()!['email'],
        username: firestore.data()!['username'],
      );

  //get data from Repository
  factory AttendanceModel.fromFirestore1(
      DocumentSnapshot<Map<String, dynamic>> firestore) =>
      AttendanceModel(
        email: firestore.data().toString().contains('email') ?firestore.get('email'):'',
        username: firestore.data().toString().contains('username') ?firestore.get('username'):'',
      );

  static AttendanceModel fromJson(Map<String, dynamic> json) => AttendanceModel(
      email: json['email'],
      username: json['attend']
  );

}

