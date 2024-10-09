import 'package:flutter/material.dart';
import 'dart:math';

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

class WeatherInfoPage extends StatefulWidget {
  @override
  _WeatherInfoPageState createState() => _WeatherInfoPageState();
}

class _WeatherInfoPageState extends State<WeatherInfoPage> {
  final TextEditingController _cityController = TextEditingController();
  String cityName = "";
  String temperature = "";
  String weatherCondition = "";

  // 7-day weather forecast list
  List<Map<String, String>> weeklyForecast = [];

  // Function to simulate fetching current weather data
  void fetchWeather() {
    setState(() {
      cityName = _cityController.text;
      temperature = "${_generateRandomTemperature()}°C"; // Random temperature
      weatherCondition =
          _getRandomWeatherCondition(); // Random weather condition
    });
  }

  // Function to simulate fetching 7-day weather forecast
  void fetch7DayForecast() {
    setState(() {
      cityName = _cityController.text;
      weeklyForecast = List.generate(7, (index) {
        return {
          "day": _getDayOfWeek(index),
          "temperature": "${_generateRandomTemperature()}°C",
          "condition": _getRandomWeatherCondition(),
        };
      });
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

  // Gets the day of the week based on the index (e.g., 0 = Today, 1 = Tomorrow, etc.)
  String _getDayOfWeek(int dayIndex) {
    List<String> days = [
      "Today",
      "Tomorrow",
      "Day 3",
      "Day 4",
      "Day 5",
      "Day 6",
      "Day 7"
    ];
    return days[dayIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Info App'),
      ),
      body: SingleChildScrollView(
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
            // Button to fetch current weather
            ElevatedButton(
              onPressed: fetchWeather,
              child: Text('Fetch Weather'),
            ),
            SizedBox(height: 20),
            // Button to fetch 7-day forecast
            ElevatedButton(
              onPressed: fetch7DayForecast,
              child: Text('Fetch 7-Day Forecast'),
            ),
            SizedBox(height: 20),
            // Displaying the entered city name and current weather data
            Text(
              'City: $cityName',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Temperature: $temperature',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Weather Condition: $weatherCondition',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            // Displaying the 7-day weather forecast if available
            if (weeklyForecast.isNotEmpty) ...[
              Text(
                '7-Day Weather Forecast:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Loop through the forecast and display each day's data
              Column(
                children: weeklyForecast.map((dayForecast) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(dayForecast['day']!),
                      subtitle: Text(
                          "Temp: ${dayForecast['temperature']} | Condition: ${dayForecast['condition']}"),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
