import 'dart:convert';
import 'dart:io';
import '../models/response.dart';
import '../models/user.dart';

import 'package:http/http.dart' as http;

class HttpHelper {
  Future<GeneralResponse> post(String url, {Map body}) async {
    try {
      var response = await http.post(Uri.parse(url),
          body: json.encode(body),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          });
      print(response.statusCode);
      return GeneralResponse.fromJson(
          json.decode(response.body), response.statusCode);
    } catch (e) {
      throw Exception(e);
      // print(e);
    }
  }

  Future<User> fetchUser(String email, String url, String token) async {
    final response = await http.get(Uri.parse(url + email),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      return User.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}

class HttpEndPoints {
  static const String BASE_URL = "http://127.0.0.1:50061/";
  static const String GET_TEMPLATEBYID = "v1/template/getAll/";
  static const String GET_TEMPLATEMETADATA = "/v1/template/metadata/getAll";

  static const String SIGN_IN = "v1/public/user/mobile/signin";
  static const String REGISTER = "v1/public/user/register";
  static const String RESETPASSWORD = "v1/public/user/resetPassword";
  static const String GET_USER = "v1/user/get/";
  static const String GET_USERS = "v1/user/getAll/";
  static const String UPDATE_USER_BY_ID = "v1/user/update/";
}
