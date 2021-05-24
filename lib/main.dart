import 'package:flutter/material.dart';
import 'components/bottombar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Research',
      theme: new ThemeData(
          primaryColor: Colors.grey[800], //const //Color(0xFF02BB9F),
          primaryColorDark: Colors.grey[500], //const Color(0xFF167F67),
          accentColor: Colors.grey[200] //const Color(0xFFFFAD32),
          ),
      home: BottomBar(),
    );
  }
}
