import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_services.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: const Color.fromARGB(255, 210, 41, 41),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mark_email_unread,
              size: 70,
              color: Color.fromARGB(255, 211, 55, 55),
            ),
            const SizedBox(height: 24),
            const Text(
              'Check Your Email',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'We\'ve sent you an email verification link. Please check your inbox and verify your email address.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Didn\'t receive the email?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // ignore: await_only_futures
                  await AuthService.firebase().sendEmailVerification;
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verification email sent')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Resend Verification Email'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                // ignore: use_build_context_synchronously
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Back to Register'),
            ),
          ],
        ),
      ),
    );
  }
}


// class _VerifyEmailViewState extends State<VerifyEmailView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('register Email'),
//       ),
//       body: Column(
//         children: [
//           const Text(
//               'we have sent you an email veification link, please open mail and verify it'),
//           const Text('                     .                       '),
//           const Text('If you have not received the mail , press here '),
//           TextButton(
//             onPressed: () async {
//               final user = FirebaseAuth.instance.currentUser;
//               await user?.sendEmailVerification();
//             },
//             child: const Text('Send Email Verification'),
//           ),
//           TextButton(
//             onPressed: () {
//               FirebaseAuth.instance.signOut();
//             },
//             child: const Text('Restart'),
//           ),
//         ],
//       ),
//     );
//   }
// }