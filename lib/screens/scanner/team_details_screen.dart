import 'package:flutter/material.dart';
import 'team_evaluation_screen.dart';

class TeamDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> teamData;

  const TeamDetailsScreen({super.key, required this.teamData});

  static const Color gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("TEAM DETAILS"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LOGO
            Center(
              child: CircleAvatar(
                radius: 55,
                backgroundColor: gold,
                child: CircleAvatar(
                  radius: 52,
                  backgroundImage: NetworkImage(teamData["logo_url"]),
                  backgroundColor: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 25),

            _info("TEAM NAME", teamData["team_name"]),
            _info("TEAM LEADER", teamData["team_leader"]),
            _info("TEAM ID", teamData["team_id"]),
            _info("PROBLEM STATEMENT", teamData["problem_statement"]),

            const Spacer(),

            /// MARK POINTS BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TeamEvaluationScreen(
                        teamId: teamData["team_id"],
                      ),
                    ),
                  );
                },
                child: const Text("MARK POINTS"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: gold,
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const Divider(color: Colors.white24),
        ],
      ),
    );
  }
}
