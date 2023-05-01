part of 'equipment_bloc.dart';

abstract class EquipmentState extends Equatable {
  const EquipmentState();
}

class EquipmentInitial extends EquipmentState {
  @override
  List<Object> get props => [];
}

class EquipmentLoading extends EquipmentState {
  @override
  List<Object> get props => [];
}

class EquipmentError extends EquipmentState {
  @override
  List<Object> get props => [];
}

///display list Equipment
class ListEquipmentLoad extends EquipmentState {
  final EquipmentListModel listEquipmentModel;

  const ListEquipmentLoad( this.listEquipmentModel);

  @override
  List<Object> get props => [listEquipmentModel];
}

///add delete update Equipment
class AddUpdateDeleteEquipmentLoad extends EquipmentState {

  @override
  List<Object> get props => [];
}
