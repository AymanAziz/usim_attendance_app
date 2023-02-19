import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../Model/Sqlite/UserModel/UserModelSqlite.dart';
import '../Firestore/User/UserRepository.dart';



class SqliteDatabase
{
  static final SqliteDatabase instance = SqliteDatabase._init();
  static Database? _database;
  SqliteDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('attendance.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    ///user table
    await db.execute(' '
        ' CREATE TABLE USER(id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'name TEXT NOT NULL,'
        'phoneNumber TEXT NOT NULL,'
        'isAdmin INTEGER NOT NULL,'
        'email  TEXT NOT NULL,'
        'UserID TEXT NOT NULL)');

    /// attendance table
    await db.execute(' '
        'CREATE TABLE Attendance(id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'date TEXT NOT NULL,'
        'labName TEXT NOT NULL,' ///ADD LABNAME
        'userIdFK INTEGER NOT NULL,'
        'FOREIGN KEY (userIdFK) REFERENCES USER (id))'
        ' ');

    ///equipment table
    await db.execute(' '
        'CREATE TABLE Equipment(id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'EquipmentName TEXT NOT NULL,'
        'Reason TEXT NOT NULL,'
        'Quantity INTEGER NOT NULL,'
        'ReturnDate Text NOT NULL,'
        'userIdFK INTEGER NOT NULL,'
        'LabName Text NOT NULL,'
        'FOREIGN KEY (userIdFK) REFERENCES USER (id))'
        ' ');


  }

  Future<UserModelSqlite> getUserDetails() async {
    final db = await instance.database;

    //check email from firebase auth
    String email = FirebaseAuth.instance.currentUser!.email!;
    print("email : $email ");

    final maps = await db.rawQuery('SELECT * FROM USER WHERE email = ?',[email]);
    if (maps.isNotEmpty) {

      ///return model with user data (SQLITE)
      return UserModelSqlite.fromJSON(maps.first);
    }
    else
    {
      ///return empty model
      return const UserModelSqlite(name: '', telNumber: '', userID: '', isAdmin: 0,id: 0, email: '');
    }
  }



  ///save user data for not first time user (user yg dah delete app, but ada account kt firestore)
  ///check user status from firestore
  /// return true if student
  /// return false if admin
  Future<bool> saveUserDetails() async {
    final db = await instance.database;

    ///check email from firebase auth
    String email = FirebaseAuth.instance.currentUser!.email!;

    UserModelSqlite  userModelDetails =  await getUserDetails() ;

    if(userModelDetails.email == email)
      {
        switch (userModelDetails.isAdmin) {
          case 0:
            {
              return  false;
            }
          default:
            {
              return true;
            }
        }
      }
    else{

      UserModelSqlite  userModel = await UserRepository().addNotFirstTimeUser(email);
      switch (userModel.isAdmin) {
        case 0:
          {
            await db.rawInsert(
                'INSERT INTO USER(name, phoneNumber, UserID, isAdmin, email) VALUES( ?, ?, ?, ?, ?)',
                [
                  userModel.name,
                  userModel.telNumber,
                  userModel.userID,
                  userModel.isAdmin,
                  userModel.email,
                ]);
            return  false;
          }
        default:
          {
            await db.rawInsert(
                'INSERT INTO USER(name, phoneNumber, UserID, isAdmin, email) VALUES( ?, ?, ?, ?, ?)',
                [
                  userModel.name,
                  userModel.telNumber,
                  userModel.userID,
                  userModel.isAdmin,
                  userModel.email,
                ]);
            return true;
          }
      }
    }



  }

  Future<bool> createAttendance(currentDate,String labName) async {
    Database db = await instance.database;

    ///get user details from sqlite
    /// find attendance from specific user
    UserModelSqlite  userModel = await getUserDetails();
    final maps = await db.rawQuery('SELECT * FROM Attendance  INNER JOIN USER ON Attendance.userIdFK = USER.id  WHERE date = ? AND USER.id = ? AND labName = ?',[currentDate, userModel.id,labName]);

    ///save to db if empty
    ///return true if it empty
    if (maps.isEmpty) {

      await db.rawInsert(
          'INSERT INTO Attendance(date,labName, userIdFK) VALUES( ?, ?, ?)',
          [
            currentDate,
            labName,
            userModel.id,
          ]);

      return true;
    }
    else
    {
      return false;
    }

  }


  ///student get list attendance
  Future<List<UserModelSqlite>> getAttendanceList() async {
    final db = await instance.database;
    UserModelSqlite  userModel = await getUserDetails();
    final maps = await db.rawQuery('SELECT * FROM Attendance INNER JOIN USER ON Attendance.userIdFK = USER.id   WHERE USER.id = ?  ORDER BY Id DESC',[userModel.id]);
    return maps.map((e) => UserModelSqlite.fromJSON(e)).toList();
  }


  ///execute after user press the submit button in ComfirmCartScreen.dart
  ///save to sqlite for user
  // Future addEquipmentLocalDbAndFirestore(List<CartSQLite> cartSQLite) async
  // {
  //   final db = await instance.database;
  //   String email = FirebaseAuth.instance.currentUser!.email!;
  //   userModelSQLite reminderResponse;
  //
  //   final maps = await db.rawQuery('SELECT * FROM USER WHERE email = ?',[email]);
  //   reminderResponse = userModelSQLite.fromJSON(maps.first);
  //   cartSQLite.asMap().forEach((key, value) async {
  //
  //
  //     await db.rawInsert(
  //         'INSERT INTO Equipment(EquipmentName,Reason, Quantity, ReturnDate,LabName,UserId) VALUES( ?, ?, ?,?, ?, ?)',
  //         [
  //           value.equipmentName,
  //           value.reason,
  //           value.quantity,
  //           value.returnDate,
  //           value.labName,
  //           reminderResponse.id,
  //         ]);
  //
  //   });
  //
  // }


  ///get student current date attendance (for Successful page after scan qr-code)
  // Future<UserModelSqlite> getCurrentDateAttendanceData(String labName) async
  // {
  //   ///get current date
  //   final DateFormat formatter = DateFormat('yyyy-MM-dd');
  //   DateTime startDate = DateTime.now();
  //   var selectDateDatabase = formatter.format(startDate!);
  //
  //
  //   final db = await instance.database;
  //   userModelSQLite  userModel = await getUserDetails();
  //   final maps = await db.rawQuery('SELECT * FROM Attendance INNER JOIN USER ON Attendance.userId = USER.id   WHERE USER.id = ? AND date= ? AND labName= ?  LIMIT 1',[userModel.id,selectDateDatabase,labName]);
  //   return maps.map((e) => AttendanceSQLite.fromJSON(e)).first;
  // }


  Future createUser(UserModelSqlite reminder) async {
    Database db = await instance.database;
    UserModelSqlite reminderResponse;
    //check email from firebase auth
    String email = FirebaseAuth.instance.currentUser?.email! ?? "0";

    //check email from FireStore
    if(email == "0")
    {
      //insert to Medicine table
      await db.rawInsert(
          'INSERT INTO USER(name, phoneNumber, UserID, isAdmin, email) VALUES( ?, ?, ?, ?, ?)',
          [
            reminder.name,
            reminder.telNumber,
            reminder.userID,
            reminder.isAdmin,
            reminder.email,
          ]);
    }
    else
    {
      final maps = await db.rawQuery(
          'SELECT * FROM USER WHERE email = ?', [reminder.email]);
      if(maps.isEmpty)
      {
        //insert to Medicine table
        await db.rawInsert(
            'INSERT INTO USER(name, phoneNumber, UserID, isAdmin, email) VALUES( ?, ?, ?, ?, ?)',
            [
              reminder.name,
              reminder.telNumber,
              reminder.userID,
              reminder.isAdmin,
              email,
            ]);
      }
      else
      {
        reminderResponse = UserModelSqlite.fromJSON(maps.first);
        await db.rawUpdate(
            'UPDATE USER SET name = ?, phoneNumber = ?, UserID = ?, isAdmin = ?, email = ?  WHERE id = ?',[
          reminder.name,
          reminder.telNumber,
          reminder.userID,
          reminder.isAdmin,
          reminder.email,
          reminderResponse.id

        ]);

      }
    }


  }
}