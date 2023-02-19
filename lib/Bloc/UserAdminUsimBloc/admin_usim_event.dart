part of 'admin_usim_bloc.dart';

abstract class AdminUsimEvent extends Equatable {
  const AdminUsimEvent();
}

///add new admin
class AddNewAdmin extends AdminUsimEvent
{
  final String email;

  const AddNewAdmin(this.email);
  @override
  List<Object> get props => [email];
}

///remove admin
class RemoveAdmin extends AdminUsimEvent
{
  final String email;

  const RemoveAdmin(this.email);
  @override
  List<Object> get props => [email];
}

///Get admin list
class AdminList extends AdminUsimEvent
{
  const AdminList();
  @override
  List<Object> get props => [];
}

///update  admin
class UpdateAdmin extends AdminUsimEvent
{
  final UserModel userModel;

  const UpdateAdmin(this.userModel);
  @override
  List<Object> get props => [userModel];
}