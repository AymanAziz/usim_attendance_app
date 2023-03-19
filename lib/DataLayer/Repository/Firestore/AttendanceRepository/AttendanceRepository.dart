import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../../../Bloc/AttendanceBloc/attendance_bloc.dart';
import '../../../Model/Firestore/EquipmentLabModel/EquipmentLabModel.dart';
import '../../../Model/Firestore/UserModel/UserModel.dart';
import '../../../Model/Sqlite/LabModel/LabModel.dart';
import '../../Sqlite/SqliteRepository.dart';



class AttendanceRepository {
   FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference dbUser = FirebaseFirestore.instance.collection('user');

  Stream<DocumentSnapshot<Object?>> getAttendance() {
    DateTime currentDateTime = DateTime.now();
    Timestamp myTimeStamp = Timestamp.fromDate(currentDateTime); //To TimeStamp
    DateTime currentDate = myTimeStamp.toDate();

    print(DateTime(currentDate.year, currentDate.month, 27));

    var courseDocStream = db
        .doc(DateTime(currentDate.year, currentDate.month, 0).toString())
        .snapshots();

    return courseDocStream;
  }



   ///betulkan admin punya database
  Stream<DocumentSnapshot<Object?>> getAttendanceTest(
      selectDateDatabase, pressDateButton) {
    String selectDate = '';
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    DateTime aa = DateTime.now();
    selectDate = formatter.format(aa!);

    switch (pressDateButton) {
      case false:
        {
          print('current date: $selectDate');
          var courseDocStream = db.collection('Makmal1 Attendance').doc(selectDate).snapshots();
          return courseDocStream;
        }
      default:
        {
          switch (selectDateDatabase) {
            case '':
              {
                var courseDocStream = FirebaseFirestore.instance
                    .collection('noValue')
                    // .doc("${currentDate.year}-${currentDate.month}-0")
                    .doc("V1KydKOcAjjQ72t3EFcg")
                    .snapshots();
                // var courseDocStream = db.doc(selectDateDatabase).snapshots();
                return courseDocStream;
              }
            case 'A':
              {
                var courseDocStream = db.collection('Makmal1 Attendance').doc(selectDate).snapshots();
                return courseDocStream;
              }
            default:
              {
                var courseDocStream = db.collection('Makmal1 Attendance').doc(selectDateDatabase).snapshots();
                return courseDocStream;
              }
          }
        }
    }
  }

  Future<int> countUser() async {
    int size = 0;
    await FirebaseFirestore.instance.collection('user').where('isStudent', isEqualTo: 'Student').get().then((snap) {
      size = snap.size;
    });
    return size;
  }

  ///display list user
  Future<List<UserModel>> listUsers() async {
    List<UserModel> userList = [];
    try {
      final users = await FirebaseFirestore.instance.collection('user').get();

      for (var value in users.docs) {
        userList.add(UserModel.fromJson(value.data()));
      }
      return userList;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error $e");
      }
      return userList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }



  ///dah solve yg db
  Future addAttendanceUser( String labName) async {
    String? email = FirebaseAuth.instance.currentUser?.email;
    final sQLiteDb = SqliteDatabase.instance;
    var data;

    ///dia nk get data  name value
    await dbUser.doc(email).get().then((value) => {data = value.data()});
    var userDetails = {'username': data["username"]};

    ///---------------------------------------
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    DateTime startDate = DateTime.now();
    var selectDateDatabase = formatter.format(startDate!);

    ///---------------------------------------

    /// check current document is exist in firestore
    /// current document == current date

    bool checkAttendance = false;

    var userDocRef = db.collection('$labName Attendance').doc(selectDateDatabase);
    var doc = await userDocRef.get();
    if (!doc.exists) {
      checkAttendance = true;
    } else {}

    ///---------------------------------------

    ///return true if no current date (doc) in firestore
    switch (checkAttendance) {
      case true:
        {
          /// kt sini ko save kt sqlite if n only if ( data tu x de)
          bool status = await sQLiteDb.createAttendance(selectDateDatabase,labName);

          /// return true if no data (empty) in SQLITE --> save to firestore
          switch (status) {
            case true:{
              ///kiv  aspect result: result nak array --> string
              ///kiv   actual result : array--> map --> string
              db.collection('$labName Attendance').doc(selectDateDatabase).set({
                "Student": [userDetails]});
              // }, SetOptions(merge: true));

            }
              break;
            default: /// ada data kt db
              {
              }
              break;
          }
        }

        break;
      default:
        {

          /// kt sini ko save kt sqlite if n only if ( data tu x de)
          bool status = await sQLiteDb.createAttendance(selectDateDatabase,labName);

          /// return false if no data in SQLITE --> save to firestore
          switch (status) {
            case true:{
              ///kiv  aspect result: result nak array --> string
              ///kiv  actual result: result nak array --> string
              db.collection('$labName Attendance').doc(selectDateDatabase).update(
                  {"Student": FieldValue.arrayUnion([userDetails])});
            }
            break;
            case false:{}
            break;
            default:
              {
              }
              break;
          }
        }
        break;
    }
  }




  ///check from firestore list of document from Collection 'ListLab'  when user want to scan QR code
  /// return false if qr code is not valid   and dont have same name in docs name (ListLab Collection)
  Future<bool> getLabListFirestore(LabModelSQLite labModelSQLite) async{
    if (kDebugMode) {
      print ("data daripada  qrcode : ${labModelSQLite.labCode.toString()}");
    }
    List<String> allLabData =[];
    final listLabCollection =  FirebaseFirestore.instance.collection("Lab List");
    Query query = listLabCollection.where(FieldPath.documentId, isEqualTo: labModelSQLite.labCode.toString());
    await query.get().then((value) {
      for (var result in value.docs) {
        var data = result.data() as Map<String, dynamic>;
        if (data["labCode"] != null) {
          allLabData.add(data["labCode"].toString());
          if (kDebugMode) {
            print(data);
          }
        }
      }

    });

    if(allLabData.isEmpty)
      {
        if (kDebugMode) {
          print("xde data : $allLabData");
        }
        return false;
      }
    else
      {
        if (kDebugMode) {
          print(" data value : $allLabData");
        }
        return true;
      }
  }


   ///get list of all equipment from specific lab
  Future<List<EquipmentLabModel>> getAllEquipmentSpecificLab(labName) async
  {
    List<EquipmentLabModel> equipmentLab = [];
    try {
      final value = await FirebaseFirestore.instance.collection(labName.toString()).get();
      for (var value in value.docs) {
        equipmentLab.add(EquipmentLabModel.fromJson(value.data()));
      }
      return equipmentLab;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error $e");
      }
      return equipmentLab;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

