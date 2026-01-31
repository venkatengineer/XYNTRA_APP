import 'package:flutter/material.dart';
import 'team_evaluation_screen.dart';

class TeamDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> teamData;

  const TeamDetailsScreen({super.key, required this.teamData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Team Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TEAM LOGO
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(teamData['logo_url']),
              ),
            ),

            const SizedBox(height: 20),

            _info("Team Name", teamData['team_name']),
            _info("Team Leader", teamData['team_leader']),
            _info("Team ID", teamData['team_id']),
            _info("Problem Statement", teamData['problem_statement']),

            const Spacer(),

            /// MARK POINTS BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("MARK POINTS"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TeamEvaluationScreen(
                        teamId: teamData['team_id'],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              )),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
