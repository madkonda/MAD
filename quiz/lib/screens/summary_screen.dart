import 'package:flutter/material.dart';
import '/screens/setup_screen.dart';
import '/services/database_service.dart';
import 'package:html_unescape/html_unescape.dart';

class SummaryScreen extends StatelessWidget {
  final String playerName;
  final int score;
  final int totalQuestions;
  final Map<int, Map<String, dynamic>> answers;
  final HtmlUnescape _unescape = HtmlUnescape();

  SummaryScreen({
    required this.playerName,
    required this.score,
    required this.totalQuestions,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    // Save score to leaderboard
    DatabaseService.saveScore(playerName, score);

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Summary'),
        backgroundColor: Color(0xff075E54),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Well done, $playerName!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Your Score: $score / $totalQuestions',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: answers.length,
                itemBuilder: (context, index) {
                  var answer = answers[index]!;
                  return Card(
                    child: ListTile(
                      title: Text(_unescape.convert(answer['question'])),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Your Answer: ${answer['selectedAnswer'] ?? 'No Answer'}'),
                          Text('Correct Answer: ${answer['correctAnswer']}'),
                        ],
                      ),
                      trailing: Icon(
                        answer['isCorrect'] ? Icons.check_circle : Icons.cancel,
                        color: answer['isCorrect'] ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SetupScreen(playerName: playerName)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff25D366),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text(
                'Play Again',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
