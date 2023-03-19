part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceEvent {
  @override
  List<Object> get props => [];
}
class GetAttendanceData extends AttendanceEvent {
  final String labName ;
  GetAttendanceData(this.labName);
  @override
  List<Object> get props => [labName];
}

class AddAttendanceUser extends AttendanceEvent
{
  final String labName ;
   AddAttendanceUser(this.labName);
  @override
  List<Object> get props => [labName];
}

class GetListAttendanceUser extends AttendanceEvent
{}



