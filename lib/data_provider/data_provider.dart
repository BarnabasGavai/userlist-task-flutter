import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class UserDataProvider {
  Future<String> getUserData() async {
    String fileName = "userdata.json";

    var dir = await getTemporaryDirectory();

    File file = File("${dir.path}/$fileName");
    if (file.existsSync()) {
      var jsonData = file.readAsStringSync();
      return jsonData;
    } else {
      try {
        final res = await http.get(Uri.parse(
            'https://65bfa18a25a83926ab956096.mockapi.io/users?page=1&limit=15'));

        var jsonResponse = res.body;
        file.writeAsStringSync(jsonResponse, flush: true, mode: FileMode.write);
        return jsonResponse;
      } catch (e) {
        throw e.toString();
      }
    }
  }

  Future<String> moreData(int page) async {
    String fileName = "userdata.json";

    var dir = await getTemporaryDirectory();

    File file = File("${dir.path}/$fileName");

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
      throw e.toString();
    }
  }

  Future<String> createUser(Map data) async {
    try {
      final res =
          await http.post(Uri.parse("https://gorest.co.in/public/v2/users"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(data));

      return "Success";
    } catch (e) {
      throw e.toString();
    }
  }
}
