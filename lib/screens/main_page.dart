import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/app_provider.dart';
import 'package:weather_app/widgets/my_app_bar.dart';

import '../widgets/current_weather.dart';
import '../widgets/five_days_forecasts.dart';

class MainPage extends StatefulWidget {
  static const route = "/";

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<AppProvider>().initializeApp(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(isMainPage: true),
      //? FutureBuilder to fetch the data and then show the page
      body: Consumer<AppProvider>(
        builder: (_, appProvider, __) {
          if (!appProvider.dataFetched.isCompleted) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  const CurrentWeather(),
                  const SizedBox(height: 16),
                  FiveDaysForecasts(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
