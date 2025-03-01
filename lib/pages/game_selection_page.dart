import 'package:flutter/material.dart';
import 'package:quicc/pages/flip_a_coin.dart';
import 'package:quicc/pages/rock_paper_scissors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GameSelectionPage extends StatelessWidget {
  final String decisionTitle;
  final String decisionDescription;

  const GameSelectionPage({
    super.key,
    required this.decisionTitle,
    required this.decisionDescription,
  });

  Future<void> _saveGameData(String gameType, String result) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve existing game data
    final String? gamesJson = prefs.getString('games');
    List<Map<String, dynamic>> games = [];
    if (gamesJson != null) {
      games = List<Map<String, dynamic>>.from(json.decode(gamesJson));
    }

    // Add new game data
    games.add({
      'title': decisionTitle,
      'description': decisionDescription,
      'gameType': gameType,
      'result': result,
    });

    // Save updated game data back to SharedPreferences
    await prefs.setString('games', json.encode(games));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF84DCC6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0), // Height of the AppBar
        child: Material(
          elevation: 4.0, // Drop shadow elevation
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20.0), // Rounds the bottom corners
          ),
          color: const Color(0xFFFF686B), // AppBar background color
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: const Color(0xFFFF686B),
              elevation:
                  0.0, // Remove AppBar's default shadow to avoid duplication
              title: const Text(
                "Choose a Game",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "50/50 Chances",
                style: TextStyle(
                  color: Color(0xFFFF686B),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(color: Color(0xFFFF686B), thickness: 1.5),
              const SizedBox(height: 10),
              _buildGameOption(
                context,
                title: "Flip a Coin",
                description:
                    "One person calls heads or tails before the coin is flipped.",
                icon: Icons.paid,
                onTap: () async {
                  await _saveGameData("Flip a Coin", "Won");
                  if (!context.mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FlipACoinPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildGameOption(
                context,
                title: "Rock, Paper, Scissors",
                description:
                    "A quick game where rock beats scissors, scissors beat paper, and paper beats rock.",
                icon: Icons.content_cut,
                onTap: () async {
                  await _saveGameData("Rock, Paper, Scissors", "Lost");
                  if (context.mounted) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RockPaperScissors(),
                    ));
                  }
                },
              ),
              const SizedBox(height: 10),
              _buildGameOption(
                context,
                title: "Pick a Hand",
                description:
                    "One person hides a ball in one hand, and the other person guesses which hand.",
                icon: Icons.back_hand,
                onTap: () async {
                  await _saveGameData("Pick a Hand", "Won");
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "Custom Chances",
                style: TextStyle(
                  color: Color(0xFFFF686B),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(color: Color(0xFFFF686B), thickness: 1.5),
              const SizedBox(height: 10),
              _buildGameOption(
                context,
                title: "Roll a Dice",
                description:
                    "Assign numbers to each option and roll a custom-sided dice.",
                icon: Icons.casino,
                onTap: () async {
                  await _saveGameData("Roll a Dice", "Lost");
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 10),
              _buildGameOption(
                context,
                title: "Spin Wheel",
                description: "Use a spinning wheel with the options listed.",
                icon: Icons.pie_chart,
                onTap: () async {
                  await _saveGameData("Spin Wheel", "Won");
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 10),
              _buildGameOption(
                context,
                title: "RNG",
                description: "Custom range random number generator.",
                icon: Icons.pin,
                onTap: () async {
                  await _saveGameData("RNG", "Won");
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameOption(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFF686B),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(123, 0, 0, 0),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
