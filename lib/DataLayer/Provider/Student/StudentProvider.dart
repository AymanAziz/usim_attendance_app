
import 'package:usim_attendance_app/DataLayer/Repository/Firestore/Admin/AdminRepository.dart';


import '../../Model/Firestore/UserModel/UserModel.dart';
import '../../Repository/Firestore/Student/StudentRepository.dart';

class StudentProvider {
  final StudentRepository adminRepository = StudentRepository();

  ///display list student
  Future<List<UserModel>> listStudent() async {
    return adminRepository.listStudent();
  }


}