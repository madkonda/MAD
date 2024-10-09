import 'package:flutter/material.dart';
import 'dart:async';

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
  List<bool> _cardMatches = List.generate(16, (index) => false);
  List<String> _cardValues = [
    'A',
    'B',
    'C',
    'D',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'E',
    'F',
    'G',
    'H',
    'G',
    'H'
  ];
  List<int> _selectedIndexes = [];
  int _score = 0;
  int _timer = 0;
  late Timer _gameTimer;
  late DateTime _firstCardFlipTime;
  bool _firstCardFlipped = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _cardValues.shuffle(); // Shuffle the cards for randomness
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

        if (!_firstCardFlipped) {
          _firstCardFlipTime = DateTime.now();
          _firstCardFlipped = true;
        }
      });

      if (_selectedIndexes.length == 2) {
        if (_cardValues[_selectedIndexes[0]] ==
            _cardValues[_selectedIndexes[1]]) {
          _handleMatch();
        } else {
          _handleMismatch();
        }
      }
    }
  }

  void _handleMatch() {
    final timeTaken = DateTime.now().difference(_firstCardFlipTime).inSeconds;
    if (timeTaken <= 3) {
      _score += 15; // 10 points for match + 5 bonus for fast match
    } else {
      _score += 10; // Regular match points
    }

    setState(() {
      _cardMatches[_selectedIndexes[0]] = true;
      _cardMatches[_selectedIndexes[1]] = true;
      _selectedIndexes.clear();
      _firstCardFlipped = false;

      if (_cardMatches.every((match) => match == true)) {
        _showWinDialog();
        _gameTimer.cancel(); // Stop the timer when the game is won
      }
    });
  }

  void _handleMismatch() {
    _score -= 5;
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _cardFlips[_selectedIndexes[0]] = false;
        _cardFlips[_selectedIndexes[1]] = false;
        _selectedIndexes.clear();
        _firstCardFlipped = false;
      });
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("You Win!"),
          content: Text(
              "Congratulations, you've matched all the cards!\nTime taken: $_timer seconds\nScore: $_score"),
          actions: [
            TextButton(
              child: Text("Play Again"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _cardFlips = List.generate(16, (index) => false);
      _cardMatches = List.generate(16, (index) => false);
      _selectedIndexes.clear();
      _score = 0;
      _timer = 0;
      _cardValues.shuffle();
      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Matching Game'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Text('Time: $_timer s', style: TextStyle(fontSize: 18))),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Text('Score: $_score', style: TextStyle(fontSize: 18))),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemCount: 16,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _flipCard(index);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: _cardMatches[index]
                      ? Colors.green // Green for matched cards
                      : _cardFlips[index]
                          ? Colors.blue // Blue for flipped cards
                          : Colors.grey, // Grey for default face-down cards
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _cardFlips[index] ? _cardValues[index] : 'X',
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _gameTimer.cancel();
    super.dispose();
  }
}
