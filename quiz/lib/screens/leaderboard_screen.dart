import 'package:flutter/material.dart';
import '../services/database_service.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Map<String, dynamic>> _scores = [];

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  void _loadScores() async {
    List<Map<String, dynamic>> scores = await DatabaseService.getScores();
    setState(() {
      _scores = scores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: Color(0xff075E54),
      ),
      body: _scores.isEmpty
          ? Center(child: Text('No scores yet'))
          : ListView.builder(
              itemCount: _scores.length,
              itemBuilder: (context, index) {
                var score = _scores[index];
                return ListTile(
                  leading: Text(
                    '#${index + 1}',
                    style: TextStyle(fontSize: 20),
                  ),
                  title: Text(score['name']),
                  trailing: Text(
                    score['score'].toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
    );
  }
}
