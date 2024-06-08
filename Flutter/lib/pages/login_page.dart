import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/button.dart';
import '../../components/customTextfield.dart';
import '../../components/square_tile.dart';
import '../../components/alertMessage.dart';
import '../utils/auth_page.dart';
import 'Categories/entry_point.dart';
import 'forgotPassword.dart';
import 'Signup/signup_page.dart';



class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  // sign user in method
  Future<void> signUserIn() async {
    print(usernameController.text);
    print(passwordController.text);
    var session = await AuthPage()
        .login(usernameController.text, passwordController.text);

    if (session is CognitoUserSession) {
      //Circular Indicator
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      var sessionStore = await AuthPage().storeSession(session);
      ScaffoldMessenger.of(context).showSnackBar(AlertMessage.showAlert(
        mode: "success",
        title: "Congrats!",
        message: "Successful Sign-In",
      ));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EntryPoint()),
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(AlertMessage.showAlert(
        mode: "fail",
        title: "Oh snap!",
        message: session.message,
      ));
    }
  }

  // Forgot  Password
  void  ForgetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPassword()),
    );
  }



  // Google SignIn
  void GoogleSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(AlertMessage.showAlert(
      mode: "success",
      title: "Hello There!",
      message: "Google Sign-In Tapped",
    ));
  }

  // Apple SignIn
  void AppleSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(AlertMessage.showAlert(
      mode: "success",
      title: "Hello There!",
      message: "Apple Sign-In Tapped",
    ));
  }

  void signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // logo
              const Icon(
                Icons.lock,
                size: 80,
              ),

              const SizedBox(height: 50),

              // welcome back,
              Text(
                'Welcome',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // username textfield
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
                // obscureText: true,
                isenabled: true,
              ),

              const SizedBox(height: 10),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: ForgetPassword,
                        borderRadius: BorderRadius.circular(4),
                        splashColor: Colors.grey.withOpacity(0.3),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // sign in button
              Button(
                onTap: signUserIn,
                text: 'Sign In',
              ),

              const SizedBox(height: 50),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),


              // google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                  SquareTile(
                      imagePath: 'lib/images/png/google.png', onTap: GoogleSignIn),

                  SizedBox(width: 25),

                  // apple button
                  SquareTile(
                      imagePath: 'lib/images/png/apple.png', onTap: AppleSignIn),

                  SizedBox(width: 25),

                  // apple button
                  SquareTile(
                      imagePath: 'lib/images/png/facebook.png', onTap: AppleSignIn)
                ],
              ),

              const SizedBox(height: 50),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: signUp,
                      borderRadius: BorderRadius.circular(4),
                      splashColor: Colors.blue.withOpacity(0.3),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
