import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool isenabled;

  EmailTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isenabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
          controller: controller,
          obscureText: false,
          enabled: isenabled,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email cannot be empty';
            }
            final emailRegExp = RegExp(
              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
            );
            if (!emailRegExp.hasMatch(value)) {
              return 'Enter a valid email address';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500])),
        ),
      );
  }
}

class PasswordTextField extends StatelessWidget {
  final controller;
  final _formKey = GlobalKey<FormState>();
  final String hintText;
  final bool isenabled;

  PasswordTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isenabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextFormField(
            controller: controller,
            obscureText: true,
            enabled: isenabled,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password cannot be empty';
              }
              final passwordRegExp = RegExp(
                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
              );
              if (!passwordRegExp.hasMatch(value)) {
                return 'Password must be at least 8 characters, \n include an uppercase letter, a lowercase letter, a number,\n and a special character';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey[500])),
          ),
        );
  }
}

class myTextField extends StatelessWidget {
  final controller;
  final _formKey = GlobalKey<FormState>();
  final String hintText;
  final bool isenabled;

  myTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isenabled,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextFormField(
            controller: controller,
            obscureText: false,
            enabled: isenabled,
            keyboardType: TextInputType.text,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // validator: (name) => name!.length < 3 ? 'Name should be greater than 3 letters' : null,
            validator: (text) {
              if (text == null || text.isEmpty) {
                return '$hintText cannot be empty';
              }
                if (text.length < 3) {
                return '$hintText Must be greater than';
              }
              return null;
            },
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey[500])),
          ),
        );
  }
}


class confirmPassword extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? errorText;

  confirmPassword({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500]),
            fillColor: Colors.grey.shade200,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorText: errorText,
          ),

        )
    );
  }
}



