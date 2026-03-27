class ForecastModel {
  final DateTime date;
  final double temp;
  final double feelsLike;
  final String mainCondition;
  final String description;
  final String icon;

  ForecastModel({
    required this.date,
    required this.temp,
    required this.feelsLike,
    required this.mainCondition,
    required this.description,
    required this.icon,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temp: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}