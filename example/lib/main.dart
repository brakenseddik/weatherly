import 'package:flutter/material.dart';
import 'package:weatherly/weatherly.dart';

void main() {
  WeatherlyConfig().initialize(
    'ENTER_YOUR_API_KEY_HERE',
    tempUnit: TemperatureUnit.celsius,
  );
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
        backgroundColor: Colors.amber,
        title: const Text('Weather Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              WeatherlyDetailsWidget(
                submitButtonStyle: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                dateStyle: const TextStyle(
                  fontSize: 28,
                ),
                temperatureStyle: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                conditionStyle: const TextStyle(
                  fontSize: 22,
                ),
                containerColor: Colors.grey[200],
                onError: (WeatherlyError error) {
                  print("onError: $error");
                },
              ),
              const SizedBox(
                height: 16,
              ),
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
              const SizedBox(
                height: 16,
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
