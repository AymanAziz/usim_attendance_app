import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../DataLayer/Model/Firestore/EquipmentLabModel/EquipmentLabModel.dart';
import '../../DataLayer/Model/Sqlite/LabModel/LabModel.dart';
import '../../DataLayer/Provider/Attendance/AttendanceProvider.dart';


part 'get_list_lab_event.dart';
part 'get_list_lab_state.dart';

class GetListLabBloc extends Bloc<GetListLabEvent, GetListLabState> {
  GetListLabBloc() : super(GetListLabInitial()) {
    final AttendanceDbProvider attendanceDbProvider = AttendanceDbProvider();

    on<RequestListLab>((event, emit) async {

      ///yg ni nk check list lab kt db
      final value = await attendanceDbProvider.getListLab(event.labModelSQLite);

      switch (value) {
        case true:
          await attendanceDbProvider.addAttendance(event.labModelSQLite.labCode);
          break;
        default:
      }

      emit(ListLabLoaded(value));
    });


    on<GetListLabListEquipment>((event, emit) async {
      final value = await attendanceDbProvider.getAllEquipmentSpecificLab(event.labName);
      emit(ListLabEquipmentLoaded(value));
    });

  }
}
