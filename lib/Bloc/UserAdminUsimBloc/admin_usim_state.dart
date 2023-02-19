part of 'admin_usim_bloc.dart';

abstract class AdminUsimState extends Equatable {
  const AdminUsimState();
}

class AdminInitial extends AdminUsimState {
  @override
  List<Object> get props => [];
}
class AdminLoading extends AdminUsimState {
  @override
  List<Object> get props => [];
}

///add and delete admin
class AddDeleteAdminLoad extends AdminUsimState {
  @override
  List<Object> get props => [];
}

///get list admin
class ListAdminLoad extends AdminUsimState {
  final List<UserModel> listUserModel;

  const ListAdminLoad(this.listUserModel);
  @override
  List<Object> get props => [listUserModel];
}
