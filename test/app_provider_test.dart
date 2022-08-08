import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/providers/app_provider.dart';
import 'package:weather_app/providers/services/weather_service.dart';

import 'samples.dart';

class MockWeatherService extends Mock implements WeatherService {}

void main() {
  late AppProvider sut;
  late MockWeatherService mockWeatherService;

  final currentWeather = currentWeatherSample;
  final forecasts = forecastsSample;

  setUp(
    () {
      mockWeatherService = MockWeatherService();
      sut = AppProvider(weatherService: mockWeatherService, isTest: true);
    },
  );

  void arrangeWeatherServiceReturns1Weather() {
    when(
      () => mockWeatherService.getCurrentWeather(any(), any()),
    ).thenAnswer(
      (_) async => currentWeather,
    );
  }

  void arrangeWeatherServiceReturns5DaysForecasts() {
    when(
      () => mockWeatherService.getForecasts(any(), any()),
    ).thenAnswer(
      (_) async => forecasts,
    );
  }

  group(
    "initialize app",
    () {
      test(
        "initial values are correct",
        () {
          expect(sut.lat, "51.509865");
          expect(sut.lon, "-0.118092");
          expect(sut.dataFetched.isCompleted, false);
        },
      );
      group(
        'getAndSetCurrentWeather',
        () {
          test(
            "getCurrentWeather is called once using the WeatherService",
            () async {
              arrangeWeatherServiceReturns1Weather();
              await sut.getAndSetCurrentWeather(sut.lat, sut.lon);
              verify(
                () => mockWeatherService.getCurrentWeather(sut.lat, sut.lon),
              ).called(1);
            },
          );
          test(
            "getAndSetCurrentWeather sets the currentWeather to the currentWeather property",
            () async {
              arrangeWeatherServiceReturns1Weather();
              await sut.getAndSetCurrentWeather(sut.lat, sut.lon);
              expect(sut.currentWeather, isNotNull);
            },
          );
        },
      );
      group(
        'getAndSetForecasts',
        () {
          test(
            "getForecasts is called once using the WeatherService",
            () async {
              arrangeWeatherServiceReturns5DaysForecasts();
              await sut.getAndSetForecasts(sut.lat, sut.lon);
              verify(
                () => mockWeatherService.getForecasts(sut.lat, sut.lon),
              ).called(1);
            },
          );
          test(
            "getAndSetForecasts sets the forecasts to the forecasts property",
            () async {
              arrangeWeatherServiceReturns5DaysForecasts();
              await sut.getAndSetForecasts(sut.lat, sut.lon);
              expect(sut.forecasts, isNotNull);
            },
          );
        },
      );
      test(
        "data is not being loaded anymore",
        () async {
          arrangeWeatherServiceReturns1Weather();
          arrangeWeatherServiceReturns5DaysForecasts();
          final currentWeatherFetched = sut.getAndSetCurrentWeather(
            sut.lat,
            sut.lon,
          );
          final forecastsFetched = sut.getAndSetForecasts(
            sut.lat,
            sut.lon,
          );
          expect(sut.dataFetched.isCompleted, false);
          await currentWeatherFetched;
          await forecastsFetched;
          await sut.initializeApp();
          expect(sut.dataFetched.isCompleted, true);
        },
      );
    },
  );
}
