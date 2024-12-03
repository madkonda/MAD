import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '/screens/summary_screen.dart';
import '/services/api_service.dart';
import '/widgets/timer_widget.dart';
import 'package:html_unescape/html_unescape.dart';

class QuizScreen extends StatefulWidget {
  final String playerName;
  final int numberOfQuestions;
  final String category;
  final String difficulty;
  final String type;

  QuizScreen({
    required this.playerName,
    required this.numberOfQuestions,
    required this.category,
    required this.difficulty,
    required this.type,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<dynamic>> _questionsFuture;
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  bool _isAnswered = false;
  String _feedback = '';
  Timer? _timer;
  int _timeLeft = 15;
  Map<int, Map<String, dynamic>> _answers = {};
  String? _selectedAnswer;
  final HtmlUnescape _unescape = HtmlUnescape();

  @override
  void initState() {
    super.initState();
    _questionsFuture = _loadQuestions();
  }

  Future<List<dynamic>> _loadQuestions() async {
    List<dynamic> questions = await ApiService.getQuestions(
      amount: widget.numberOfQuestions,
      category: widget.category,
      difficulty: widget.difficulty,
      type: widget.type,
    );
    if (mounted) {
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    }
    _startTimer();
    return questions;
  }

  void _startTimer() {
    _timeLeft = 15;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0 && !_isAnswered) {
        if (mounted) {
          setState(() {
            _timeLeft--;
          });
        }
      } else {
        _timer?.cancel();
        if (!_isAnswered) {
          _handleAnswer(null);
        }
      }
    });
  }

  void _handleAnswer(String? selectedAnswer) {
    _isAnswered = true;
    _selectedAnswer = selectedAnswer;

    String correctAnswer = String.fromCharCodes(
        base64Decode(_questions[_currentQuestionIndex]['correct_answer']));
    bool isCorrect = selectedAnswer == correctAnswer;

    if (isCorrect) {
      _score++;
      _feedback = 'Correct!';
    } else if (selectedAnswer == null) {
      _feedback = 'Time\'s up! The correct answer was: $correctAnswer';
    } else {
      _feedback = 'Incorrect! The correct answer was: $correctAnswer';
    }

    _answers[_currentQuestionIndex] = {
      'question': String.fromCharCodes(
          base64Decode(_questions[_currentQuestionIndex]['question'])),
      'selectedAnswer': selectedAnswer,
      'correctAnswer': correctAnswer,
      'isCorrect': isCorrect,
    };

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        if (_currentQuestionIndex < _questions.length - 1) {
          setState(() {
            _currentQuestionIndex++;
            _isAnswered = false;
            _feedback = '';
            _selectedAnswer = null;
          });
          _startTimer();
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SummaryScreen(
                playerName: widget.playerName,
                score: _score,
                totalQuestions: _questions.length,
                answers: _answers,
              ),
            ),
          );
        }
      }
    });
  }

  Widget _buildOptions(List<String> options, String correctAnswer) {
    return Column(
      children: options.map((option) {
        String decodedOption = String.fromCharCodes(base64Decode(option));
        bool isCorrectOption = decodedOption == correctAnswer;
        bool isSelectedOption = decodedOption == _selectedAnswer;

        Color buttonColor = Colors.grey[200]!;
        if (_isAnswered) {
          if (isCorrectOption) {
            buttonColor = Colors.yellow;
          } else if (isSelectedOption) {
            buttonColor = Colors.red;
          }
        }

        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: ElevatedButton(
            onPressed: _isAnswered ? null : () => _handleAnswer(decodedOption),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              disabledBackgroundColor: buttonColor,
            ),
            child: Text(
              decodedOption,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuestion() {
    var question = _questions[_currentQuestionIndex];
    List<String> options =
        List<String>.from(question['incorrect_answers'] as List<dynamic>);
    options.add(question['correct_answer']);
    options.shuffle();

    String decodedQuestion =
        String.fromCharCodes(base64Decode(question['question']));
    String correctAnswer =
        String.fromCharCodes(base64Decode(question['correct_answer']));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _questions.length,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff25D366)),
        ),
        SizedBox(height: 20),
        Text(
          decodedQuestion,
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 20),
        _buildOptions(options, correctAnswer),
        SizedBox(height: 20),
        _feedback.isNotEmpty
            ? Text(
                _feedback,
                style: TextStyle(
                  fontSize: 18,
                  color:
                      _feedback.contains('Correct') ? Colors.green : Colors.red,
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Time'),
        backgroundColor: Color(0xff075E54),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: _buildQuestion(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TimerWidget(timeLeft: _timeLeft),
                ),
              ],
            ),
    );
  }
}
