import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/weather.dart';
import '../providers/app_provider.dart';

class OneDayForecasts extends StatefulWidget {
  final ScrollController scrollController;
  final List<Weather> weathers;

  const OneDayForecasts({
    Key? key,
    required this.scrollController,
    required this.weathers,
  }) : super(key: key);

  @override
  State<OneDayForecasts> createState() => _OneDayForecastsState();
}

class _OneDayForecastsState extends State<OneDayForecasts> {
  _scrollListener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Timer(
      Duration.zero,
      () => setState(() {}),
    );
    //? listener to respond to scrolls and show/unshow arrows
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forecastsWeathersDateFormat = DateFormat('EEE dd - HH');

    return SizedBox(
      height: 130,
      child: Stack(
        children: <Widget>[
          ListView.separated(
            controller: widget.scrollController,
            itemCount: widget.weathers.length,
            separatorBuilder: (context, index) => const Divider(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, internalIndex) => Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: SizedBox(
                width: 250,
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
                              widget.weathers[internalIndex].weatherDescription,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                            ),
                            if (!context.read<AppProvider>().isTest)
                              Image.network(
                                "https://openweathermap.org/img/wn/${widget.weathers[internalIndex].iconCode}.png",
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Temp: ${widget.weathers[internalIndex].currentTemperature.toInt()} °C",
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Min: ${widget.weathers[internalIndex].minTemperature.toInt()} °C",
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Max: ${widget.weathers[internalIndex].maxTemperature.toInt()} °C",
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Humidity: ${widget.weathers[internalIndex].humidityPercentage.toString()}%",
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Last update: ${forecastsWeathersDateFormat.format(widget.weathers[internalIndex].lastUpdate.toLocal())}",
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (widget.scrollController.hasClients &&
              widget.scrollController.offset > 0)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => widget.scrollController.animateTo(
                  0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.decelerate,
                ),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
          if (widget.scrollController.hasClients &&
              widget.scrollController.offset <
                  widget.scrollController.position.maxScrollExtent)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => widget.scrollController.animateTo(
                  widget.scrollController.position.maxScrollExtent,
                  duration: const Duration(seconds: 1),
                  curve: Curves.decelerate,
                ),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
