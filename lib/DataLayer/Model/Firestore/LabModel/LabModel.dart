import 'package:cloud_firestore/cloud_firestore.dart';

class LabModel {
  String? name;
  String? labCode;


  LabModel(
      {this.name, this.labCode});

  //save data to firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'labCode': labCode
    };
  }

  //get data from Repository
  factory LabModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> firestore) =>
      LabModel(
        name: firestore.data()!['name'],
        labCode: firestore.data()!['labCode'],
      );

  static LabModel fromJson(Map<String, dynamic> json) => LabModel(
    name: json['name'],
    labCode: json['labCode']
  );
}