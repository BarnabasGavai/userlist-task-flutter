import 'dart:convert';
import 'package:mytask/data_provider/data_provider.dart';
import '../models/user.dart';

class UserRepo {
  final UserDataProvider userDataProvider;
  UserRepo(this.userDataProvider);

  Future<List<User>> getUsers() async {
    try {
      List<User> users = [];
      final usersdata = await userDataProvider.getUserData();

      final jsonusers = jsonDecode(usersdata);
      for (var element in jsonusers) {
        users.add(User.fromMap(element));
      }

      return users;
    } catch (e) {
      throw e.toString();
    }
  }
}
