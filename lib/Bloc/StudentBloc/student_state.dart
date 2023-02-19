part of 'student_bloc.dart';

abstract class StudentState extends Equatable {
  const StudentState();
}

class StudentInitial extends StudentState {
  @override
  List<Object> get props => [];
}

class StudentLoading extends StudentState {
  @override
  List<Object> get props => [];
}
///get list student
class ListStudentLoad extends StudentState {
  final List<UserModel> listUserModel;

  const ListStudentLoad(this.listUserModel);
  @override
  List<Object> get props => [listUserModel];
}