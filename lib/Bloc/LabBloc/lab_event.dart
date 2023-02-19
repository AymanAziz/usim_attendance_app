part of 'lab_bloc.dart';

abstract class LabEvent extends Equatable {
  const LabEvent();
}

///call to get a list of lab
class GetListLab extends LabEvent
{
  @override
  List<Object> get props => [];
}

///add new lab
class AddNewLab extends LabEvent
{
  final LabModel labModel;

  const AddNewLab(this.labModel);
  @override
  List<Object> get props => [labModel];
}

///update lab
class UpdateLab extends LabEvent
{
  final LabModel labModel;

  const UpdateLab(this.labModel);
  @override
  List<Object> get props => [labModel];
}

///remove lab
class RemoveLab extends LabEvent
{
  final String labCode;

  const RemoveLab(this.labCode);
  @override
  List<Object> get props => [labCode];
}
