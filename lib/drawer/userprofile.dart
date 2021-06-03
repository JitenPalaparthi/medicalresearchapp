import 'package:flutter/material.dart';
import '/components/appbar.dart';
import 'package:medicalresearchapp/models/userprofile.dart' as userprofile_mode;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool loggedIn = false;
  bool isLoaded = false;
  String token, email, name;
  String _occupation,
      _moreInfo,
      _address,
      _state,
      _city,
      _country,
      _pinCode,
      _socialMedia;

  userprofile_mode.UserProfile userProfile;
  final formKey = GlobalKey<FormState>();
  final mainKey = GlobalKey<ScaffoldState>();

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: mainKey,
      appBar: setAppbar(context, "User Profile"),
      body: Padding(
          padding: EdgeInsets.all(10.0), child: formIndividualBy(userProfile)),
    );
  }

  Widget formIndividual() {
    return FutureBuilder<userprofile_mode.UserProfile>(
        //individual,
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.none &&
          snapshot.hasData == null) {
        return Container();
      }
      return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              autocorrect: false,
              initialValue: snapshot.data?.user?.email ?? "",
              decoration: InputDecoration(
                labelText: "Email:",
              ),
            ),
            TextFormField(
              autocorrect: false,
              initialValue: snapshot.data?.occupation,
              decoration: InputDecoration(
                labelText: "Occupation:",
              ),
              validator: (str) =>
                  str.length <= 2 ? "Not a Valid Occupation!" : null,
              onSaved: (str) => _occupation = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: snapshot.data?.moreInfo ?? "",
              decoration: InputDecoration(
                labelText: "More Information:",
              ),
              validator: (str) =>
                  str.length <= 5 ? "Not a Valid Information!" : null,
              onSaved: (str) => _moreInfo = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: snapshot.data?.address ?? "",
              decoration: InputDecoration(
                labelText: "Address:",
              ),
              validator: (str) =>
                  str.length <= 5 ? "Not a Valid Address!" : null,
              onSaved: (str) => _address = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: snapshot.data?.city ?? "",
              decoration: InputDecoration(
                labelText: "City:",
              ),
              validator: (str) => str.length <= 2 ? "Not a Valid City!" : null,
              onSaved: (str) => _city = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: snapshot.data?.state ?? "",
              decoration: InputDecoration(
                labelText: "State:",
              ),
              validator: (str) => str.length <= 2 ? "Not a Valid State!" : null,
              onSaved: (str) => _state = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: snapshot.data?.country ?? "",
              decoration: InputDecoration(
                labelText: "Country:",
              ),
              validator: (str) =>
                  str.length <= 2 ? "Not a Valid Country!" : null,
              onSaved: (str) => _country = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: snapshot.data?.pinCode ?? "",
              decoration: InputDecoration(
                labelText: "Pin/Zip Code:",
              ),
              validator: (str) =>
                  str.length <= 2 ? "Not a Valid PinCode!" : null,
              onSaved: (str) => _pinCode = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: snapshot.data?.socialMedia ?? "",
              decoration: InputDecoration(
                labelText: "SocialMedia:",
              ),
              validator: (str) =>
                  str.length <= 5 ? "Not a Valid SocialMedia!" : null,
              onSaved: (str) => _socialMedia = str,
            ),
          ],
        ),
      );
    });
  }

  Widget formIndividualBy(userprofile_mode.UserProfile userProfile) {
    if (isLoaded) {
      return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              readOnly: true,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Email:",
              ),
            ),
            TextFormField(
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Occupation:",
              ),
              validator: (str) =>
                  str.length <= 2 ? "Not a Valid Occupation!" : null,
              onSaved: (str) => _occupation = str,
            ),
            TextFormField(
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "More Information:",
              ),
              validator: (str) =>
                  str.length <= 5 ? "Not a Valid Information!" : null,
              onSaved: (str) => _moreInfo = str,
            ),
            TextFormField(
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Address:",
              ),
              validator: (str) =>
                  str.length <= 5 ? "Not a Valid Address!" : null,
              onSaved: (str) => _address = str,
            ),
            TextFormField(
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "City:",
              ),
              validator: (str) => str.length <= 2 ? "Not a Valid City!" : null,
              onSaved: (str) => _city = str,
            ),
            TextFormField(
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "State:",
              ),
              validator: (str) => str.length <= 2 ? "Not a Valid State!" : null,
              onSaved: (str) => _state = str,
            ),
            TextFormField(
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Country:",
              ),
              validator: (str) =>
                  str.length <= 2 ? "Not a Valid Country!" : null,
              onSaved: (str) => _country = str,
            ),
            TextFormField(
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Pin/Zip Code:",
              ),
              validator: (str) =>
                  str.length <= 2 ? "Not a Valid PinCode!" : null,
              onSaved: (str) => _pinCode = str,
            ),
            TextFormField(
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "SocialMedia:",
              ),
              validator: (str) =>
                  str.length <= 5 ? "Not a Valid SocialMedia!" : null,
              onSaved: (str) => _socialMedia = str,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
