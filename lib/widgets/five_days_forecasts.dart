import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import './one_day_forecasts.dart';

class FiveDaysForecasts extends StatefulWidget {
  final externalScrollController = ScrollController();
  final internalScrollControllers = List.generate(
    5,
    (_) => ScrollController(),
  );

  FiveDaysForecasts({Key? key}) : super(key: key);

  @override
  State<FiveDaysForecasts> createState() => _FiveDaysForecastsState();
}

class _FiveDaysForecastsState extends State<FiveDaysForecasts> {
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
    widget.externalScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.externalScrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forecasts = context.read<AppProvider>().forecasts;

    return Expanded(
      flex: 3,
      child: Stack(
        children: <Widget>[
          ListView.separated(
            controller: widget.externalScrollController,
            itemCount: forecasts!.weathers.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, externalIndex) => OneDayForecasts(
              scrollController: widget.internalScrollControllers[externalIndex],
              weathers: forecasts.weathers[externalIndex],
            ),
          ),
          if (widget.externalScrollController.hasClients &&
              widget.externalScrollController.offset > 0)
            Align(
              alignment: Alignment.topCenter,
              child: IconButton(
                onPressed: () => widget.externalScrollController.animateTo(
                  0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.decelerate,
                ),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: const Icon(
                  Icons.keyboard_double_arrow_up,
                  color: Colors.white,
                ),
              ),
            ),
          if (widget.externalScrollController.hasClients &&
              widget.externalScrollController.offset <
                  widget.externalScrollController.position.maxScrollExtent)
            Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                onPressed: () => widget.externalScrollController.animateTo(
                  widget.externalScrollController.position.maxScrollExtent,
                  duration: const Duration(seconds: 1),
                  curve: Curves.decelerate,
                ),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: const Icon(
                  Icons.keyboard_double_arrow_down,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
