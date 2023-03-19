import 'package:equatable/equatable.dart';

class LabModelSQLite extends Equatable {
  final String labCode;

  const LabModelSQLite(
      {
        required this.labCode,
      });

  Map<String, dynamic> toMap() {
    return {
      'username': labCode,
    };
  }

///get data from Repository
  static LabModelSQLite fromJSON(Map<String, Object?> json) => LabModelSQLite(
    labCode: json['name'] as String,);

  @override
// TODO: implement props
  List<Object?> get props =>
      [ labCode];
}