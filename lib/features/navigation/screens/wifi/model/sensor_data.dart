// // sensor_data.dart
// import 'package:sensors_plus/sensors_plus.dart';

// class SensorData {
//   double _accelerationX = 0.0;
//   double _accelerationY = 0.0;
//   double _accelerationZ = 0.0;

//   double _gyroscopeX = 0.0;
//   double _gyroscopeY = 0.0;
//   double _gyroscopeZ = 0.0;

//   double _magnetometerX = 0.0;
//   double _magnetometerY = 0.0;
//   double _magnetometerZ = 0.0;

//   SensorData() {
//     accelerometerEventStream().listen((AccelerometerEvent event) {
//       _accelerationX = event.x;
//       _accelerationY = event.y;
//       _accelerationZ = event.z;
//     });

//     gyroscopeEventStream().listen((GyroscopeEvent event) {
//       _gyroscopeX = event.x;
//       _gyroscopeY = event.y;
//       _gyroscopeZ = event.z;
//     });

//     magnetometerEventStream().listen((MagnetometerEvent event) {
//       _magnetometerX = event.x;
//       _magnetometerY = event.y;
//       _magnetometerZ = event.z;
//     });
//   }

//   List<double> getAcceleration() {
//     return [_accelerationX, _accelerationY, _accelerationZ];
//   }

//   List<double> getGyroscope() {
//     return [_gyroscopeX, _gyroscopeY, _gyroscopeZ];
//   }

//   List<double> getMagnetometer() {
//     return [_magnetometerX, _magnetometerY, _magnetometerZ];
//   }
// }
