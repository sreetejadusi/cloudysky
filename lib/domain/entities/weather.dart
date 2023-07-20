import "package:equatable/equatable.dart";

class Weather extends Equatable {
  final String cityName;
  final String date;
  final String weather;
  final String weatherDesc;
  final String temp;

  final String tMin;
  final String tMax;
  final String tFeels;
  final String sunrise;
  final String sunset;
  final String icon;
  final int cond;
  const Weather({
    required this.cityName,
    required this.date,
    required this.weather,
    required this.weatherDesc,
    required this.temp,
    required this.tMin,
    required this.tMax,
    required this.tFeels,
    required this.sunrise,
    required this.sunset,
    required this.icon,
    required this.cond,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [
        cityName,
        date,
        weather,
        weatherDesc,
        temp,
        tMin,
        tMax,
        tFeels,
        sunrise,
        sunset,
        icon,
        cond,
      ];
}
