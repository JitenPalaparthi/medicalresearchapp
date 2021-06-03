import 'package:flutter/material.dart';
import '../components/appbar.dart';

class About extends StatefulWidget {
  const About({Key key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: setAppbar(context, "About"),
      body: Center(
        child: Text("About"),
      ),
    );
  }
}
