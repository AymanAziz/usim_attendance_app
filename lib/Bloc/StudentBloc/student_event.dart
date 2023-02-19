part of 'student_bloc.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();
}

///Get student list
class StudentList extends StudentEvent
{
  const StudentList();
  @override
  List<Object> get props => [];
}

