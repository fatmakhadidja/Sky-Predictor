import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService(apiKey: 'f0e4880079656d94e65dd99fa5cb81d9');
  Weather? _weather;

  _fetchWeather() async {
    try {
      // Request location permission
      var status = await Permission.location.request();
      if (status.isGranted) {
        // Only fetch weather if permission is granted
        String cityName = await _weatherService.getCurrentCity();
        final weather = await _weatherService.getWeather(cityName);
        setState(() {
          _weather = weather;
        });
      } else {
        // Handle the case where permission is denied
        print('Location permission denied');
      }
    } catch (e) {
      print('Error while fetching the weather: $e');
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/clouds.json';
      case 'shower rain':
        return 'assets/rain.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'fog':
        return 'assets/fog.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF131638),
      body: Center(
        child: _weather == null
            ? CircularProgressIndicator()
            : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(height: 8),
              Text(
                _weather!.cityName,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              Lottie.asset(getWeatherAnimation(_weather!.mainCondition)),
              SizedBox(height: 40),
              Text(
                '${_weather!.temperature.round()}°C',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              Text(
                _weather!.mainCondition,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
