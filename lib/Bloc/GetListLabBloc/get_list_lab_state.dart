part of 'get_list_lab_bloc.dart';

abstract class GetListLabState extends Equatable {
  const GetListLabState();
}

class GetListLabInitial extends GetListLabState {
  @override
  List<Object> get props => [];
}

class ListLabLoading extends GetListLabState
{
  @override
  List<Object> get props => [];
}

///retrive all list lab
class ListLabLoaded extends GetListLabState
{
  final bool value;

  const ListLabLoaded( this.value);

  @override
  List<Object> get props => [this.value];
}


///retrive all equipment from specific lab
class ListLabEquipmentLoaded extends GetListLabState
{
  final List<EquipmentLabModel> value;

  const ListLabEquipmentLoaded( this.value);

  @override
  List<Object> get props => [value];
}

