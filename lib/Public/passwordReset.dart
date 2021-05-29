import '../helpers/httphelper.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';
import '../apis/endpoints.dart';

class PasswordReset extends StatefulWidget {
  final String email;

  // In the constructor, require a Todo.
  PasswordReset({Key key, this.email}) : super(key: key);

  @override
  PasswordResetState createState() => PasswordResetState();
}

class PasswordResetState extends State<PasswordReset> {
  bool loggedIn = false;
  String _email, _password, _verifyCode;

  final formKey = GlobalKey<FormState>();
  final mainKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mainKey,
      appBar: AppBar(title: Text("Reset Password")),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autocorrect: false,
                  initialValue: widget.email,
                  decoration: InputDecoration(
                    labelText: "Email:",
                  ),
                  validator: (str) =>
                      str.length <= 5 ? "Not a Valid Email!" : null,
                  onSaved: (str) => _email = str,
                ),
                TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: "New Password:",
                  ),
                  validator: (str) =>
                      str.length <= 7 ? "Not a Valid Password!" : null,
                  onSaved: (str) => _password = str,
                ),
                TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: "Verification Code:",
                  ),
                  validator: (str) =>
                      str.length <= 3 ? "Not a Valid Code!" : null,
                  onSaved: (str) => _verifyCode = str,
                ),
                ElevatedButton(
                  child: Text("Submit"),
                  onPressed: onSubmit,
                ),
              ],
            ),
          )),
    );
  }

  void onSubmit() async {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      ResetPassword resetPassword = new ResetPassword(
          email: _email, verifyCode: _verifyCode, password: _password);
      var result = await HttpHelper().post(
          EndPoint.BASE_URL + EndPoint.RESETPASSWORD,
          body: resetPassword.toMap());
      if (result.status == "success") {
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context, false);
      }
    }
  }
}
