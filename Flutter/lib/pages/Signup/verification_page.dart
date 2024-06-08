import 'dart:async';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/otp.dart';
import '../../components/button.dart';
import '../Categories/entry_point.dart';
import '../../utils/auth_page.dart';
import '../login_page.dart';

class VerificationPage extends StatefulWidget {
  // final String username;
  // const VerificationPage(username,{super.key});
  final String username;
  final String password;

  const VerificationPage({
    required this.username,
    required this.password,
    Key? key,
  }) : super(key: key);
  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  bool _isButtonDisabled = true;
  int _secondsRemaining = 50;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _focusNodes = List<FocusNode>.generate(6, (index) => FocusNode());
    _controllers = List<TextEditingController>.generate(6, (index) => TextEditingController());
    _startTimer();
  }
  @override
  void dispose() {
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isButtonDisabled = false;
        });
      }
    });
  }

  Future<void> _resendOTP() async {
    setState(() {
      _secondsRemaining = 45;
      _isButtonDisabled = true;
    });
    _startTimer();
    // Add your resend OTP logic here
    var status = await AuthPage().resendOTP(widget.username);
    print('Password Sent Successfully');
  }

  Future<void> submit() async {
    String OTP = _controllers.map((controller) => controller.text).join();
    var session = await AuthPage().Verify(widget.username,widget.password,OTP);

    if (session is CognitoUserSession){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      var sessionStore = await AuthPage().storeSession(session);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EntryPoint()),
      );
      print(session.idToken.jwtToken);
    }
    else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Widget _buildOTPField(int index) {
    return OtpTextField(
      controller: _controllers[index],
      focusNode: _focusNodes[index],
      onChanged: (value) {
        if (value.length == 1 && index < 5) {
          _focusNodes[index].unfocus();
          FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
        } else if (value.length == 0 && index > 0) {
          _focusNodes[index].unfocus();
          FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          elevation: 0, // To remove the shadow below the AppBar
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      const Icon(
                        Icons.lock,
                        size: 100,
                      ),

                      const SizedBox(height: 50),
                      // welcome back, you've been missed!
                      Text(
                        'Enter OTP',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) => _buildOTPField(index)),
                      ),

                      const SizedBox(height: 50),

                      ElevatedButton(
                        onPressed: _isButtonDisabled ? null : _resendOTP,
                        child: Text(
                          _isButtonDisabled ? 'Resend OTP in $_secondsRemaining sec' : 'Resend OTP',
                        ),
                      ),

                      const SizedBox(height: 50),

                      Button(
                        onTap: submit,
                        text: 'Submit',
                      ),
                    ]
                )
            )
        )
    );
  }
}
