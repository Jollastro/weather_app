import 'package:weather_app/models/weather.dart';

class Forecasts {
  final List<List<Weather>> _weathers;

  Forecasts({required weathers}) : _weathers = weathers;

  List<List<Weather>> get weathers => _weathers;
}
