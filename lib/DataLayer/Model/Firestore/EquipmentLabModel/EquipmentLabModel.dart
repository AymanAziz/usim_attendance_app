import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';


///create model that can retrieve all equipment details from firestore
class EquipmentLabModel {
  String? name;
  int? quantity;
  List? user;


  EquipmentLabModel(
      {this.name, this.quantity,  this.user});

  //save data to firebase
  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Quantity': quantity,
      'User': user,
    };
  }


  ///get data from firestore
  static EquipmentLabModel fromJson(Map<String, dynamic> json) => EquipmentLabModel(
    name: json['Name'],
    quantity: json['Quantity'],
    user: List<String>.from(json["User"]),


  );
}


///create an array that contain list of user using equipment
class UserUsingLabEquipmentModel {
  String User;


  UserUsingLabEquipmentModel({
    required this.User,
  });

  factory UserUsingLabEquipmentModel.fromJson(Map<String, dynamic> json) =>
      UserUsingLabEquipmentModel(
        User: json["User"],
      );


  Map<String, dynamic> toJson() =>
      {
        "User": User
      };
}











