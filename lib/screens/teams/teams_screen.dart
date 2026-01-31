import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'team_details_screen.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  static const Color gold = Color(0xFFD4AF37);

  bool isLoading = true;
  List<Map<String, dynamic>> teams = [];

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  Future<void> fetchTeams() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.29.72:8000/all-teams"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          teams = List<Map<String, dynamic>>.from(data["teams"]);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("TEAMS"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: gold),
            )
          : teams.isEmpty
              ? const Center(
                  child: Text(
                    "No teams registered",
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    final team = teams[index];
                    return _teamCard(team);
                  },
                ),
    );
  }

  /// 🔥 TEAM CARD (TAP → DETAILS)
  Widget _teamCard(Map<String, dynamic> team) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TeamDetailsScreen(
              teamData: team,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: gold, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: gold.withOpacity(0.25),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          children: [
            /// TEAM LOGO
            CircleAvatar(
              radius: 26,
              backgroundColor: gold,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.black,
                backgroundImage: NetworkImage(team["logo_url"]),
              ),
            ),

            const SizedBox(width: 16),

            /// TEAM INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team["team_name"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Leader: ${team["team_leader"]}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    team["team_id"],
                    style: TextStyle(
                      color: gold,
                      fontSize: 12,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),

            /// ARROW ICON (UX CLUE)
            const Icon(
              Icons.chevron_right,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}
