import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mytask/models/user.dart';
import 'package:mytask/repos/repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  int page = 1;
  List<User> users = [];
  final UserRepo userRepo;
  UserBloc(this.userRepo) : super(UserInitial()) {
    on<UserFetched>((event, emit) async {
      emit(UserLoading());
      try {
        users = await userRepo.getUsers();
        emit(UserSuccess(users: users, hasData: true));
      } catch (e) {
        UserFailure(e.toString());
      }
    });

    on<FetchMore>((event, emit) async {
      if (state is LoadingMore) {
      } else {
        emit(LoadingMore(users: users));
        try {
          users = await userRepo.moreUsers(page + 1);

          if (users.length == page + 1 * 15) {
            emit(UserSuccess(users: users, hasData: true));
          } else {
            emit(UserSuccess(users: users, hasData: false));
          }

          page = page + 1;
        } catch (e) {
          throw e.toString();
        }
      }
    });
  }
}
