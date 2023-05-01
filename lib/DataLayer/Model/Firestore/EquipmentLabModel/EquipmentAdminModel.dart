class EquipmentAdminLabModel {
  String? equipmentName;
  String? equipmentLink;
  String? equipmentSeriesNo;
  String? labId;
  int? quantity;

  EquipmentAdminLabModel({
    this.equipmentName,
    this.equipmentLink,
    this.equipmentSeriesNo,
    this.labId,
    this.quantity,
  });

  // save data to firebase
  Map<String, dynamic> toMap() {
    return {
      'EquipmentName': equipmentName,
      'EquipmentLink': equipmentLink,
      'EquipmentSeriesNo': equipmentSeriesNo,
      'LabId': labId,
      'Quantity': quantity,
    };
  }

  // get data from firestore
  static EquipmentAdminLabModel fromJson(Map<String, dynamic> json) =>
      EquipmentAdminLabModel(
        equipmentName: json['EquipmentName'],
        equipmentLink: json['EquipmentLink'],
        equipmentSeriesNo: json['EquipmentSeriesNo'],
        labId: json['LabId'],
        quantity: json['Quantity'],
      );
}
