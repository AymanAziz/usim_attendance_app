part of 'main_page_admin_bloc.dart';

abstract class MainPageAdminState extends Equatable {
  const MainPageAdminState();
}

class MainPageAdminInitial extends MainPageAdminState {
  @override
  List<Object> get props => [];
}

class MainPageAdminLoading extends MainPageAdminState {
  @override
  List<Object> get props => [];
}

///get list admin , lab and student
class MainPageLoad extends MainPageAdminState {
  final List<UserModel> listUsersValue;
  final List<LabModel> listLabModel;

  const MainPageLoad(this.listUsersValue,this.listLabModel);
  @override
  List<Object> get props => [listUsersValue,listLabModel];
}