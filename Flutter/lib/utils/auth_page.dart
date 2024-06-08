import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'debug.dart';
// import 'dashboard.dart';

class AuthPage {
  final userPool = CognitoUserPool(
      '${(dotenv.env['POOL_ID'])}', '${(dotenv.env['CLIENT_ID'])}');

  Future login(username, password) async {
    final cognitoUser = CognitoUser(username, userPool);
    final authDetails = AuthenticationDetails(
      username: username,
      password: password,
    );
    CognitoUserSession? session;
    try {
      session = await cognitoUser.authenticateUser(authDetails);
      debugPrint('Login Success...');
      return session;
    // } on CognitoUserNewPasswordRequiredException catch (e) {
    //   debugPrint('CognitoUserNewPasswordRequiredException $e');
    // } on CognitoUserMfaRequiredException catch (e) {
    //   debugPrint('CognitoUserMfaRequiredException $e');
    // } on CognitoUserSelectMfaTypeException catch (e) {
    //   debugPrint('CognitoUserMfaRequiredException $e');
    // } on CognitoUserMfaSetupException catch (e) {
    //   debugPrint('CognitoUserMfaSetupException $e');
    // } on CognitoUserTotpRequiredException catch (e) {
    //   debugPrint('CognitoUserTotpRequiredException $e');
    // } on CognitoUserCustomChallengeException catch (e) {
    //   debugPrint('CognitoUserCustomChallengeException $e');
    // } on CognitoUserConfirmationNecessaryException catch (e) {
    //   debugPrint('CognitoUserConfirmationNecessaryException $e');
    // } on CognitoClientException catch (e) {
    //   debugPrint('CognitoClientException $e');
    } catch (e) {
      // print(e);
      return e;
    }
  }

  Future signUp(email,password,name) async {
    final userAttributes = [
      AttributeArg(name: 'name', value: name),
      // AttributeArg(name: 'LastName', value: 'dev'),
    ];

    var data;
    try {
      data = await userPool.signUp(
        email,
        password,
        userAttributes: userAttributes,
      );
      return 'success';
    } on CognitoClientException catch (e) {
      debugPrint('CognitoClientException $e');
      return 'failed';
    } catch (e) {
      print(e);
      return 'failed';
    }
  }

  Future Verify(email,password,otp) async {
    final cognitoUser = CognitoUser(email, userPool);
    bool registrationConfirmed = false;
    try {
      registrationConfirmed = await cognitoUser.confirmRegistration(otp);
      if(registrationConfirmed){
        final session = await login(email,password);
        return session;
      }
      else {
        return registrationConfirmed;
      }
    } catch (e) {
      return e;
    }
  }

  Future resendOTP(email) async {
    final cognitoUser = CognitoUser(email, userPool);
    var status;
    try {
      status = await cognitoUser.resendConfirmationCode();
      return 'success';
    } catch (e) {
      print(e);
      return 'failed';
    }
  }
  Future forgotPasswordOTP(email) async {
    final cognitoUser = CognitoUser(email, userPool);
    var data;
    try {
      data = await cognitoUser.forgotPassword();
      print('Code sent to $data');
      return 'success';
    } catch (e) {
      print(e);
      return 'failed';
    }
  }
  Future forgotPasswordConfirm(email,otp,password) async {
    final cognitoUser = CognitoUser(email, userPool);
    bool passwordConfirmed = false;
    try {
      passwordConfirmed = await cognitoUser.confirmPassword(
          otp, password);
      if(passwordConfirmed){
        final session = await login(email,password);
        return session;
      }
      else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Function to store the session
  Future<void> storeSession(CognitoUserSession session) async {
    final prefs = await SharedPreferences.getInstance();

    final sessionMap = {
      'idToken': session.idToken.jwtToken,
      'accessToken': session.accessToken.jwtToken,
      'refreshToken': session.refreshToken?.token,
    };

    await prefs.setString('cognitoUserSession', jsonEncode(sessionMap));
  }

// Function to retrieve the stored session
  Future<CognitoUserSession?> getSessionFromStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final sessionString = prefs.getString('cognitoUserSession');

    if (sessionString == null) {
      return null;
    }

    final sessionMap = jsonDecode(sessionString);

    final idToken = CognitoIdToken(sessionMap['idToken']);
    final accessToken = CognitoAccessToken(sessionMap['accessToken']);
    final refreshToken = CognitoRefreshToken(sessionMap['refreshToken']);

    return CognitoUserSession(idToken, accessToken, refreshToken: refreshToken);
  }

  // Refresh JWT Token
  Future<void> refreshJWT(session,refreshToken) async {
    String? _username = extractUsername(session);
    // print(_username);
    final cognitoUser = CognitoUser(_username, userPool);
    try {
      final newSession = await cognitoUser.refreshSession(refreshToken);
      // Save new tokens (access, ID, refresh)
      print('New access token: ${newSession?.getAccessToken().getJwtToken()}');
    } catch (e) {
      print(e);
    }
  }
}
