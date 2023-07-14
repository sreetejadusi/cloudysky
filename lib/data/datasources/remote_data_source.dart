import 'dart:io';

import 'package:cloudysky/data/constants.dart';
import 'package:cloudysky/data/failure.dart';
import 'package:cloudysky/data/models/weather_model.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';

abstract class RemoteDataSource {
  Future<WeatherModel> getWeather(String cityName);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final String _api = Constants().api;
  String get api => _api;
  late final WeatherFactory factory = WeatherFactory(api);
  @override
  Future<WeatherModel> getWeather(String cityName) async {
    try {
      final weather = await factory.currentWeatherByCityName(cityName);
      return WeatherModel(
        cityName: cityName,
        date: DateFormat('dd MMMM yyyy').format(
          weather.date!,
        ),
        weather: weather.weatherMain.toString(),
        weatherDesc: weather.weatherDescription.toString(),
        tempC: weather.temperature!.celsius!.floor().toString(),
        tempF: weather.temperature!.fahrenheit!.floor().toString(),
        tMin: weather.tempMin!.celsius!.floor().toString(),
        tMax: weather.tempMax!.celsius!.floor().toString(),
        tFeels: weather.tempFeelsLike!.celsius!.floor().toString(),
        sunrise: DateFormat('hh:mm').format(weather.sunrise!),
        sunset: DateFormat('hh:mm').format(weather.sunset!),
        icon: weather.weatherIcon!,
        cond: weather.weatherConditionCode!,
      );
    } on SocketException {
      throw ServerFailure('');
    }
  }
}
