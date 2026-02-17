import 'dart:convert';

import 'package:democlass/user_data_response.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  String baseUrl = "https://randomuser.me/api/";

  Future<UserDataResponse> getRandomUserData() async {
    var url = Uri.parse(baseUrl);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      final jsonData = jsonDecode(response.body);
      return UserDataResponse.fromJson(jsonData);
    } else {
      throw Exception("Failed to load user data");
    }
  }

  Future<User> getUser() async {
    var url = Uri.parse(baseUrl);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      final jsonData = jsonDecode(response.body);
      return User(
        name: jsonData["results"][0]["name"]["first"] ?? "",
        phone: jsonData["results"][0]["phone"],
        location: jsonData["results"][0]["location"]["city"],
        prrofileImage: jsonData["results"][0]["picture"]["medium"],
      );
    } else {
      throw Exception("Failed to load user data");
    }
  }
}
