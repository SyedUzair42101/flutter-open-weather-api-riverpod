import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

import '../model/weather_model.dart';
import '../repository/location_repository.dart';
import '../repository/weather_repository.dart';

class CurrentWeatherController extends StateNotifier<AsyncValue<WeatherModel>> {
  CurrentWeatherController(this._weatherRepository,
      {required this.lat, required this.lon})
      : super(const AsyncValue.loading()) {
    getWeather(
      lat: lat,
      lon: lon,
    );
  }
  final WeatherRepository _weatherRepository;
  final double lat;
  final double lon;

  Future<void> getWeather({required double lat, required double lon}) async {
    try {
      state = const AsyncValue.loading();

      final weather = await _weatherRepository.getWeather(lat, lon);
      state = AsyncValue.data(weather);
    } on Exception catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final currentWeatherControllerProvider = StateNotifierProvider.autoDispose<
    CurrentWeatherController, AsyncValue<WeatherModel>>((ref) {
  final weatherRepository = ref.watch(weatherRepositoryProvider);
  final lat = ref.watch(latProvider);
  final long = ref.watch(lonProvider);
  return CurrentWeatherController(weatherRepository, lat: lat, lon: long);
});
