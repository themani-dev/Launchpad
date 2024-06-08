import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/button.dart';
import '../../components/customTextfield.dart';
import '../../components/otp.dart';
import './Categories/entry_point.dart';
import '../components/alertMessage.dart';
import '../utils/auth_page.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final usernameController = TextEditingController();
  final newPasswordController = TextEditingController();
  bool isTextFieldEnabled = true;
  bool ispasswordTextFieldEnabled = false;
  bool _issubmitButtonDisabled = true;
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List<FocusNode>.generate(6, (index) => FocusNode());
    _controllers = List<TextEditingController>.generate(6, (index) => TextEditingController());
  }
  @override
  void dispose() {
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> getOTP() async {
    print(usernameController.text);
    String status = await AuthPage().forgotPasswordOTP(usernameController.text);
    if (status == 'success'){
      setState(() {
        isTextFieldEnabled = false;
        ispasswordTextFieldEnabled = true;
        _issubmitButtonDisabled = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(AlertMessage.showAlert(
        mode: "success",
        title: "Congrats",
        message: "OTP Sent successfully",
      ));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(AlertMessage.showAlert(
        mode: "fail",
        title: "Oh snap!",
        message: "OTP Sent Failed",
      ));
    }

  }

  Future<void> submit() async {
    String OTP = _controllers.map((controller) => controller.text).join();
    print(OTP);
    var session = await AuthPage().forgotPasswordConfirm(usernameController.text, OTP, newPasswordController.text);
    if (session is CognitoUserSession){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var sessionStore = await AuthPage().storeSession(session);
      await prefs.setBool('isLoggedIn', true);
      ScaffoldMessenger.of(context).showSnackBar(AlertMessage.showAlert(
        mode: "success",
        title: "Congrats!",
        message: "Successful Sign-In",
      ));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EntryPoint()),
      );
    } else if (session == null){
      ScaffoldMessenger.of(context).showSnackBar(AlertMessage.showAlert(
        mode: "fail",
        title: "Oh snap!",
        message: "Sign-Up Failed",
      ));
    } else{
      ScaffoldMessenger.of(context).showSnackBar(AlertMessage.showAlert(
        mode: "fail",
        title: "Oh snap!",
        message: session.message,
      ));
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

              const SizedBox(height: 20),
              // welcome back, you've been missed!
              Text(
                'Retrieve Account',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: EmailTextField(
                      controller: usernameController,
                      hintText: 'Email',
                      isenabled: isTextFieldEnabled,
                    ),
                  ),
                  const SizedBox(width: 7),

                  ElevatedButton(
                    onPressed: getOTP,
                    child: Text('Get OTP'),
                  ),
                ],
                )
              ),
              const SizedBox(height: 20),

              Text(
                'Enter OTP & New Password',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => _buildOTPField(index)),
              ),
              const SizedBox(height: 20),

              // Button(
              //   onTap: _isButtonDisabled ? null : verify,
              //   text: 'Verify',
              // ),
              // const SizedBox(height: 20),
              //
              // Text(
              //   'Enter New Password',
              //   style: TextStyle(
              //     color: Colors.grey[700],
              //     fontSize: 30,
              //   ),
              // ),
              // const SizedBox(height: 20),

              PasswordTextField(
                controller: newPasswordController,
                hintText: 'New Password',
                isenabled: ispasswordTextFieldEnabled,
              ),
              const SizedBox(height: 20),
              Button(
                onTap: _issubmitButtonDisabled ? null : submit,
                text: 'Submit',
              ),


            ],

          )
        ),
      ),
    );
  }
}

