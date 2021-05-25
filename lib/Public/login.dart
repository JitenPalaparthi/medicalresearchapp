import 'passwordReset.dart';
import 'package:flutter/material.dart';
import '../helpers/httphelper.dart';
import 'register.dart';
import '../models/user.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  TextEditingController emailEditingContrller = TextEditingController();
  TextEditingController passwordEditingContrller = TextEditingController();
  final mainKey = GlobalKey<ScaffoldState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    var column = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Medical Research",
            style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Logofont',
                fontWeight: FontWeight.bold,
                fontSize: 40)),
        TextField(
          autofocus: true,
          obscureText: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          controller: emailEditingContrller,
          decoration: InputDecoration(
              labelText: "Email",
              hintText: "Email",
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1,
                      color: Colors.orange,
                      style: BorderStyle.solid))),
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
          autofocus: false,
          obscureText: _isObscure,
          keyboardType: TextInputType.text,
          controller: passwordEditingContrller,
          decoration: InputDecoration(
              labelText: "Password",
              hintText: "Password",
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1,
                      color: Colors.orange,
                      style: BorderStyle.solid)),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off))),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ElevatedButton(
              onPressed: onSubmit,
              child: Text("Login"),
              // ),
            ),
            ElevatedButton(
              onPressed: () {
                passwordEditingContrller.text = "";
                emailEditingContrller.text = "";
              },
              child: Text("Reset"),
              // ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PasswordReset(
                      email: emailEditingContrller.text ?? "",
                    ),
                  ),
                ).then((value) {
                  if (value == true) {
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                        content: Text("Password Reset Successful"),
                        duration: Duration(milliseconds: 1000)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                        content: Text("Password Reset Failed"),
                        duration: Duration(milliseconds: 1000)));
                  }
                  // Run the code here using the value
                });
              },
              child: Text("Forgot Password"),
              // ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserRegister(),
                    ),
                  ).then((value) {
                    if (value == true) {
                      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                          content: Text("User Registration Successful"),
                          duration: Duration(milliseconds: 1000)));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                          content: Text("User Registration Failed"),
                          duration: Duration(milliseconds: 1000)));
                    }
                    // Run the code here using the value
                  });
                },
                child: Text("Register")),
          ],
        ),
      ],
    );
    return Scaffold(
      key: mainKey,
      body: Container(
        alignment: AlignmentDirectional.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 120.0,
              bottom: 24.0), //EdgeInsets.all(24),
          child: Container(
            child: column,
          ),
        ),
      ),
    );
  }

  void onSubmit() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("There is no netwrok connection"),
          duration: Duration(milliseconds: 1000),
        ));
      }

      UserLogIn user = new UserLogIn(
          email: emailEditingContrller.text,
          password: passwordEditingContrller.text);
      var result = await HttpHelper().post(
          HttpEndPoints.BASE_URL + HttpEndPoints.SIGN_IN,
          body: user.toMap());

      if (result.httpStatus == 200 && result.status == "success") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userFetch = await HttpHelper().fetchUser(emailEditingContrller.text,
            HttpEndPoints.BASE_URL + HttpEndPoints.GET_USER, result.token);
        await prefs.setString("token", result.token);
        await prefs.setString("name", userFetch.name);
        await prefs.setString("email", userFetch.email);
        await prefs.setString("mobile", userFetch.mobile);
      }
    } on SocketException catch (exp) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong with the connection"),
        duration: Duration(milliseconds: 1000),
      ));
    }
  }
}
