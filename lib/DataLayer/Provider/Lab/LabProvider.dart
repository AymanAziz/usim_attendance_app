
import '../../Model/Firestore/LabModel/LabModel.dart';
import '../../Repository/Firestore/Lab/LabRepository.dart';

class LabProvider {
  final LabRepository labRepository = LabRepository();

  ///add lab
  Future<void> addLab(LabModel labModel) async {
    return labRepository.addLab(labModel);
  }

  ///update lab
  Future<void> updateLab(LabModel labModel) async {
    return labRepository.updateLab(labModel);
  }

  ///remove lab
  Future<void> removeLab(String labCode) async {
    return labRepository.removeLab(labCode);
  }

  ///display list lab
  Future<List<LabModel>> listLab() async {
    return labRepository.listLab();
  }


}