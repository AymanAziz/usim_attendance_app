import 'package:equatable/equatable.dart';

class UserModelSqlite extends Equatable {
  final int? id;
  final String name;
  final String telNumber;
  final String email;
  final String userID;
  final int isAdmin;

  const UserModelSqlite(
      {this.id,
        required this.name,
        required this.telNumber,
        required this.userID,
        required this.email,
      required this.isAdmin});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'telNumber': telNumber,
      'userID': userID,
      'email': email,
      'id': id
    };
  }

//get data from Repository
  static UserModelSqlite fromJSON(Map<String, Object?> json) => UserModelSqlite(
      name: json['name'] as String,
      telNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      userID: json['UserID'] as String,
      isAdmin: json['isAdmin'] as int,
      id: json['id'] as int?);

  @override
// TODO: implement props
  List<Object?> get props =>
      [id, name, telNumber,  email,userID,isAdmin];
}