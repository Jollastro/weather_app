import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentWeather = context.read<AppProvider>().currentWeather;
    final currentWeatherDateFormat = DateFormat('EEE dd - HH:mm');

    return Expanded(
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        currentWeather!.weatherDescription,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                      ),
                      if (!context.read<AppProvider>().isTest)
                        Image.network(
                          "https://openweathermap.org/img/wn/${currentWeather.iconCode}.png",
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    "Temp: ${currentWeather.currentTemperature.toInt()} °C",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Min: ${currentWeather.minTemperature.toInt()} °C",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Max: ${currentWeather.maxTemperature.toInt()} °C",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Humidity: ${currentWeather.humidityPercentage.toString()}%",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Last update: ${currentWeatherDateFormat.format(currentWeather.lastUpdate.toLocal())}",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
