
import 'package:usim_attendance_app/DataLayer/Repository/Firestore/Admin/AdminRepository.dart';
import 'package:usim_attendance_app/DataLayer/Repository/Firestore/User/UserRepository.dart';


import '../../Model/Firestore/UserModel/UserModel.dart';

class UserProvider {
  final UserRepository userRepository = UserRepository();

  // ///add admin
  // Future<void> addAdmin(String email) async {
  //   return adminRepository.addAdmin(email);
  // }
  //
  // ///remove admin
  // Future<void> removeAdmin(String email) async {
  //   return adminRepository.removeAdmin(email);
  // }

  ///display list admin
  Future<List<UserModel>> listUsers() async {
    return userRepository.listUser();
  }


}