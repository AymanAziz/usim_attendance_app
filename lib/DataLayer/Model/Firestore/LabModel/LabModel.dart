import 'package:cloud_firestore/cloud_firestore.dart';

class LabModel {
  String? name;
  String? labCode;
  String? labDetails;


  LabModel(
      {this.name, this.labCode,this.labDetails});

  //save data to firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'labCode': labCode,
      'labDetails':labDetails
    };
  }

  //get data from Repository
  factory LabModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> firestore) =>
      LabModel(
        name: firestore.data()!['name'],
        labCode: firestore.data()!['labCode'],
        labDetails: firestore.data()!['labDetails'],
      );

  static LabModel fromJson(Map<String, dynamic> json) => LabModel(
    name: json['name'],
    labCode: json['labCode'],
      labDetails: json['labDetails']
  );
}