import "package:equatable/equatable.dart";

class Weather extends Equatable {
  final String cityName;
  final String date;
  final String weather;
  final String weatherDesc;
  final String tempC;
  final String tempF;
  final String tMin;
  final String tMax;
  final String tFeels;
  final String sunrise;
  final String sunset;
  const Weather(
      {required this.cityName,
      required this.date,
      required this.weather,
      required this.weatherDesc,
      required this.tempC,
      required this.tempF,
      required this.tMin,
      required this.tMax,
      required this.tFeels,
      required this.sunrise,
      required this.sunset});
  @override
  // TODO: implement props
  List<Object?> get props =>
      [cityName, date, weather,weatherDesc, tempC,tempF, tMin, tMax, tFeels, sunrise, sunset];
}