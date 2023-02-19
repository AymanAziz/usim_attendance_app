import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../Model/Firestore/UserModel/UserModel.dart';
import '../../../Model/Sqlite/UserModel/UserModelSqlite.dart';

class UserRepository {
  CollectionReference db = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserModel userModel, String email) async{
    await db.doc(email).set({
      'name': userModel.name,
      'email': userModel.email,
      'userID': userModel.userID,
      'telNumber': userModel.telNumber,
      'isAdmin': false,
    });

    ///add to list student
    await FirebaseFirestore.instance.collection('ListStudent').doc(email).set({
      'name': userModel.name,
      'email': userModel.email,
      'userID': userModel.userID,
      'telNumber': userModel.telNumber,
      'isAdmin': false,
    });
    return;
  }

  Future<void> updateUser(UserModel userModel, String email) async{

    if( userModel.email != email)
    {
      switch(userModel.isAdmin) {
        case true:
          {
            // Get a reference to the old document
            final oldDocRef = db.doc(email);
            await oldDocRef.delete();

            // Create a new document with the desired ID
            await db.doc(userModel.email).set({
              'name': userModel.name,
              'email': userModel.email,
              'userID': userModel.userID,
              'telNumber': userModel.telNumber,
              'isAdmin': true,
            });
          }
          break;
        default:{
          // Get a reference to the old document
          final oldDocRef = db.doc(email);
          await oldDocRef.delete();

          // Create a new document with the desired ID
          await db.doc(userModel.email).set({
            'name': userModel.name,
            'email': userModel.email,
            'userID': userModel.userID,
            'telNumber': userModel.telNumber,
            'isAdmin': false,
          });
        }

      }

      return;
    }
    else
    {
      await db.doc(email).update({
        'name': userModel.name,
        'email': userModel.email,
        'telNumber': userModel.telNumber,
        'userID': userModel.userID,
        'isAdmin': userModel.isAdmin,
      });
      return;
    }

  }

  Future<UserModel?> getSpecificUser(String email1) async {
    try {

      final doc =await db.doc(email1).get();
      bool userStatus = doc["isAdmin"];
      String email = doc["email"];
      String name = doc["name"];
      String telNumber = doc["telNumber"];

      UserModel userModel1 = UserModel(
          email: email,
          isAdmin: userStatus,
          name:name,
          telNumber: telNumber
      );

      return userModel1;
    } on FirebaseException catch (e) {
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }


  }

  ///get data specific  user from Repository check if is user or not (Login.dart)
  Future checkUser(String email) async {
    var data;
    await db.doc(email).get().then((value) => {data = value.data()});
    bool userStatus = data["isAdmin"];
    if (kDebugMode) {
      print("user status: $userStatus");
    }
    return userStatus;
  }

  ///save user data for not first time user (user yg dah delete app, but ada account kt firestore)
  ///get data specific  user from Repository check if is user or not
  Future addNotFirstTimeUser(String email) async {
    var data;
    await db.doc(email).get().then((value) => {data = value.data()});
    bool isAdmin = data["isAdmin"];
    String name = data["name"];
    String telNumber = data["telNumber"];
    String userID = data["userID"];

    UserModelSqlite userModelSqlite = UserModelSqlite(
      name: name,
      email: email,
      userID: userID,
      telNumber: telNumber,
      isAdmin: isAdmin == true ?1:0,
    );
    return userModelSqlite;
  }

  Future<List<UserModel>> listUser() async{
    List<UserModel> userModel = [];
    try {
      final value = await FirebaseFirestore.instance.collection(
          "users").get();
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

}



