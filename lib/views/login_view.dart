// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'dart:developer' as devtools show log;
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
          'Login',
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
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                if(user?.emailVerified ?? false){
                  //user email verified
                  Navigator.of(context)
                    .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                }
                else 
                {
                  //user email not verified
                  Navigator.of(context)
                    .pushNamedAndRemoveUntil(verifyemailRoute, (route) => false);
                }
                
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-credential') {
                  await showErrorDialog(context,
                      'potentially user not found / invalid credential');
                } else if (e.code == 'wrong-password') {
                  await showErrorDialog(context, 'wrong credentialss');
                } else {
                  await showErrorDialog(context, 'Error: ${e.code}');
                }
              } catch (e) {
                await showErrorDialog(context, e.toString());
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('wanna Register?'),
          ),
        ],
      ),
    );
  }
}
