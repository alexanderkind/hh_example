import 'package:hh_example/common/config/config_service.dart';
import 'package:hh_example/common/di/infra_module.dart';
import 'package:hh_example/common/logs/logs.dart';
import 'package:hh_example/common/models/helpers/config/config_state_model.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

/// Сервис по местоположению
@Riverpod(keepAlive: true)
class LocationService extends _$LocationService {
  Logs get _logs => ref.read(loggerProvider);

  ConfigStateModel get _config => ref.read(configServiceProvider);

  GoogleGeocodingApi get geocoder {
    try {
      _geocoderInstance ??= GoogleGeocodingApi(_config.mapKey, isLogged: kDebugMode);
    } catch (e, s) {
      _logs.e(e, e, s);
    }

    return _geocoderInstance!;
  }

  GoogleGeocodingApi? _geocoderInstance;

  @override
  LocationService build() {
    return this;
  }

  /// Получение мест из адреса
  Future<GoogleGeocodingResponse> geocoding(String address) async {
    return geocoder.search(address);
  }

  /// Получение первое место из адреса
  Future<GoogleGeocodingLocation?> geocodingFirstGeometry(String address) async {
    final result = await geocoding(address);
    return result.results.firstOrNull?.geometry?.location;
  }

  /// Текущее местоположение
  Future<Position> getCurrentPosition() => Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 30,
          timeLimit: Duration(seconds: 30),
        ),
      );

  /// Дистанция между точками
  double distanceBetween(double startLat, double startLng, double endLat, double endLng) =>
      Geolocator.distanceBetween(startLat, startLng, endLat, endLng);

  /// Дистанция до точки от текущего местоположения
  Future<double> distanceBetweenCurrentPosition(endLat, endLng) async {
    final current = await getCurrentPosition();
    return Geolocator.distanceBetween(current.latitude, current.longitude, endLat, endLng);
  }
}
