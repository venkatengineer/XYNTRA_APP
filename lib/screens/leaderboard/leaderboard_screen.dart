import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  static const Color gold = Color(0xFFD4AF37);

  bool isLoading = true;

  List<Map<String, dynamic>> leaderboard = [];

  String selectedCategory = "Overall";

  final List<String> categories = [
    "Overall",
    "Communication",
    "Scalability",
    "UI / UX",
    "Innovation",
    "Technical Implementation",
  ];

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.29.72:8000/all-marks"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<Map<String, dynamic>> submissions =
            List<Map<String, dynamic>>.from(data["submissions"]);

        leaderboard = submissions;
        sortLeaderboard();

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  /// 🔥 SORT LOGIC
  void sortLeaderboard() {
    if (selectedCategory == "Overall") {
      leaderboard.sort(
        (a, b) => b["total_score"].compareTo(a["total_score"]),
      );
    } else {
      leaderboard.sort((a, b) {
        final aScore = a["scores"]?[selectedCategory] ?? 0;
        final bScore = b["scores"]?[selectedCategory] ?? 0;
        return bScore.compareTo(aScore);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("LEADERBOARD"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: gold),
            )
          : leaderboard.isEmpty
              ? const Center(
                  child: Text(
                    "No submissions yet",
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              : Column(
                  children: [
                    /// 🔽 SORT DROPDOWN
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        dropdownColor: Colors.black,
                        iconEnabledColor: gold,
                        decoration: InputDecoration(
                          labelText: "Sort by",
                          labelStyle:
                              const TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: gold),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: gold, width: 2),
                          ),
                        ),
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(
                              category,
                              style:
                                  const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                            sortLeaderboard();
                          });
                        },
                      ),
                    ),

                    /// 🏆 LEADERBOARD LIST
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: leaderboard.length,
                        itemBuilder: (context, index) {
                          final team = leaderboard[index];

                          final displayScore =
                              selectedCategory == "Overall"
                                  ? team["total_score"]
                                  : team["scores"]?[selectedCategory] ?? 0;

                          return _leaderboardCard(
                            rank: index + 1,
                            teamId: team["team_id"],
                            score: displayScore,
                            label: selectedCategory,
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _leaderboardCard({
    required int rank,
    required String teamId,
    required num score,
    required String label,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: gold, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: gold.withOpacity(0.25),
            blurRadius: 18,
          ),
        ],
      ),
      child: Row(
        children: [
          /// RANK
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: gold, width: 2),
            ),
            child: Center(
              child: Text(
                "#$rank",
                style: const TextStyle(
                  color: gold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          /// TEAM INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teamId,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label == "Overall" ? "Total Score" : label,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          /// SCORE
          Text(
            score.toString(),
            style: TextStyle(
              color: gold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
