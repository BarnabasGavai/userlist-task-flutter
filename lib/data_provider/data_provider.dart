import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mytask/data/my_data.dart';
import 'package:path_provider/path_provider.dart';

class UserDataProvider {
  Future<String> loadData() async {
    try {
      final res = await http.get(Uri.parse(
          'https://65bfa18a25a83926ab956096.mockapi.io/users?page=1&limit=15'));

      var jsonResponse = res.body;

      return jsonResponse;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> updateUserData(Map user) async {
    try {
      String id = user['id'];
      String encodedData = jsonEncode(user);
      final res = await http.patch(Uri.parse("$API_KEY/users/${id}"),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: encodedData);

      return "Success";
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> deleteDataUser(String id) async {
    try {
      final res = await http
          .delete(Uri.parse("$API_KEY/users/${id}"), headers: <String, String>{
        'Content-Type': 'application/json',
      });
      return "Success";
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> moreData(int page) async {
    try {
      final res =
          await http.get(Uri.parse('$API_KEY/users?page=${page}&limit=15'));

      var jsonResponse = res.body;

      return jsonResponse;
    } catch (e) {
      return ('error from provider : ${e.toString()}');
    }
  }

  Future<String> createUser(Map data) async {
    try {
      String encodedData = jsonEncode(data);
      final res = await http.post(Uri.parse("$API_KEY/users"),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: encodedData);

      return "Success";
    } catch (e) {
      throw e.toString();
    }
  }
}
