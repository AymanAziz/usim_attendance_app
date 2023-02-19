part of 'lab_bloc.dart';

abstract class LabState extends Equatable {
  const LabState();
}

class LabInitial extends LabState {
  @override
  List<Object> get props => [];
}

class LabLoading extends LabState {
  @override
  List<Object> get props => [];
}


///display list lab
class ListLabLoad extends LabState {
  final List<LabModel> listLabModel;

  const ListLabLoad( this.listLabModel);

  @override
  List<Object> get props => [listLabModel];
}

///add delete update lab
class AddUpdateDeleteLabLoad extends LabState {

  @override
  List<Object> get props => [];
}
