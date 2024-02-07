import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class UserDataProvider {
  Future<String> loadData() async {
    String fileName = "userdata.json";
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$fileName");
    try {
      final res = await http.get(Uri.parse(
          'https://65bfa18a25a83926ab956096.mockapi.io/users?page=1&limit=15'));

      var jsonResponse = res.body;

      file.writeAsStringSync(jsonResponse, flush: true, mode: FileMode.write);
      return jsonResponse;
    } catch (e) {
      String data = file.readAsStringSync();
      if (data.isEmpty || data == null) {
        file.writeAsStringSync("", flush: true, mode: FileMode.write);
      }
      return file.readAsStringSync();
    }
  }

  Future<String> getUserData() async {
    var dir = await getApplicationDocumentsDirectory();

    File file = File("${dir.path}/userdata.json");

    var data = file.readAsStringSync();
    return data;
  }

  Future<String> moreData(int page) async {
    var dir = await getApplicationDocumentsDirectory();

    File file = File("${dir.path}/userdata.json");

    try {
      final res = await http.get(Uri.parse(
          'https://65bfa18a25a83926ab956096.mockapi.io/users?page=${page}&limit=15'));

      var jsonResponse = res.body;

      var storedData = file.readAsStringSync();
      storedData = storedData.substring(0, storedData.length - 1);
      jsonResponse = jsonResponse.substring(1);
      String newData = "${storedData},${jsonResponse}";
      if (newData.endsWith(",]")) {
        newData = newData.substring(0, (newData.length - 2));
        newData = "$newData]";
      }
      file.writeAsStringSync(newData, flush: true, mode: FileMode.write);

      return newData;
    } catch (e) {
      return ('error from provider : ${e.toString()}');
    }
  }

  Future<String> createUser(Map data) async {
    try {
      String encodedData = jsonEncode(data);
      final res = await http.post(
          Uri.parse("https://65bfa18a25a83926ab956096.mockapi.io/users"),
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
