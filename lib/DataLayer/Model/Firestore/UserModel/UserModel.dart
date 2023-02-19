import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel {
  String? name;
  String? email;
  String? userID;
  String? telNumber;
  bool? isAdmin;

  UserModel(
      {this.name, this.email,  this.telNumber,this.isAdmin, this.userID});

  //save data to firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'userID': userID,
      'telNumber': telNumber,
      'isAdmin' : isAdmin,
    };
  }

  //get data from Repository
  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> firestore) =>
      UserModel(
        name: firestore.data()!['name'],
        email: firestore.data()!['email'],
        userID: firestore.data()!['userID'],
        telNumber: firestore.data()!['telNumber'],
        isAdmin: firestore.data()!['isAdmin'],
      );

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'],
    email: json['email'],
    userID: json['userID'],
    telNumber: json['telNumber'],
    isAdmin: json['isAdmin'],
  );
}


