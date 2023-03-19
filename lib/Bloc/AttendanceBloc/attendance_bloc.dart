import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../DataLayer/Model/Sqlite/AttendanceModel/AttendanceModel.dart';
import '../../DataLayer/Model/Sqlite/UserModel/UserModelSqlite.dart';
import '../../DataLayer/Provider/Attendance/AttendanceProvider.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceBloc() : super(AttendanceInitial()) {
    final AttendanceDbProvider attendanceDbProvider = AttendanceDbProvider();

    on<AddAttendanceUser>((event, emit) async {
      await attendanceDbProvider.addAttendance(event.labName);
      // emit(UserLoaded(userdata));
    });



    on<GetListAttendanceUser>((event, emit) async {
      emit(AttendanceLoading());
     final attendanceList = await attendanceDbProvider.getListAttendanceUser();
     emit(AttendanceListLoaded(attendanceList));
    });

    ///get attendance current date
    on<GetAttendanceData>((event, emit) async {
      emit(AttendanceLoading());
      final attendance = await attendanceDbProvider.getCurrentDateAttendanceData(event.labName);
      emit(AttendanceCurrentDateLoaded(attendance));
    });

  }
}
