package com.example.sy_nav

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.net.wifi.WifiManager
import android.os.Build
import androidx.core.app.ActivityCompat
import android.Manifest
import android.content.pm.PackageManager

class MainActivity: FlutterActivity() {
    private val WIFI_CHANNEL = "com.example.sy_nav/wifi"
    private val BLUETOOTH_CHANNEL = "com.example.sy_nav/bluetooth"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        //setting up wifi channel 
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIFI_CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getWifiList") {
                if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                    ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), 0)
                    // Permission is not granted, return an error or empty list.
                    result.error("PERMISSION_DENIED", "Access to location denied", null)
                    return@setMethodCallHandler
                }
                val wifiList = getWifiList()
                result.success(wifiList)
            } else {
                result.notImplemented()
            }
        }

        // Setting up the Bluetooth channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BLUETOOTH_CHANNEL).setMethodCallHandler {
            call, result ->
            result.success("Unimplemented function to handle this bluetooth channel")
            // Handle Bluetooth related method calls
        }
    }

    /**
    * This function retrieves a list of nearby WiFi networks and returns their details as a dictionary.
    * 
    * It filters the results to only include networks with a signal strength (RSSI) greater than or equal to 
    * the specified threshold (-70dBm by default). You can adjust this threshold as needed.
    *
    * @return A map of key-value pairs for each WiFi network, containing:
    *   - "SSID": The network name
    *   - "BSSID": The network's MAC address
    *   - "RSSI": The signal strength in decibel-milliwatts (dBm)
    */
    private fun getWifiList(): List<String> {
        val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        val results = wifiManager.scanResults
        println("mumber of wifi: "+results.size);

        return results.filter { it.level >= -70 }.map { result ->
            mapOf(
              "SSID" to result.SSID,
              "BSSID" to result.BSSID,
              "RSSI" to "${result.level}dBm"
          )
        }.flatten() //Combine multiple maps into a single one
    }
}

