package com.example.weather_app

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private val channel = "com.example.weather_app/channels"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(FlutterEngine(this@MainActivity))
        MethodChannel(flutterEngine!!.dartExecutor, channel).setMethodCallHandler { call, _ ->
            if (call.method.equals("goToSecondActivity")) {
                goToSecondActivity()
            }
        }
    }

    private fun goToSecondActivity(){
        startActivity(Intent(this@MainActivity, SecondActivity::class.java))
    }
}
