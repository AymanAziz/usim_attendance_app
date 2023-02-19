import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../DataLayer/Model/Firestore/UserModel/UserModel.dart';
import '../../DataLayer/Provider/Admin/AdminProvider.dart';

part 'admin_usim_event.dart';
part 'admin_usim_state.dart';

class AdminUsimBloc extends Bloc<AdminUsimEvent, AdminUsimState> {
  AdminUsimBloc() : super(AdminInitial()) {
    final AdminProvider adminProvider = AdminProvider();

    ///get list Admin
    on<AdminList>((event, emit) async {
      emit(AdminLoading());
      final listLabValue = await adminProvider.listAdmin();
      emit(ListAdminLoad(listLabValue));
    });

    ///add  Admin
    on<AddNewAdmin>((event, emit) async {
      emit(AdminLoading());
       await adminProvider.addAdmin(event.email);
      emit(AddDeleteAdminLoad());
    });

    ///remove  Admin
    on<RemoveAdmin>((event, emit) async {
      emit(AdminLoading());
       await adminProvider.removeAdmin(event.email);
      emit(AddDeleteAdminLoad());
    });

    ///update  Admin
    on<UpdateAdmin>((event, emit) async {
    emit(AdminLoading());
    await adminProvider.updateAdmin(event.userModel);
    // emit(AddDeleteAdminLoad());
  });

  }
}
