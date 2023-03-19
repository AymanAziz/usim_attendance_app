import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:usim_attendance_app/DataLayer/Model/Firestore/LabModel/LabModel.dart';


class LabRepository {
  CollectionReference db = FirebaseFirestore.instance.collection('ListLab');

  Future<void> addLab(LabModel labModel ) async{
    await db.doc(labModel.labCode).set({
      'name': labModel.name,
      'labCode': labModel.labCode,
      'labDetails': labModel.labDetails,
    });
    return;
  }

  Future<void> updateLab(LabModel labModel ) async{
    await db.doc(labModel.labCode).update({
      'name': labModel.name,
      // 'labCode': labModel.labCode,
      'labDetails': labModel.labDetails,
    });
    return;
  }

  Future<void> removeLab(String labCode ) async{

    final oldDocRef = db.doc(labCode);
    await oldDocRef.delete();

    return;
  }

  Future<List<LabModel>> listLab() async
  {
    List<LabModel> listLabModel = [];
    try {
      final value = await FirebaseFirestore.instance.collection(
          "ListLab").get();
      for (var value in value.docs) {
        var details = value.data();
        listLabModel.add(LabModel.fromJson(value.data()));

      }
      return listLabModel;
    } on FirebaseException catch (e) {
      return listLabModel;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}



