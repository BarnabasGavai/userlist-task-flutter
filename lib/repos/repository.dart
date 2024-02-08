import 'dart:convert';
import 'package:mytask/data_provider/data_provider.dart';
import '../models/user.dart';

class UserRepo {
  final UserDataProvider userDataProvider;
  UserRepo(this.userDataProvider);

  Future<List<User>> initialData() async {
    try {
      List<User> users = [];
      final usersdata = await userDataProvider.loadData();

      final jsonusers = jsonDecode(usersdata);
      for (var element in jsonusers) {
        users.add(User.fromMap(element));
      }

      return users;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> updateCurrUser(User user) async {
    try {
      Map data = user.toMap();
      String response = await userDataProvider.updateUserData(data);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> deleteCurrUser(String id) async {
    try {
      final res = await userDataProvider.deleteDataUser(id);
      return res;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<User>> moreUsers(int page) async {
    try {
      List<User> users = [];
      final userdata = await userDataProvider.moreData(page);

      final jsonusers = jsonDecode(userdata);
      for (var element in jsonusers) {
        users.add(User.fromMap(element));
      }

      return users;
    } catch (e) {
      throw "error from repo: ${e.toString()}";
    }
  }

  Future<String> newUser(User newuser) async {
    try {
      Map data = newuser.toMap();
      String response = await userDataProvider.createUser(data);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
