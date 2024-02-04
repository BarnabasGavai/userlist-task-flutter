part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UserSuccess extends UserState {
  bool hasData;
  final List<User> users;

  UserSuccess({required this.users, required this.hasData});
}

final class UserFailure extends UserState {
  final String error;

  UserFailure(this.error);
}

final class UserLoading extends UserState {}

final class LoadingMore extends UserState {
  final List<User> users;
  const LoadingMore({required this.users});
}
