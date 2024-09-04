// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'dart:developer' as devtools show log;

import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
        'Register',
         style: TextStyle(
          fontWeight: FontWeight.bold,
  ),
),
        backgroundColor: const Color.fromARGB(255, 211, 55, 55),
        elevation: 0,
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'please enter your Email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
                hintText: 'please enter your Password here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                user?.sendEmailVerification();
                Navigator.of(context).pushNamed(verifyemailRoute);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  showErrorDialog(
                    context,
                    'weak password',
                  );
                } else if (e.code == 'email-already-in-use') {
                  showErrorDialog(context, 'email already in use');
                } else if (e.code == 'invalid-email') {
                  showErrorDialog(context, 'invalid email use');
                } else {
                  showErrorDialog(context, 'Error: ${e.code}');
                }
              } catch (e) {
                showErrorDialog(context, e.toString());
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('wanna login?'),
          ),
        ],
      ),
    );
  }
}
