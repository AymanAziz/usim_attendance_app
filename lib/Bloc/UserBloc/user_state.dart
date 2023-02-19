part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState{
  @override
  List<Object?> get props => [];
}

class UserLoaded extends UserState{
  final UserModel userdata;
  const UserLoaded(this.userdata);

  @override
  List<Object?> get props => [userdata];
}

class UserListLoaded extends UserState
{
  final List<UserModel> listUser;
  const UserListLoaded(this.listUser);

  @override
  List<Object?> get props => [listUser];
}