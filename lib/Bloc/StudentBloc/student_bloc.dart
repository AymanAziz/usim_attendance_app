import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../DataLayer/Model/Firestore/UserModel/UserModel.dart';
import '../../DataLayer/Provider/Student/StudentProvider.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentInitial()) {
    final StudentProvider studentProvider = StudentProvider();

    ///get list Student
    on<StudentList>((event, emit) async {
      emit(StudentLoading());
      final listLabValue = await studentProvider.listStudent();
      emit(ListStudentLoad(listLabValue));
    });

  }
}
