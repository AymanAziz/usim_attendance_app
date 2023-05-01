part of 'equipment_bloc.dart';

abstract class EquipmentEvent extends Equatable {
  const EquipmentEvent();
}

///call to get a list of equipment
class GetListEquipment extends EquipmentEvent
{
  final String labCode;
  const GetListEquipment(this.labCode);
  @override
  List<Object> get props => [labCode];

}

///add new equipment
class AddNewEquipment extends EquipmentEvent
{
  final EquipmentAdminLabModel equipmentAdminLabModel;

  const AddNewEquipment(this.equipmentAdminLabModel);
  @override
  List<Object> get props => [equipmentAdminLabModel];
}

///update equipment
class UpdateEquipment extends EquipmentEvent
{
  final EquipmentAdminLabModel equipmentAdminLabModel;

  const UpdateEquipment(this.equipmentAdminLabModel);
  @override
  List<Object> get props => [equipmentAdminLabModel];
}

///remove equipment
class RemoveEquipment extends EquipmentEvent
{
  final String labCode;
  final String equipmentSeriesNo;

  const RemoveEquipment(this.labCode, this.equipmentSeriesNo);
  @override
  List<Object> get props => [labCode,equipmentSeriesNo];
}
