import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad2_quiz1_2023/screen/converter_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passController = TextEditingController();

  void login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passController.text);
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => const ConverterScreen(),
        ),
      );
    } on FirebaseAuthException catch (ex) {
      print(ex.code);
      if (ex.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mali Password mo beh'),
          ),
        );
        return;
      }
      if (ex.code == "invalid-email") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid ang email mo pero feelings valid"),
          ),
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 50,
              height: 50,
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: passController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
                onPressed: login, child: const Text('Loginnnnnnnnnnn'))
          ],
        ),
      ),
    );
  }
}
