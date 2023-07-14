import 'dart:io';

import 'package:cloudysky/data/datasources/remote_data_source.dart';
import 'package:cloudysky/data/failure.dart';
import 'package:cloudysky/domain/entities/weather.dart';
import 'package:cloudysky/domain/repositories/weather_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:weather/weather.dart' hide Weather;

class WeatherRepositoryImpl implements WeatherRepository {
  final RemoteDataSource remoteDataSource;
  const WeatherRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, Weather>> getCurrentWeather(String cityName) async {
    // TODO: implement getCurrentWeather
    try {
      final result = await remoteDataSource.getWeather(cityName);
      return Right(result.toEntity());
    } on OpenWeatherAPIException {
      return Left(ServerFailure(''));
    } on ServerFailure {
      return Left(ServerFailure('Goddamn Server'));
    }
  }
}
