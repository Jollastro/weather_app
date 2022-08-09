import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/providers/services/weather_service.dart';

import '../models/forecasts.dart';
import '../models/weather.dart';

class AppProvider with ChangeNotifier {
  //? service that handles api calls to weather.org
  late final WeatherService _weatherService;

  //? property used to avoid local storaging in tests
  late final bool _isTest;

  //? prefs utilised for local storaging, in order to retrieve old data
  //? if there is no internet connection
  late final SharedPreferences _prefs;

  //? completer utilised to notice when the data are all fetched
  final Completer _dataFetched = Completer();

  //? static variables with coordinates of London
  static const _lat = "51.509865";
  static const _lon = "-0.118092";

  //? variables that contain my data
  Weather? _currentWeather;
  Forecasts? _forecasts;

  //? initializer function (it prepares prefs, fetches the data
  //? and then set the completer as completed)
  Future<void> _initializeApp() async {
    if (!_isTest) {
      _prefs = await SharedPreferences.getInstance();
    }
    await getAndSetCurrentWeather(_lat, _lon);
    await getAndSetForecasts(_lat, _lon);
    _dataFetched.complete();
    notifyListeners();
  }

  //? getters
  bool get isTest => _isTest;
  Completer get dataFetched => _dataFetched;

  Weather? get currentWeather => _currentWeather;
  Forecasts? get forecasts => _forecasts;

  String get lat => _lat;
  String get lon => _lon;

  Function get initializeApp => _initializeApp;

  AppProvider({required WeatherService weatherService, bool isTest = false}) {
    _weatherService = weatherService;
    _isTest = isTest;
  }

  //? get current weather data and set it on the variable
  Future<void> getAndSetCurrentWeather(String lat, String lon) async {
    final dynamic weatherResponse;
    try {
      weatherResponse = await _weatherService.getCurrentWeather(lat, lon);
    }
    //? if thers is no internet connection I will enter on exception and get the data from prefs
    on Exception {
      if (!_isTest) {
        var stringCurrentWeather = _prefs.getString("currentWeather");
        if (stringCurrentWeather != null) {
          var jsonCurrentWeather = json.decode(stringCurrentWeather);
          _currentWeather = Weather(
            weatherDescription: jsonCurrentWeather["weatherDescription"],
            iconCode: jsonCurrentWeather["iconCode"],
            currentTemperature: jsonCurrentWeather["currentTemperature"],
            minTemperature: jsonCurrentWeather["minTemperature"],
            maxTemperature: jsonCurrentWeather["maxTemperature"],
            humidityPercentage: jsonCurrentWeather["humidityPercentage"],
            lastUpdate: DateTime.parse(jsonCurrentWeather["lastUpdate"]),
          );
        }
      }
      return;
    }
    // if (kDebugMode) {
    //   print("Response: $weatherResponse");
    // }
    //? otherwise, if there is connection then I take the data from the api
    _currentWeather = Weather(
      weatherDescription: weatherResponse["weather"][0]["description"],
      iconCode: weatherResponse["weather"][0]["icon"],
      currentTemperature: weatherResponse["main"]["temp"] / 10.0,
      minTemperature: weatherResponse["main"]["temp_min"] / 10.0,
      maxTemperature: weatherResponse["main"]["temp_max"] / 10.0,
      humidityPercentage: weatherResponse["main"]["humidity"],
      lastUpdate:
          DateTime.fromMillisecondsSinceEpoch(weatherResponse["dt"] * 1000),
    );
    if (!_isTest) {
      //? then I set the data on prefs
      _prefs.setString(
        "currentWeather",
        json.encode(
          {
            "weatherDescription": currentWeather!.weatherDescription,
            "iconCode": currentWeather!.iconCode,
            "currentTemperature": currentWeather!.currentTemperature,
            "minTemperature": currentWeather!.minTemperature,
            "maxTemperature": currentWeather!.maxTemperature,
            "humidityPercentage": currentWeather!.humidityPercentage,
            "lastUpdate": currentWeather!.lastUpdate.toIso8601String(),
          },
        ),
      );
    }
  }

  //? get 5 days forecasts data and set them on the variable
  Future<void> getAndSetForecasts(String lat, String lon) async {
    final dynamic forecastsResponse;
    try {
      forecastsResponse = await _weatherService.getForecasts(lat, lon);
    }
    //? if thers is no internet connection I will enter on exception and get the data from prefs
    on Exception {
      if (!_isTest) {
        List<Weather> weathers = [];
        for (var j = 0; j < 5; j++) {
          var stringListForecasts = _prefs.getStringList("forecasts$j");
          if (stringListForecasts != null) {
            for (var stringForecasts in stringListForecasts) {
              var jsonForecasts = json.decode(stringForecasts);
              weathers.add(
                Weather(
                  weatherDescription: jsonForecasts["weatherDescription"],
                  iconCode: jsonForecasts["iconCode"],
                  currentTemperature: jsonForecasts["currentTemperature"],
                  minTemperature: jsonForecasts["minTemperature"],
                  maxTemperature: jsonForecasts["maxTemperature"],
                  humidityPercentage: jsonForecasts["humidityPercentage"],
                  lastUpdate: DateTime.parse(jsonForecasts["lastUpdate"]),
                ),
              );
            }
          }
        }
        final List<List<Weather>> weathersPerDay = [
          [],
          [],
          [],
          [],
          [],
        ];
        var i = 0;
        var count = 0;
        for (var weather in weathers) {
          if (count == 8) {
            i++;
            count = 0;
          }
          weathersPerDay[i].add(weather);
          count++;
        }
        _forecasts = Forecasts(weathers: weathersPerDay);
      }
      return;
    }
    // if (kDebugMode) {
    //   print("Response: $forecastsResponse");
    // }
    //? otherwise, if there is connection then I take the data from the api
    final List<Weather> weathers = [];
    final today = DateTime.now().day;
    for (var weather in forecastsResponse["list"]) {
      if (DateTime.fromMillisecondsSinceEpoch(weather["dt"] * 1000).day ==
          today) {
        continue;
      }
      weathers.add(
        Weather(
          weatherDescription: weather["weather"][0]["description"],
          iconCode: weather["weather"][0]["icon"],
          currentTemperature: weather["main"]["temp"] / 10.0,
          minTemperature: weather["main"]["temp_min"] / 10.0,
          maxTemperature: weather["main"]["temp_max"] / 10.0,
          humidityPercentage: weather["main"]["humidity"],
          lastUpdate: DateTime.fromMillisecondsSinceEpoch(weather["dt"] * 1000),
        ),
      );
    }
    final List<List<Weather>> weathersPerDay = [
      [],
      [],
      [],
      [],
      [],
    ];
    var i = 0;
    var count = 0;
    List<String> jsonList = [];
    var weathersLeft = weathers.length;
    for (var weather in weathers) {
      weathersPerDay[i].add(weather);
      jsonList.add(
        json.encode(
          {
            "weatherDescription": weather.weatherDescription,
            "iconCode": weather.iconCode,
            "currentTemperature": weather.currentTemperature,
            "minTemperature": weather.minTemperature,
            "maxTemperature": weather.maxTemperature,
            "humidityPercentage": weather.humidityPercentage,
            "lastUpdate": weather.lastUpdate.toIso8601String(),
          },
        ),
      );
      count++;
      weathersLeft--;
      if (count == 8 || weathersLeft == 0) {
        if (!_isTest) {
          //? then I set the data on prefs
          _prefs.setStringList(
            "forecasts$i",
            jsonList,
          );
        }
        jsonList = [];
        i++;
        count = 0;
      }
    }
    _forecasts = Forecasts(weathers: weathersPerDay);
  }
}
