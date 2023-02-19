///this page for add and remove admin from user
///admin can choose which user to be admin

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Model/Firestore/UserModel/UserModel.dart';


class StudentRepository {

  ///get list Student
  Future<List<UserModel>> listStudent( ) async{
    List<UserModel> userModel = [];
    try {
      final value = await FirebaseFirestore.instance.collection(
          "ListStudent").get();
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



