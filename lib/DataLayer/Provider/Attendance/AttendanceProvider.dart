import '../../Model/Firestore/EquipmentLabModel/EquipmentLabModel.dart';
import '../../Model/Sqlite/AttendanceModel/AttendanceModel.dart';
import '../../Model/Sqlite/UserModel/UserModelSqlite.dart';
import '../../Repository/Firestore/AttendanceRepository/AttendanceRepository.dart';
import '../../Repository/Sqlite/SqliteRepository.dart';

class AttendanceDbProvider {
  final AttendanceRepository attendanceRepository = AttendanceRepository();
  SqliteDatabase sqliteDatabase = SqliteDatabase.instance;

  //get attendance
  Future addUserDataToday() async {
    return attendanceRepository.getAttendance();
  }
  //get attendance
  Future<int> countUser() async {
    return attendanceRepository.countUser();
  }

  Future addAttendance(String labName) async {
    return attendanceRepository.addAttendanceUser(labName);
  }

  /// get lab list after user scan the qr code
  /// check if qr code is valid or not
  Future getListLab(labModel) async {
    return attendanceRepository.getLabListFirestore(labModel);
  }

  Future<List<UserModelSqlite>> getListAttendanceUser() async {
    return sqliteDatabase.getAttendanceList();
  }


  Future<UserModelSqlite> getCurrentDateAttendanceData(String labName) async {
    return sqliteDatabase.getCurrentDateAttendanceData(labName);
  }

  Future<List<EquipmentLabModel>> getAllEquipmentSpecificLab(labName) async{
    return attendanceRepository.getAllEquipmentSpecificLab(labName);
  }

}