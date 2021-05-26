import 'dart:convert';
import 'dart:io';
import '../models/template.dart' as template_model;
import 'package:http/http.dart' as http;

class Template {
  Future<template_model.Template> getTemplateById(
      String url, String token) async {
    final response = await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return template_model.Template.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load the data');
    }
  }

  Future<List<template_model.TemplateMetaData>> getTemplateMetaData(
      String url, String token) async {
    final response = await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      if (l != null) {
        List<template_model.TemplateMetaData> list = l
            .map((model) => template_model.TemplateMetaData.fromJson(model))
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
}
