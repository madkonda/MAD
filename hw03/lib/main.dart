import 'package:flutter/material.dart';

void main() => runApp(CardMatchingGame());

class CardMatchingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Matching Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}
class _GameScreenState extends State<GameScreen> {
  List<bool> _cardFlips = List.generate(16, (index) => false);
  List<String> _cardValues = ['A', 'B', 'C', 'D', 'A', 'B', 'C', 'D', 'E', 'F', 'E', 'F', 'G', 'H', 'G', 'H'];
  List<int> _selectedIndexes = [];
  int _score = 0;
  int _timer = 0;
  late Timer _gameTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timer++;
      });
    });
  }

  void _flipCard(int index) {
    if (_selectedIndexes.length < 2 && !_cardFlips[index]) {
      setState(() {
        _cardFlips[index] = !_cardFlips[index];
        _selectedIndexes.add(index);
      });

      if (_selectedIndexes.length == 2) {
        if (_cardValues[_selectedIndexes[0]] == _cardValues[_selectedIndexes[1]]) {
          _selectedIndexes.clear();
          _score += 10;
          if (_cardFlips.every((flip) => flip == true)) {
            _showWinDialog();
          }
        } else {
          _score -= 5;
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _cardFlips[_selectedIndexes[0]] = false;
              _cardFlips[_selectedIndexes[1]] = false;
              _selectedIndexes.clear();
            });
          });
        }
      }
    }
  }

  void _showWinDialog() {
   
