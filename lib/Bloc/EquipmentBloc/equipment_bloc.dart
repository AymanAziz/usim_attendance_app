import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../DataLayer/Model/Firestore/EquipmentLabModel/EquipmentAdminModel.dart';
import '../../DataLayer/Model/Firestore/EquipmentLabModel/ListEquipmentAdminModel.dart';
import '../../DataLayer/Provider/Equipment/EquipmentProvider.dart';

part 'equipment_event.dart';
part 'equipment_state.dart';

class EquipmentBloc extends Bloc<EquipmentEvent, EquipmentState> {
  EquipmentBloc() : super(EquipmentInitial()) {
    final EquipmentAdminProvider equipmentAdminProvider = EquipmentAdminProvider();

    ///get list Equipment from specific lab
    on<GetListEquipment>((event, emit) async {
      emit(EquipmentLoading());
      final listLabValue = await equipmentAdminProvider.readEquipmentList(event.labCode);

      final value = await listLabValue;
      if(value.equipment.isEmpty)
        {
          emit(EquipmentError());
        }
      else
        {
          emit(ListEquipmentLoad( value));
        }
    });

    ///add new Equipment
    on<AddNewEquipment>((event, emit) async {
      emit(EquipmentLoading());
      await equipmentAdminProvider.addLab(event.equipmentAdminLabModel);
      // emit(AddUpdateDeleteLabLoad());
    });

    ///update Equipment
    on<UpdateEquipment>((event, emit) async {
      emit(EquipmentLoading());
      await equipmentAdminProvider.updateLab(event.equipmentAdminLabModel);
      // emit(AddUpdateDeleteLabLoad());
    });

    ///remove lab
    on<RemoveEquipment>((event, emit) async {
      emit(EquipmentLoading());
      await equipmentAdminProvider.removeLab(event.labCode,event.equipmentSeriesNo);

      ///called get list lab event again
      add(GetListEquipment(event.labCode));
    });



  }
}
