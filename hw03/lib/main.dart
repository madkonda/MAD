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

  void _flipCard(int index) {
    if (_selectedIndexes.length < 2 && !_cardFlips[index]) {
      setState(() {
        _cardFlips[index] = !_cardFlips[index];
        _selectedIndexes.add(index);
      });

      if (_selectedIndexes.length == 2) {
        if (_cardValues[_selectedIndexes[0]] ==
            _cardValues[_selectedIndexes[1]]) {
          _selectedIndexes.clear();
        } else {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Card Matching Game')),
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
              child: Card(
                child: Center(
                  child: Text(
                    _cardFlips[index] ? _cardValues[index] : 'X',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
