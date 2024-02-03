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
        final res =
            await http.get(Uri.parse('https://gorest.co.in/public/v2/users'));

        var jsonResponse = res.body;
        file.writeAsStringSync(jsonResponse, flush: true, mode: FileMode.write);
        return jsonResponse;
      } catch (e) {
        throw e.toString();
      }
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
