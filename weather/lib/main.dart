import 'package:flutter/material.dart';
import 'dart:math'; // For generating random numbers

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Info App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherInfoPage(),
    );
  }
}
ppp
class WeatherInfoPage extends StatefulWidget {
  @override
  _WeatherInfoPageState createState() => _WeatherInfoPageState();
}

class _WeatherInfoPageState extends State<WeatherInfoPage> {
  final TextEditingController _cityController = TextEditingController();
  String cityName = "";
  String temperature = "";
  String weatherCondition = "";

  // Function to simulate fetching weather data
  void fetchWeather() {
    setState(() {
      cityName = _cityController.text;
      temperature = "${_generateRandomTemperature()}°C"; // Random temperature
      weatherCondition =
          _getRandomWeatherCondition(); // Random weather condition
    });
  }

  // Generates a random temperature between 15°C and 30°C
  int _generateRandomTemperature() {
    Random random = Random();
    return 15 + random.nextInt(16); // Generates a number between 15 and 30
  }

  // Randomly selects a weather condition: sunny, cloudy, or rainy
  String _getRandomWeatherCondition() {
    List<String> conditions = ["Sunny", "Cloudy", "Rainy"];
    Random random = Random();
    return conditions[random.nextInt(3)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Info App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input field for city name
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter City Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Button to fetch weather
            ElevatedButton(
              onPressed: fetchWeather,
              child: Text('Fetch Weather'),
            ),
            SizedBox(height: 20),
            // Displaying the entered city name
            Text(
              'City: $cityName',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            // Displaying the generated temperature
            Text(
              'Temperature: $temperature',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            // Displaying the generated weather condition
            Text(
              'Weather Condition: $weatherCondition',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
