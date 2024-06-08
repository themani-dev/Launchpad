import 'package:flutter/material.dart';
import '../../components/button.dart';
import '../../components/customTextfield.dart';
import 'verification_page.dart';
import '../../utils/auth_page.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _State();
}



class _State extends State<SignupPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  String? passwordErrorText;
  bool passwordsMatch = false;

  void signUp() async{
    // _validatePasswords();
    try {
      String Status = await AuthPage().signUp(
          usernameController.text, passwordController.text,
          nameController.text);
      if (Status == 'success') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  VerificationPage(username: usernameController.text,password:passwordController.text)),);
      }
      else {
        print(Status);
      };
    }
    catch (e) {
      print('Error during Signing-up: $e');
    }

  }
  void _validatePasswords() {
    setState(() {
      if (passwordController.text != confirmPasswordController.text) {
        passwordErrorText = 'Passwords do not match';
        passwordsMatch = false;
      } else {
        passwordErrorText = null;
        passwordsMatch = true;
      }
    });
  }
  @override
  void initState() {
    super.initState();
    passwordController.addListener(_validatePasswords);
    confirmPasswordController.addListener(_validatePasswords);
  }

  @override
  void dispose() {
    passwordController.removeListener(_validatePasswords);
    confirmPasswordController.removeListener(_validatePasswords);
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
                'Register as a New User',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 30,
                ),
              ),

              const SizedBox(height: 50),

              // Email Area
              myTextField(
                controller: nameController,
                hintText: 'Name',
                isenabled: true,
              ),

              const SizedBox(height: 10),

              // Email Area
              EmailTextField(
                controller: usernameController,
                hintText: 'Email',
                isenabled: true,
              ),

              const SizedBox(height: 10),

              // password textfield
              PasswordTextField(
                controller: passwordController,
                hintText: 'Password',
                isenabled: true,
              ),

              // confirmPassword(
              //   controller: passwordController,
              //   hintText: 'Password',
              //   // isenabled: true,
              //   obscureText: true,
              //   errorText: passwordErrorText,
              // ),

              const SizedBox(height: 10),

              confirmPassword(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
                errorText: passwordErrorText,
              ),
              const SizedBox(height: 50),

              Button(
                onTap: passwordsMatch ? signUp : null,
                text: 'Sign Up',
              ),

            ],
          ),
        ),
      ),
    );
  }
}
