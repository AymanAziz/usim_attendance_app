import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../DataLayer/Model/Firestore/UserModel/UserModel.dart';
import '../../DataLayer/Repository/Firestore/User/UserRepository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    final UserRepository  userRepository = UserRepository();

    on<CreateUser>((event, emit) async {
      await userRepository.addUser(event.userModel, event.email);
    });

    on<UpdateUser>((event, emit) async {
      await userRepository.updateUser(event.userModel, event.email);
    });

    on<GetUser>((event, emit) async {
      emit(UserLoading());
      final userdata = await userRepository.getSpecificUser(event.email);
      emit(UserLoaded(userdata!));
    });

    on<GetListUser>((event , emit) async {
      emit(UserLoading());
      final userList = await userRepository.listUser();
      emit(UserListLoaded(userList));
    });

  }
}
