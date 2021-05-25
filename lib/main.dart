import 'package:flutter/material.dart';
import 'components/bottombar.dart';
import 'Public/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Set default home.
  Widget _whichPageToGo = new UserLogin();
  String _result = prefs.getString("token");
  print("===============TOKEN====================$_result");

  if (_result != null) {
    _whichPageToGo = BottomBar();
  }
  //runApp(MyApp());
  runApp(new MaterialApp(
    title: 'Medical Research',
    home: _whichPageToGo,
    theme: new ThemeData(
        primaryColor: Colors.grey[800], //const //Color(0xFF02BB9F),
        primaryColorDark: Colors.grey[500], //const Color(0xFF167F67),
        accentColor: Colors.grey[200] //const Color(0xFFFFAD32),
        ),
    routes: <String, WidgetBuilder>{
      // Set routes for using the Navigator.
      '/login': (BuildContext context) => new UserLogin(),
      // '/register': (BuildContext context) => new UserRegister()
    },
  ));
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
