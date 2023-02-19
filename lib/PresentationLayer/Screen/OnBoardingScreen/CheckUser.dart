import 'package:flutter/material.dart';
import 'package:usim_attendance_app/PresentationLayer/Screen/Authentication/Login.dart';

import '../../../DataLayer/Repository/Sqlite/SqliteRepository.dart';
import '../Admin/NavBar/NavBarAdmin.dart';
import '../User/NavBar/NavBarStudent.dart';

/// check user kt firebase and local
/// return true if student
/// return false if admin

Future checkUser(context)
async {
  final sQLiteDb = SqliteDatabase.instance;
      bool checkAdmin = await sQLiteDb.saveUserDetails();

      switch(checkAdmin) {
        case true:
          {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const NavBarAdmin()));
          }
          break;

        default:
          {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const NavBarStudent()));
          }
      }


}