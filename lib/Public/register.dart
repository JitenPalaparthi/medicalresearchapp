import '../helpers/httphelper.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';
import '../apis/endpoints.dart';

class UserRegister extends StatefulWidget {
  // In the constructor, require a Todo.
  UserRegister({Key key}) : super(key: key);

  @override
  UserRegisterState createState() => UserRegisterState();
}

class UserRegisterState extends State<UserRegister> {
  bool loggedIn = false;
  String _username, _email, _mobile, _password;

  final formKey = GlobalKey<FormState>();
  final mainKey = GlobalKey<ScaffoldState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mainKey,
      appBar: AppBar(title: Text("Register")),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: "Email:",
                  ),
                  validator: (str) =>
                      !str.contains('@') ? "Not a Valid Email!" : null,
                  onSaved: (str) => _email = str,
                ),
                TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: "Username:",
                  ),
                  validator: (str) =>
                      str.length <= 3 ? "Not a Valid Username!" : null,
                  onSaved: (str) => _username = str,
                ),
                TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: "Mobile:",
                  ),
                  validator: (str) =>
                      str.length <= 9 ? "Not a Valid Mobile!" : null,
                  onSaved: (str) => _mobile = str,
                ),
                TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(
                      labelText: "Password:",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          icon: Icon(_isObscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off))),
                  validator: (str) =>
                      str.length <= 7 ? "Not a Valid Password!" : null,
                  onSaved: (str) => _password = str,
                  obscureText: _isObscure,
                ),
              ],
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: onSubmit,
      ),
    );
  }

  void onSubmit() async {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      User user = new User(
        name: _username,
        email: _email,
        mobile: _mobile,
        password: _password,
        role: "system",
      );
      var result = await HttpHelper().post(
        EndPoint.BASE_URL + EndPoint.REGISTER,
        body: user.toMap(),
      );
      if (result.status == "success") {
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context, false);
      }
    }
  }
}
