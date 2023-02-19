
import 'package:usim_attendance_app/DataLayer/Repository/Firestore/Admin/AdminRepository.dart';


import '../../Model/Firestore/UserModel/UserModel.dart';

class AdminProvider {
  final AdminRepository adminRepository = AdminRepository();

  ///add admin
  Future<void> addAdmin(String email) async {
    return adminRepository.addAdmin(email);
  }

  ///remove admin
  Future<void> removeAdmin(String email) async {
    return adminRepository.removeAdmin(email);
  }

  ///display list admin
  Future<List<UserModel>> listAdmin() async {
    return adminRepository.listAdmin();
  }

  ///update user
  Future<void> updateAdmin(UserModel userModel) async {
    return adminRepository.updateAdmin(userModel);
  }

}