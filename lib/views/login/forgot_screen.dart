import 'package:flutter/material.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final TextEditingController _mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 100,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _mobileController,
              decoration: const InputDecoration(
                labelText: 'Registered Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
