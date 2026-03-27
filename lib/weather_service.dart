import 'package:dio/dio.dart';
import 'package:flutter_application_6/forecast_model.dart';
import 'package:flutter_application_6/models.dart';
import 'package:flutter_application_6/weather_provider.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  final Dio _dio = Dio();
  final String apiKey = '530096eeab50229b5bdb637d337d5723';   
  Future<WeatherModel> getCurrentWeather(String city) async {
    final response = await _dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'q': city,
        'appid': apiKey,
        'units': 'metric',
        'lang': 'en',        
      },
    );
    return WeatherModel.fromJson(response.data);
  }

  Future<List<ForecastModel>> getFiveDayForecast(String city) async {
    final response = await _dio.get(
      'https://api.openweathermap.org/data/2.5/forecast',
      queryParameters: {
        'q': city,
        'appid': apiKey,
        'units': 'metric',
        'lang': 'en',
      },
    );

    final List<dynamic> list = response.data['list'];
    List<ForecastModel> forecasts = [];

    
    for (int i = 0; i < list.length && forecasts.length < 5; i += 8) {
      forecasts.add(ForecastModel.fromJson(list[i]));
    }

    return forecasts;
  }
}
