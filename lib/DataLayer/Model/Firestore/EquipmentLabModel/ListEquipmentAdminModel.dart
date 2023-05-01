class EquipmentListModel {
  List<String> equipment;

  EquipmentListModel({
    required this.equipment,
  });

  Map<String, dynamic> toMap() {
    return {
      'Equipment': equipment,
    };
  }

  factory EquipmentListModel.fromJson(Map<String, dynamic> json) {
    return EquipmentListModel(
      equipment: List<String>.from(json['Equipment']),
    );
  }
}
