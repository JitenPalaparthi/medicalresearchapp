import 'dart:convert';
import 'dart:io';
import '../models/response.dart';
import '../models/projectData.dart' as model_projectData;

import 'package:http/http.dart' as http;

class ProjectData {
  Future<GeneralResponse> addProjectData(
      String url, token, model_projectData.ProjectData body) async {
    var response =
        await http.post(Uri.parse(url), body: json.encode(body), headers: {
      "accept": "application/json",
      "content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    return GeneralResponse.fromJson(
        json.decode(response.body), response.statusCode);
  }

  Future<List<model_projectData.ProjectData>> getProjectDataByTemplateId(
      String url, String token, int skip, int limit) async {
    final response = await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      if (l != null) {
        List<model_projectData.ProjectData> list = l
            .map((model) => model_projectData.ProjectData.fromJson(model))
            .toList();
        return list;
      } else {
        return null;
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load the data');
    }
  }

  Future<GeneralResponse> deleteProjectDataById(
      String url, String id, String token) async {
    final response = await http.delete(Uri.parse(url + "/" + id),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    return GeneralResponse.fromJson(
        json.decode(response.body), response.statusCode);
  }
}
