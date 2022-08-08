import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:weather_app/providers/app_provider.dart';
import 'package:weather_app/providers/services/weather_service.dart';
import 'package:weather_app/screens/main_page.dart';
import 'package:weather_app/widgets/current_weather.dart';
import 'package:weather_app/widgets/five_days_forecasts.dart';
import 'package:weather_app/widgets/one_day_forecasts.dart';

import 'samples.dart';

class MockWeatherService extends Mock implements WeatherService {}

void main() {
  late MockWeatherService mockWeatherService;

  final currentWeather = currentWeatherSample;
  final forecasts = forecastsSample;

  setUp(
    () {
      mockWeatherService = MockWeatherService();
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

  void arrangeWeatherServiceReturns5DaysForecastsAfter2SecondsWait() {
    when(
      () => mockWeatherService.getForecasts(any(), any()),
    ).thenAnswer(
      (_) async => forecasts,
    );
  }

  dynamic createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppProvider(
            weatherService: mockWeatherService,
            isTest: true,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Weather Forecasts',
        //? responsive framework to make the app responsive
        builder: (context, child) => ResponsiveWrapper.builder(
          child,
          minWidth: 480,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: '4K'),
          ],
        ),
        initialRoute: MainPage.route,
        routes: {
          "/": (context) => const MainPage(),
        },
      ),
    );
  }

  testWidgets(
    "title is displayed",
    (WidgetTester tester) async {
      arrangeWeatherServiceReturns1Weather();
      arrangeWeatherServiceReturns5DaysForecasts();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(seconds: 1));
      expect(find.text("Weather App"), findsOneWidget);
    },
  );
  testWidgets(
    "loading indicator is displayed while waiting for data",
    (WidgetTester tester) async {
      arrangeWeatherServiceReturns1Weather();
      arrangeWeatherServiceReturns5DaysForecastsAfter2SecondsWait();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );
  testWidgets(
    "current weather card is displayed",
    (WidgetTester tester) async {
      arrangeWeatherServiceReturns1Weather();
      arrangeWeatherServiceReturns5DaysForecasts();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      expect(find.byType(CurrentWeather), findsOneWidget);
    },
  );
  testWidgets(
    "external list view with listviews of forecasts is displayed",
    (WidgetTester tester) async {
      arrangeWeatherServiceReturns1Weather();
      arrangeWeatherServiceReturns5DaysForecasts();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      expect(find.byType(FiveDaysForecasts), findsOneWidget);
    },
  );
  testWidgets(
    "5 internal list views of forecasts are displayed",
    (WidgetTester tester) async {
      arrangeWeatherServiceReturns1Weather();
      arrangeWeatherServiceReturns5DaysForecasts();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      expect(
          find.byType(
            OneDayForecasts,
            skipOffstage: false,
          ),
          findsNWidgets(5));
    },
  );
}
