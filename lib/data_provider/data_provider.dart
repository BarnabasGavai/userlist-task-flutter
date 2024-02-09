import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mytask/data/my_data.dart';

class UserDataProvider {
  Future<String> loadData() async {
    try {
      final res = await http.get(Uri.parse('$API_KEY/users?page=1&limit=15'));

      var jsonResponse = res.body;

      return jsonResponse;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> updateUserData(Map user) async {
    try {
      int id = user['id'];
      String encodedData = jsonEncode(user);
      final res = await http.patch(Uri.parse("$API_KEY/users/${id}"),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: encodedData);
      if (res.statusCode == 200) {
        return "Success";
      } else {
        throw res.body;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> deleteDataUser(int id) async {
    try {
      final res = await http
          .delete(Uri.parse("$API_KEY/users/${id}"), headers: <String, String>{
        'Content-Type': 'application/json',
      });
      if (res.statusCode == 200) {
        return "Success";
      } else {
        throw res.body;
      }
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

      if (res.statusCode == 201) {
        return res.body;
      } else {
        throw res.body;
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
