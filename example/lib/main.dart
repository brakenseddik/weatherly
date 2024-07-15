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
  final WeatherApi weatherApi = WeatherApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Search'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              WeatherDetailsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
