import 'dart:math';

/// PositionKalmanFilter is a Kalman filter implementation for estimating the position.
class PositionKalmanFilter {
  double processNoiseCovariance; // Process noise covariance
  double measurementNoiseCovariance; // Measurement noise covariance
  late double stateEstimate; // State estimate (position)
  late double estimationErrorCovariance; // Estimation error covariance
  late double kalmanGain; // Kalman gain

  PositionKalmanFilter(
      this.processNoiseCovariance, this.measurementNoiseCovariance) {
    stateEstimate = 0;
    estimationErrorCovariance = 1;
    kalmanGain = 0;
  }

  /// Filters the given measurement to update the state estimate.
  double filter(double measurement) {
    // Prediction update
    estimationErrorCovariance += processNoiseCovariance;

    // Measurement update
    kalmanGain = estimationErrorCovariance /
        (estimationErrorCovariance + measurementNoiseCovariance);
    stateEstimate += kalmanGain * (measurement - stateEstimate);
    estimationErrorCovariance *= (1 - kalmanGain);

    return stateEstimate;
  }

  double get state => stateEstimate;

  set state(double value) {
    stateEstimate = value;
  }
}

// kalman_filter.dart
class KalmanFilter {
  final double _processNoiseCovariance = 0.00001; // Process noise covariance
  final double _measurementNoiseCovariance =
      0.1; // Measurement noise covariance
  double _stateEstimate = 0.0; //  State estimate (position)
  double _estimationErrorCovariance = 1.0; // Estimation error covariance
  double _kalmanGain = 0.0; // Kalman gain

  KalmanFilter();

  double filter(double measurement) {
    _estimationErrorCovariance =
        _estimationErrorCovariance + _processNoiseCovariance;
    _kalmanGain = _estimationErrorCovariance /
        (_estimationErrorCovariance + _measurementNoiseCovariance);
    _stateEstimate =
        _stateEstimate + _kalmanGain * (measurement - _stateEstimate);
    _estimationErrorCovariance = (1 - _kalmanGain) * _estimationErrorCovariance;
    return _stateEstimate;
  }

  void setState(double state, double covariance) {
    _stateEstimate = state;
    _estimationErrorCovariance = covariance;
  }

  void updateWithSensorData(
      List<double> accelerometerValues, List<double> gyroscopeValues) {
    // Update the state and covariance based on the sensor data
    // This is a simplified sensor funsion logic
    final accelMagnitude = sqrt(accelerometerValues.fold<double>(
        0, (sum, value) => sum + value * value));
    _stateEstimate +=
        accelMagnitude; // modify state based on accelerometer magnitude

    //gyroscope will be applied here
  }
}
