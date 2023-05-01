
import 'package:usim_attendance_app/DataLayer/Model/Firestore/EquipmentLabModel/ListEquipmentAdminModel.dart';

import '../../Model/Firestore/EquipmentLabModel/EquipmentAdminModel.dart';
import '../../Repository/Firestore/Equipment/EquipemtnRepository.dart';


class EquipmentAdminProvider {
  final EquipmentRepository equipmentRepository = EquipmentRepository();

  ///add Equipment
  Future<void> addLab(EquipmentAdminLabModel equipmentAdminLabModel) async {
    return equipmentRepository.addLab(equipmentAdminLabModel);
  }

  ///update Equipment
  Future<void> updateLab(EquipmentAdminLabModel equipmentAdminLabModel) async {
    return equipmentRepository.updateLab(equipmentAdminLabModel);
  }

  ///remove Equipment
  Future<void> removeLab(String labId, String equipmentSeriesNo) async {
    return equipmentRepository.deleteLab(labId,  equipmentSeriesNo);
  }

  ///display list lab
  Future<Future<EquipmentListModel>> readEquipmentList(String labId) async {
    return equipmentRepository.readEquipmentList(labId);
  }


}