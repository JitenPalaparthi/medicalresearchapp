import 'dart:convert';
import '../models/response.dart';

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
      if (response.statusCode == 200) {
        return GeneralResponse.fromJson(
            json.decode(response.body), response.statusCode);
      } else {
        throw Exception("Failed due to network issue");
      }
    } catch (e) {
      // throw Exception("Failed due to network issue");
      print(e);
    }
    return null;
  }
}

class HttpEndPoints {
  static const String BASE_URL = "http://127.0.0.1:50061/";
  static const String GET_TEMPLATEBYID = "v1/template/getAll/";
  static const String GET_TEMPLATEMETADATA = "/v1/template/metadata/getAll";
}
