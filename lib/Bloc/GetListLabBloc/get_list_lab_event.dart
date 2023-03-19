part of 'get_list_lab_bloc.dart';

abstract class GetListLabEvent extends Equatable {
  const GetListLabEvent();
}
class RequestListLab extends GetListLabEvent
{
   // final LabModel _labModel;
   // const RequestListLab(this._labModel);

   final LabModelSQLite labModelSQLite ;
   const RequestListLab(this.labModelSQLite);
  @override
  List<Object> get props => [];
}

class GetListLabListEquipment extends GetListLabEvent
{
  final String labName ;
  const GetListLabListEquipment(this.labName);
  @override
  List<Object> get props => [labName];
}

