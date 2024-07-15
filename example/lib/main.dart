import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:weatherly/weatherly.dart';

void main() {
  WeatherlyConfig().initialize('9270c145786e45c0ab3141941241307');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WeatherSearchPage(),
    );
  }
}

class WeatherSearchPage extends StatefulWidget {
  const WeatherSearchPage({super.key});

  @override
  _WeatherSearchPageState createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends State<WeatherSearchPage> {
  final WeatherlyService weatherApi = WeatherlyService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const WeatherlyDetailsWidget(),
              SizedBox(
                width: 350,
                child: ElevatedButton(
                    onPressed: () async {
                      final weatherData =
                          await weatherApi.getForecast(-12.24, 54.11, 10);
                      print("weatherData: $weatherData");
                    },
                    child: const Text('Get forecast')),
              ),
              SizedBox(
                width: 350,
                child: ElevatedButton(
                    onPressed: () async {
                      final weatherData =
                          await weatherApi.getCurrentWeather(-12.24, 54.11);
                      print("Current weather: $weatherData");
                    },
                    child: const Text('Get current weather')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
