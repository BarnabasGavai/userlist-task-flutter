import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mytask/models/user.dart';
import 'package:mytask/repos/repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepo userRepo;
  UserBloc(this.userRepo) : super(UserInitial()) {
    on<UserFetched>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await userRepo.getUsers();
        emit(UserSuccess(users: users));
      } catch (e) {
        UserFailure(e.toString());
      }
    });
  }
}
