import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:usim_attendance_app/DataLayer/Provider/Lab/LabProvider.dart';

import '../../DataLayer/Model/Firestore/LabModel/LabModel.dart';

part 'lab_event.dart';
part 'lab_state.dart';

class LabBloc extends Bloc<LabEvent, LabState> {
  LabBloc() : super(LabInitial()) {

    final LabProvider labProvider = LabProvider();
    ///get list lab
    on<GetListLab>((event, emit) async {
      emit(LabLoading());
       final listLabValue = await labProvider.listLab();
       emit(ListLabLoad(listLabValue));
    });

    ///add new lab
    on<AddNewLab>((event, emit) async {
      emit(LabLoading());
     await labProvider.addLab(event.labModel);
      emit(AddUpdateDeleteLabLoad());
    });

    ///update lab
    on<UpdateLab>((event, emit) async {
      emit(LabLoading());
      await labProvider.updateLab(event.labModel);
      emit(AddUpdateDeleteLabLoad());
    });

    ///remove lab
    on<RemoveLab>((event, emit) async {
      emit(LabLoading());
      await labProvider.removeLab(event.labCode);

      ///called get list lab event again
      add(GetListLab());

    });

  }
}
