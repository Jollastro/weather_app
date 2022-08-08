import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool _isMainPage;
  static const channel = "com.example.weather_app/channels";
  static const platform = MethodChannel(channel);

  const MyAppBar({Key? key, required isMainPage})
      : _isMainPage = isMainPage,
        super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(64);

  //? method to spawn a native android activity
  _openNativeActivity() async {
    try {
      await platform.invokeMethod("goToSecondActivity");
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Weather App"),
      actions: _isMainPage
          ? <Widget>[
              IconButton(
                onPressed: _openNativeActivity,
                tooltip: "click for native web view",
                icon: const Icon(
                  Icons.web,
                  semanticLabel: "Native web view",
                ),
              )
            ]
          : null,
    );
  }
}
