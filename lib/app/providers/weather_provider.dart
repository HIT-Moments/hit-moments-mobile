import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/datasource/network_services/weather_service.dart';
import 'package:hit_moments/app/models/weather_model.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherModel? weather;
  String? errorMessage;
  ModuleStatus weatherStatus = ModuleStatus.initial;

  Future<void> getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      dynamic response = await WeatherService().getCurrentWeather(
          position.latitude.toString(), position.longitude.toString());
      weather = WeatherModel.fromJson(response);
      weatherStatus = ModuleStatus.success;
      notifyListeners();
      errorMessage = null;
    } catch (e) {
      weatherStatus = ModuleStatus.fail;
      notifyListeners();
    }
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }
}
