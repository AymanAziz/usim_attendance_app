import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:usim_attendance_app/DataLayer/Model/Firestore/EquipmentLabModel/EquipmentAdminModel.dart';

import '../../../Model/Firestore/EquipmentLabModel/ListEquipmentAdminModel.dart';


class EquipmentRepository {

  ///equipment details
  CollectionReference db = FirebaseFirestore.instance.collection(
      'EquipmentDetails');

  ///list equipment
  CollectionReference listDb = FirebaseFirestore.instance.collection(
      'ListEquipment');

  Future<void> addLab(EquipmentAdminLabModel equipmentAdminLabModel) async {
    String docIdEquipmentDetails = "${equipmentAdminLabModel
        .labId} ${equipmentAdminLabModel.equipmentSeriesNo}";

    /// add new equipment details kt firestore
    await db.doc(docIdEquipmentDetails).set({
      'EquipmentName': equipmentAdminLabModel.equipmentName,
      'EquipmentLink': equipmentAdminLabModel.equipmentLink,
      'EquipmentSeriesNo': equipmentAdminLabModel.equipmentSeriesNo,
      'LabId': equipmentAdminLabModel.labId,
      'Quantity': equipmentAdminLabModel.quantity,
    });

    /// add equipment to specific lab in list
    await db.doc(docIdEquipmentDetails).set({
      'EquipmentName': equipmentAdminLabModel.equipmentName,
      'EquipmentLink': equipmentAdminLabModel.equipmentLink,
      'EquipmentSeriesNo': equipmentAdminLabModel.equipmentSeriesNo,
      'LabId': equipmentAdminLabModel.labId,
      'Quantity': equipmentAdminLabModel.quantity,
    });

    // -------------------------- listEquipment collection ----------------------
    //created by ali aiman on 8/4/2023

    String collectionName = 'ListEquipment';
    String documentId = '${equipmentAdminLabModel.labId}';
    String equipmentName = '${equipmentAdminLabModel.equipmentSeriesNo}';

    final docRef = FirebaseFirestore.instance.collection(collectionName).doc(
        documentId);

    try {
      var doc = await docRef.get();
      if (doc.exists) {
        /// document exists, add new element to existing array (if 'Equipment' field is an array)
        var equipmentData = doc.data();
        if (equipmentData != null &&
            equipmentData['Equipment'] is List<dynamic>) {
          List<dynamic> equipmentList = List.castFrom(
              equipmentData['Equipment']);
          equipmentList.add(equipmentName);

          await docRef.update({
            'Equipment': equipmentList
          });
        } else {
          /// 'Equipment' field is not an array, replace with new array containing new equipment
          await docRef.set({
            'Equipment': [equipmentName]
          });
        }
      } else {
        /// document doesn't exist, add new array with new element
        await docRef.set({
          'Equipment': [equipmentName]
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }


    return;
  }

  Future<void> updateLab(EquipmentAdminLabModel equipmentAdminLabModel) async {
    String docIdEquipmentDetails = "${equipmentAdminLabModel.labId} ${equipmentAdminLabModel.equipmentSeriesNo}";

    /// update existing equipment details in Firestore
    await db.doc(docIdEquipmentDetails).update({
      'EquipmentLink': equipmentAdminLabModel.equipmentLink,
      'EquipmentName': equipmentAdminLabModel.equipmentName,
      'Quantity': equipmentAdminLabModel.quantity,
    });

    // -------------------------- listEquipment collection ----------------------
    //created by ali aiman on 8/4/2023

    String collectionName = 'ListEquipment';
    String documentId = '${equipmentAdminLabModel.labId}';
    String equipmentName = '${equipmentAdminLabModel.equipmentSeriesNo}';

    final docRef = FirebaseFirestore.instance.collection(collectionName).doc(documentId);

    try {
      var doc = await docRef.get();
      if (doc.exists) {
        /// document exists, update element in existing array (if 'Equipment' field is an array)
        var equipmentData = doc.data();
        if (equipmentData != null && equipmentData['Equipment'] is List<dynamic>) {
          List<dynamic> equipmentList = List.castFrom(equipmentData['Equipment']);
          int index = equipmentList.indexOf(equipmentName);
          if (index != -1) {
            equipmentList[index] = equipmentName;
            await docRef.update({'Equipment': equipmentList});
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }

    return;
  }

  Future<void> deleteLab(String labId, String equipmentSeriesNo) async {
    String docIdEquipmentDetails = "$labId $equipmentSeriesNo";

    /// delete document from EquipmentDetails collection
    await FirebaseFirestore.instance
        .collection('EquipmentDetails')
        .doc(docIdEquipmentDetails)
        .delete();

    /// delete equipment from lab's list in ListEquipment collection
    String collectionName = 'ListEquipment';
    String documentId = labId;

    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentId)
        .update({
      'Equipment': FieldValue.arrayRemove([equipmentSeriesNo])
    });
  }

  Future<EquipmentListModel> readEquipmentList(String labId) async {
    final docSnapshot =
    await FirebaseFirestore.instance.collection('ListEquipment').doc(labId).get();

    if (docSnapshot.exists) {
      final equipmentListModel = EquipmentListModel.fromJson(docSnapshot.data()!);
      return equipmentListModel;
    } else {
      throw Exception('ListEquipment with labId $labId does not exist.');
    }
  }


}

  // Future<void> updateLab(LabModel labModel ) async{
  //   await db.doc(labModel.labCode).update({
  //     'name': labModel.name,
  //     // 'labCode': labModel.labCode,
  //     'labDetails': labModel.labDetails,
  //   });
  //   return;
  // }
  //
  // Future<void> removeLab(String labCode ) async{
  //
  //   final oldDocRef = db.doc(labCode);
  //   await oldDocRef.delete();
  //
  //   return;
  // }
  //
  // Future<List<LabModel>> listLab() async
  // {
  //   List<LabModel> listLabModel = [];
  //   try {
  //     final value = await FirebaseFirestore.instance.collection(
  //         "ListLab").get();
  //     for (var value in value.docs) {
  //       var details = value.data();
  //       listLabModel.add(LabModel.fromJson(value.data()));
  //
  //     }
  //     return listLabModel;
  //   } on FirebaseException catch (e) {
  //     return listLabModel;
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }
// }



