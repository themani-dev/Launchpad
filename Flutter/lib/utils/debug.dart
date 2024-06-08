// Function to print all SharedPreferences objects
import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_page.dart';

Future<void> printAllSharedPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys();

  for (String key in keys) {
    final value = prefs.get(key);
    print('$key: $value');
  }
}

Future getSession() async {
  var session = await AuthPage().getSessionFromStorage();
  return session;
}

String? extractUsername(CognitoUserSession? session) {
  if (session == null) return null;
  final idToken = session.getIdToken().getJwtToken();
  final payload = idToken?.split('.')[1];
  final normalized = base64Url.normalize(payload!);
  final decoded = utf8.decode(base64Url.decode(normalized));
  final Map<String, dynamic> claims = json.decode(decoded);
  return claims['email'];
}