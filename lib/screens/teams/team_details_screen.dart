import 'package:flutter/material.dart';

class TeamDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> teamData;

  const TeamDetailsScreen({super.key, required this.teamData});

  static const Color gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    final List members =
        teamData["team_members"] ?? [];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("TEAM DETAILS"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                  backgroundColor: Colors.black,
                  backgroundImage:
                      NetworkImage(teamData["logo_url"]),
                ),
              ),
            ),

            const SizedBox(height: 24),

            _sectionTitle("TEAM INFORMATION"),
            _info("Team Name", teamData["team_name"]),
            _info("Team ID", teamData["team_id"]),
            _info("Team Leader", teamData["team_leader"]),

            const SizedBox(height: 16),

            _sectionTitle("TEAM MEMBERS"),
            members.isEmpty
                ? const Text(
                    "No members listed",
                    style: TextStyle(color: Colors.white54),
                  )
                : Column(
                    children: members.map((member) {
                      return ListTile(
                        leading: Icon(Icons.person, color: gold),
                        title: Text(
                          member,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),

            const SizedBox(height: 16),

            _sectionTitle("PROBLEM STATEMENT"),
            Text(
              teamData["problem_statement"],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: gold,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
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
