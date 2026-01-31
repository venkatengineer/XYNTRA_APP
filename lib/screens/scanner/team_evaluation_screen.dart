import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/judge_session.dart';

class TeamEvaluationScreen extends StatefulWidget {
  final String teamId;

  const TeamEvaluationScreen({super.key, required this.teamId});

  @override
  State<TeamEvaluationScreen> createState() => _TeamEvaluationScreenState();
}

class _TeamEvaluationScreenState extends State<TeamEvaluationScreen> {
  static const Color gold = Color(0xFFD4AF37);

  final Map<String, double> scores = {
    "Communication": 5,
    "Scalability": 5,
    "UI / UX": 5,
    "Innovation": 5,
    "Technical Implementation": 5,
  };

  bool isSubmitting = false;

  Future<void> submitMarks() async {
    if (JudgeSession.judgeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judge not logged in")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final response = await http.post(
        Uri.parse("http://192.168.29.72:8000/submit-marks"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "team_id": widget.teamId,
          "judge_id": JudgeSession.judgeId,
          "scores": scores,
        }),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Marks submitted successfully")),
        );
      } else {
        showError("Failed to submit marks");
      }
    } catch (e) {
      showError("Backend connection failed");
    }

    setState(() => isSubmitting = false);
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("EVALUATE TEAM"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "TEAM ID: ${widget.teamId}",
              style: TextStyle(
                color: gold,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: scores.keys.map((category) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$category : ${scores[category]!.toInt()}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: gold,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: gold,
                          overlayColor: gold.withOpacity(0.2),
                          valueIndicatorColor: gold,
                        ),
                        child: Slider(
                          value: scores[category]!,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: scores[category]!.toInt().toString(),
                          onChanged: (value) {
                            setState(() {
                              scores[category] = value;
                            });
                          },
                        ),
                      ),
                      const Divider(color: Colors.white24),
                    ],
                  );
                }).toList(),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                onPressed: isSubmitting ? null : submitMarks,
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("SUBMIT MARKS"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
