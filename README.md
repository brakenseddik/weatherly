# Weatherly

Weatherly is a Flutter package designed to fetch and display weather data from a specified endpoint. It provides a customizable widget that accepts a `Location` and `Date` as parameters to display the weather information.

## Features

- Fetch weather data from an endpoint
- Display a widget that shows weather details based on a provided `Location` and `Date`
- Customizable styles and decorations for the widget
- Supports fetching location suggestions
- Handles error scenarios gracefully

## Getting Started

### Prerequisites

To use Weatherly, you need to have Flutter installed on your machine. For detailed instructions, visit the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).

### Installation

Add the following dependency to your `pubspec.yaml` file:

This package has not been published yet, so it is available via Github only on [Github Package link](https://github.com/brakenseddik/weatherly)
```yaml
dependencies:
  weatherly:
    git:
      url: https://github.com/brakenseddik/weatherly.git
```
Then, run dart pub get to install the package.

### Basic Usage
Here's a basic example of how to use the Weatherly package in your Flutter application.
Use [WeatherAPI](https://www.weatherapi.com/ to generate a free API Key

Import the Package
```
import 'package:weatherly/weatherly.dart';
```
Then make this small widget
Don't forget to replace with your own API key

```
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/weatherly.dart';

void main() {
  WeatherlyConfig().initialize('ENTER_YOUR_KEY_HERE');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      appBar: AppBar(
        title: const Text('Weather Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
               WeatherlyDetailsWidget(),      
            ],
          ),
        ),
      ),
    )
    );
  }
}

```
