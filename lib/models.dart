class WeatherModel {
  final String cityName;
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final String description;
  final String icon;
  final String main;        
  final bool isDay;         

  WeatherModel({
    required this.cityName,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.icon,
    required this.main,
    required this.isDay,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final iconCode = json['weather'][0]['icon'] as String;
    final weatherMain = json['weather'][0]['main'] as String;

    
    final isDayTime = iconCode.endsWith('d');

    return WeatherModel(
      cityName: json['name'],
      temp: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      description: json['weather'][0]['description'],
      icon: iconCode,
      main: weatherMain,
      isDay: isDayTime,
    );
  }

  String? get mainCondition => null;

  get humidity => null;
}
