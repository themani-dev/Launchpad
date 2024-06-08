import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/alertMessage.dart';
import '../../utils/auth_page.dart';
import '../../utils/debug.dart';
import '../login_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic _session;

  @override
  void initState() {
    super.initState();
  }

  void signout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('cognitoUserSession');
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
  }

  Future<void> gettoken() async {
    _session = await getSession();

    if (_session is CognitoUserSession) {
      CognitoUserSession session = _session;
      final refreshToken = session.getRefreshToken();
      if (refreshToken == null) {
        print('No refresh token available');
      } else {
        await AuthPage().refreshJWT(session,refreshToken);
      }
    } else if (_session == null) {
      print('Null');
    } else {
      print(_session);
    }
  }

  void alertMessage() async{
    ScaffoldMessenger.of(context).showSnackBar(AlertMessage.showAlert(
      mode: "fail",
      title: "Oh snap!",
      message: "Something went wrong",
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  ElevatedButton(
                      onPressed: alertMessage, child: const Text("Show Alert Message")),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: gettoken,
                    child: Text('Get Token'),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: signout,
                    child: Text('Sign Out'),
                  ),
                ]
            ),
          ),
        )
    );
  }
}
