import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/judge_session.dart';
import '../../widgets/bottom_nav.dart';

class JudgeLoginScreen extends StatefulWidget {
  const JudgeLoginScreen({super.key});

  @override
  State<JudgeLoginScreen> createState() => _JudgeLoginScreenState();
}

class _JudgeLoginScreenState extends State<JudgeLoginScreen> {
  static const Color gold = Color(0xFFFFC107);

  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("http://192.168.29.72:8000/judge-login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": usernameCtrl.text.trim(),
          "password": passwordCtrl.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        JudgeSession.judgeId = data["judge_id"];
        JudgeSession.judgeName = data["judge_name"];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomNav()),
        );
      } else {
        showError("Invalid credentials");
      }
    } catch (e) {
      showError("Backend connection failed");
    }

    setState(() => isLoading = false);
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_user, size: 80, color: gold),
              const SizedBox(height: 20),

              const Text(
                "JUDGE LOGIN",
                style: TextStyle(
                  color: gold,
                  fontSize: 22,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              _field("Username", usernameCtrl),
              const SizedBox(height: 16),
              _field("Password", passwordCtrl, obscure: true),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          "LOGIN",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String hint, TextEditingController ctrl,
      {bool obscure = false}) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: gold),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: gold, width: 2),
        ),
      ),
    );
  }
}
