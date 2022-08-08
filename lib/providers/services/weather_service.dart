import 'package:flutter/foundation.dart';

import '../../utils/api_manager.dart';

class WeatherService {
  static const _apiKey = "f3c4da765ddc276e67190242c6dcb9dd";
  static const _weatherAuthority = "api.openweathermap.org";
  static const _currentWeatherApi = "/data/2.5/weather";
  static const _forecastApi = "/data/2.5/forecast";

  //? method to fetch the data of current weather api
  Future<dynamic> getCurrentWeather(String lat, String lon) async {
    final queryParams = {
      "lat": lat,
      "lon": lon,
      "appid": _apiKey,
    };
    final uri = Uri.https(
      _weatherAuthority,
      _currentWeatherApi,
      queryParams,
    );
    try {
      return await APIManager.getAPICall(uri);
    } catch (error) {
      if (kDebugMode) {
        print("error in getCurrentWeather api: $error");
        rethrow;
      }
    }
  }

  //? method to fetch the data of 5 days forecasts api
  Future<dynamic> getForecasts(String lat, String lon) async {
    final queryParams = {
      "lat": lat,
      "lon": lon,
      "appid": _apiKey,
    };
    final uri = Uri.https(
      _weatherAuthority,
      _forecastApi,
      queryParams,
    );
    try {
      return await APIManager.getAPICall(uri);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }
}
