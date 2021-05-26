import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

AppBar setAppbar(BuildContext context, String title) {
  return AppBar(
    title: Text(title,
        //widget.title,
        style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Logofont',
            fontWeight: FontWeight.bold,
            fontSize: 20)),
    actions: [
      IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var result = await prefs.clear();
            if (result) {
              print("came here");
              await Navigator.pushNamed(context, '/login');
            }
          })
    ],
  );
}
