
import 'package:equatable/equatable.dart';

/// model for add cart user SQLITE
class CartSQLite extends Equatable {
  final int? id;
  final String equipmentName;
  final int quantity;
  final String reason;
  final String returnDate;
  final String labName;

  const CartSQLite(
      {this.id,
        required this.equipmentName,
        required this.quantity,
        required this.reason,
        required this.returnDate,
        required this.labName,
      });

  Map<String, dynamic> toMap() {
    return {
      'EquipmentName': equipmentName,
      'Reason': reason,
      'id': id,
      'ReturnDate': returnDate,
      'Quantity':quantity,
      'LabName':labName,
    };
  }

///get data from Repository
  static CartSQLite fromJSON(Map<String, Object?> json) => CartSQLite(
      equipmentName: json['EquipmentName'] as String,
      reason: json['Reason'] as String,
      returnDate: json['ReturnDate'] as String,
      labName: json['LabName'] as String,
      quantity: json['Quantity'] as int,
      id: json['id'] as int?);

  @override
// TODO: implement props
  List<Object?> get props =>
      [id, equipmentName,reason,returnDate,quantity,labName];
}