import 'package:cloudysky/data/failure.dart';
import 'package:cloudysky/domain/entities/weather.dart';
import 'package:cloudysky/domain/repositories/weather_repository.dart';
import 'package:dartz/dartz.dart';

class GetCurrentWeather {
  final WeatherRepository repository;
  GetCurrentWeather(this.repository);
  Future<Either<Failure, Weather>> execute(String cityName) {
    return repository.getCurrentWeather(cityName);
  }
}
