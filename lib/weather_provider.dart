import 'package:flutter/material.dart';
import 'package:flutter_application_6/forecast_model.dart';
import 'package:flutter_application_6/models.dart';
import 'package:flutter_application_6/weather_service.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherModel? _weather;
  List<ForecastModel> _forecast = [];
  String _backgroundImage = 'assets/normal.day.avif';
  bool isLoading = false;
  String error = '';

  WeatherModel? get weather => _weather;
  List<ForecastModel> get forecast => _forecast;
  String get backgroundImage => _backgroundImage;

  final WeatherService _service = WeatherService();

  // دالة اختيار الخلفية (نفس الطريقة القديمة)
  String _getBackgroundImage(String condition) {
    final hour = DateTime.now().hour;
    final isDay = hour >= 6 && hour < 18;

    if (!isDay) {
      return 'assets/normal.day.avif'; // صورة الليل - غيريها لاحقاً لو عندك
    }

    final lower = condition.toLowerCase();

    if (lower.contains('rain') || lower.contains('drizzle') || lower.contains('shower')) {
      return 'assets/day.rain.avif';
    } else if (lower.contains('cloud') || lower.contains('overcast')) {
      return 'assets/day.cloudy.jpg';
    } else {
      return 'assets/normal.day.avif';
    }
  }

  Future<void> fetchWeather(String city) async {
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      _weather = await _service.getCurrentWeather(city);

      // الطريقة اللي كانت شغالة معاكِ قبل كده (مع fallback)
      _backgroundImage = _getBackgroundImage(
        _weather?.mainCondition ?? 'Clear'   // ← هنا الحل
      );

      // جلب الـ 5 أيام Forecast
      _forecast = await _service.getFiveDayForecast(city);

    } catch (e) {
      error = 'Failed to load data: $e';
      _backgroundImage = 'assets/normal.day.avif';
      _weather = null;
      _forecast = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void init() {
    fetchWeather('Cairo');
  }
}