import 'package:flutter/material.dart';

AppBar setAppbar(String title) {
  return AppBar(
      title: Text(title,
          //widget.title,
          style: TextStyle(
              color: Colors.grey,
              fontFamily: 'Logofont',
              fontWeight: FontWeight.bold,
              fontSize: 20)));
}
