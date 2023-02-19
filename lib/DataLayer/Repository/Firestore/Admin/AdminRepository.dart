///this page for add and remove admin from user
///admin can choose which user to be admin

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../Model/Firestore/UserModel/UserModel.dart';


class AdminRepository {
  CollectionReference dbAdmin = FirebaseFirestore.instance.collection('users');
  CollectionReference dbStudent = FirebaseFirestore.instance.collection('users');


  ///get all value from listStudent collection
  ///add that value to ListAdmin collection
  ///remove specific value from ListStudent Collection
  Future<void> addAdmin( String email) async{
    var data;
    await dbStudent.doc(email).get().then((value) => {data = value.data()});
    bool isAdmin = data!["isAdmin"];
    String name = data!["name"];
    String telNumber = data!["telNumber"];
    String userID = data!["userID"];


    ///add to list student
    await dbAdmin.doc(email).set({
      'name': name,
      'email': email,
      'userID': userID,
      'telNumber': telNumber,
      'isAdmin': true,
    });

    final oldDocRef = dbStudent.doc(email);
    await oldDocRef.delete();

    return;
  }


  ///get all value from listAdmin collection
  ///add that value to ListStudent collection
  ///remove specific value from ListAdmin Collection
  Future<void> removeAdmin( String email) async{
    var data;
    await dbAdmin.doc(email).get().then((value) => {data = value.data()});
    bool isAdmin = data!["isAdmin"];
    String name = data!["name"];
    String telNumber = data!["telNumber"];
    String userID = data!["userID"];


    ///add to list student
    await dbStudent.doc(email).set({
      'name': name,
      'email': email,
      'userID': userID,
      'telNumber': telNumber,
      'isAdmin': false,
    });

    final oldDocRef = dbAdmin.doc(email);
    await oldDocRef.delete();
    return;
  }

  ///get list admin
  Future<List<UserModel>> listAdmin( ) async{
    List<UserModel> userModel = [];
    try {
      final value = await FirebaseFirestore.instance.collection(
          "ListAdmin").get();
      for (var value in value.docs) {
        var details = value.data();
        userModel.add(UserModel.fromJson(value.data()));

      }
      return userModel;
    } on FirebaseException catch (e) {
      return userModel;
    } catch (e) {
      throw Exception(e.toString());
    }
  }



  Future<void> updateAdmin( UserModel userModel) async{
    await dbStudent.doc(userModel.email).update({
      'name': userModel.name,
      'email': userModel.email,
      'userID': userModel.userID,
      'telNumber': userModel.telNumber,
      'isAdmin': userModel.isAdmin,
    });
    return;
  }

}



