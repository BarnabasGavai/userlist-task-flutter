part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

final class InitialLoad extends UserEvent {}

final class UserFetched extends UserEvent {}

final class FetchMore extends UserEvent {}

final class DeleteUser extends UserEvent {
  String id;
  DeleteUser({required this.id});
}

final class AddUser extends UserEvent {
  String name;
  String gender;
  String phone;
  String email;
  String address;
  String state;
  String city;

  AddUser(
      {required this.name,
      required this.address,
      required this.city,
      required this.email,
      required this.gender,
      required this.phone,
      required this.state});
}

final class UpdateUser extends UserEvent {
  String id;
  String name;
  String gender;
  String phone;
  String email;
  String address;
  String state;
  String city;

  UpdateUser(
      {required this.id,
      required this.name,
      required this.address,
      required this.city,
      required this.email,
      required this.gender,
      required this.phone,
      required this.state});
}
