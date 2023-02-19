import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../DataLayer/Model/Firestore/LabModel/LabModel.dart';
import '../../../DataLayer/Model/Firestore/UserModel/UserModel.dart';
import '../../../DataLayer/Provider/Admin/AdminProvider.dart';
import '../../../DataLayer/Provider/Lab/LabProvider.dart';
import '../../../DataLayer/Provider/Student/StudentProvider.dart';
import '../../../DataLayer/Provider/User/UserProvider.dart';

part 'main_page_admin_event.dart';
part 'main_page_admin_state.dart';

class MainPageAdminBloc extends Bloc<MainPageAdminEvent, MainPageAdminState> {
  MainPageAdminBloc() : super(MainPageAdminInitial()) {
    final UserProvider userProvider = UserProvider();
    final LabProvider labProvider = LabProvider();


    on<MainPageBloc>((event, emit) async {
      emit(MainPageAdminLoading());

      final listLabValue = await labProvider.listLab();
      final listUsersValue = await userProvider.listUsers();

      emit( MainPageLoad(listUsersValue,listLabValue));

    });
  }
}
