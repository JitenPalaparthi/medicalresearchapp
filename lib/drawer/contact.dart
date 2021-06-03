import 'package:flutter/material.dart';
import '../components/appbar.dart';

class ContactPAge extends StatefulWidget {
  const ContactPAge({Key key}) : super(key: key);

  @override
  _ContactPAgeState createState() => _ContactPAgeState();
}

class _ContactPAgeState extends State<ContactPAge> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: setAppbar(context, "Contact"),
      body: Center(child: Text("Contact")),
    );
  }
}
