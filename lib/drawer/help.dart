import 'package:flutter/material.dart';
import '../components/appbar.dart';

class Helppage extends StatefulWidget {
  const Helppage({Key key}) : super(key: key);

  @override
  _HelppageState createState() => _HelppageState();
}

class _HelppageState extends State<Helppage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: setAppbar(context, "Help"),
        body: Center(
          child: Text("Help"),
        ));
  }
}
