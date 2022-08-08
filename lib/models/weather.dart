class Weather {
  final String _weatherDescription;
  final String _iconCode;
  final double _currentTemperature;
  final double _minTemperature;
  final double _maxTemperature;
  final int _humidityPercentage;
  final DateTime _lastUpdate;

  Weather({
    required weatherDescription,
    required iconCode,
    required currentTemperature,
    required minTemperature,
    required maxTemperature,
    required humidityPercentage,
    required lastUpdate,
  })  : _weatherDescription = weatherDescription,
        _iconCode = iconCode,
        _currentTemperature = currentTemperature,
        _minTemperature = minTemperature,
        _maxTemperature = maxTemperature,
        _humidityPercentage = humidityPercentage,
        _lastUpdate = lastUpdate;

  String get weatherDescription => _weatherDescription;
  String get iconCode => _iconCode;
  double get currentTemperature => _currentTemperature;
  double get minTemperature => _minTemperature;
  double get maxTemperature => _maxTemperature;
  int get humidityPercentage => _humidityPercentage;
  DateTime get lastUpdate => _lastUpdate;
}
