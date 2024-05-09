package com.example.sy_nav

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.net.wifi.WifiManager
import android.net.wifi.ScanResult
import android.content.BroadcastReceiver
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import androidx.core.app.ActivityCompat
import android.Manifest
import android.content.pm.PackageManager

class MainActivity: FlutterActivity() {
    private val WIFI_CHANNEL = "com.example.sy_nav/wifi"
    // private val BLUETOOTH_CHANNEL = "com.example.sy_nav/bluetooth"
    private lateinit var wifiScanReceiver: WifiScanReceiver


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


        // Register BroadcastReceiver for Wi-Fi scan results
        wifiScanReceiver = WifiScanReceiver()
        wifiScanReceiver.setWifiListUpdateListener { wifiList ->
            // Send updated Wi-Fi list to Flutter UI
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIFI_CHANNEL).invokeMethod("updateWifiList", wifiList)
        }
        registerReceiver(wifiScanReceiver, IntentFilter(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION))


        // // Setting up the Bluetooth channel
        // MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BLUETOOTH_CHANNEL).setMethodCallHandler {
        //     call, result ->
        //     result.success("Unimplemented function to handle this bluetooth channel")
        //     // Handle Bluetooth related method calls
        // }
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


        val wifiList=  results.filter { it.level >= -80 }.map { result ->
            "${result.BSSID}#" +
            "${result.level}#" +//RSSI
            "${result.SSID}" 
        }

        if(wifiList.size ==0){
            return listOf("Failed No wifi Available")
        }
        return wifiList;

    }
    inner class WifiScanReceiver : BroadcastReceiver() {
        private var wifiListUpdateListener: ((List<String>) -> Unit)? = null

        fun setWifiListUpdateListener(listener: (List<String>) -> Unit) {
            wifiListUpdateListener = listener
        }

        override fun onReceive(context: Context, intent: Intent) {
            val action = intent.action
            if (action == WifiManager.SCAN_RESULTS_AVAILABLE_ACTION) {
                val wifiManager = context.getSystemService(Context.WIFI_SERVICE) as WifiManager
                val results = wifiManager.scanResults
                val wifiList = results.filter { it.level >= -80 }.map { result ->
                        "${result.BSSID} " +
                        "${result.level}" //RSSI
                }
                if(wifiList.size ==0){
                    wifiListUpdateListener?.invoke(listOf("Failed No wifi Available"))
                        return
                }
                wifiListUpdateListener?.invoke(wifiList)
            }
        
        }
    }
}

