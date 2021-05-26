import 'package:flutter/material.dart';
import 'components/appbar.dart';

class HomePage extends StatefulWidget {
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
  HomePage({
    Key key,
    this.title,
  }) : super(key: key);
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: setAppbar(context, "Medical Research"),
      drawer: Container(),
      body: Container(),
    );
  }
}
