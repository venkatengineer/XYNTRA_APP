import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeamEvaluationScreen extends StatefulWidget {
  final String teamId;

  const TeamEvaluationScreen({super.key, required this.teamId});

  @override
  State<TeamEvaluationScreen> createState() => _TeamEvaluationScreenState();
}

class _TeamEvaluationScreenState extends State<TeamEvaluationScreen> {
  final Map<String, double> scores = {
    "Communication": 5,
    "Scalability": 5,
    "UI/UX": 5,
    "Innovation": 5,
    "Technical Implementation": 5,
  };

  bool isSubmitting = false;

  Future<void> submitMarks() async {
    setState(() => isSubmitting = true);

    final response = await http.post(
      Uri.parse("http://YOUR_SERVER_IP:8000/submit-marks"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "team_id": widget.teamId,
        "scores": scores,
      }),
    );

    setState(() => isSubmitting = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Marks submitted successfully")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit marks")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Team Evaluation"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Team ID: ${widget.teamId}",
              style: const TextStyle(
                fontSize: 18,
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
                        "$category: ${scores[category]!.toInt()}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Slider(
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
                      const Divider(),
                    ],
                  );
                }).toList(),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : submitMarks,
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit Marks"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
