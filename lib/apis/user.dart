import '../helpers/httphelper.dart';
import 'endpoints.dart';
import 'dart:convert';
import 'dart:io';
import '../models/response.dart';
import '../models/user.dart' as user_model;
import 'package:http/http.dart' as http;

class User {
  Future<List<user_model.User>> getUsers(
      String url, String token, int skip, int limit) async {
    try {
      final response = await http.get(
          Uri.parse(url + skip.toString() + "/" + limit.toString()),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        if (l != null) {
          List<user_model.User> list =
              l.map((model) => user_model.User.fromJson(model)).toList();
          return list;
        } else {
          return null;
        }
      } else {
        // If that call was not successful, throw an error.
        //throw Exception('Failed to load the data');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<GeneralResponse> updateUserById(
      String id, String token, Map<String, dynamic> body) async {
    var url = EndPoint.BASE_URL + EndPoint.UPDATE_USER_BY_ID;
    var response = await http
        .put(Uri.parse(url + id), body: JsonEncoder().convert(body), headers: {
      "accept": "application/json",
      "content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    return GeneralResponse.fromJson(
        json.decode(response.body), response.statusCode);
  }
}
