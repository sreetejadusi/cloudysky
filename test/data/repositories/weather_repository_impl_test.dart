import 'package:cloudysky/data/failure.dart';
import 'package:cloudysky/data/models/weather_model.dart';
import 'package:cloudysky/data/repositories/weather_respository.dart';
import 'package:cloudysky/domain/entities/weather.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather/weather.dart' hide Weather;
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TestRemoteDataSource testRemoteDataSource;
  late WeatherRepositoryImpl weatherRepositoryImpl;

  setUp(() {
    testRemoteDataSource = TestRemoteDataSource();
    weatherRepositoryImpl =
        WeatherRepositoryImpl(remoteDataSource: testRemoteDataSource);
  });
  const tWeatherModel = WeatherModel(
    cityName: 'Kongens Lyngby [DK] (55.77, 12.5)',
    date: '2020-07-13 17:17:34.000',
    weather: 'Clouds, broken clouds',
    temp: '17.1 Celsius',
    tMin: '16.7 Celsius',
    tMax: '18.0 Celsius',
    tFeels: '13.4 Celsius',
    sunrise: '2020-07-13 04:43:53.000',
    sunset: '2020-07-13 21:47:15.000',
    weatherDesc: 'Clouds',
    icon: 'icon',
    cond: 0,
  );

  const tWeather = Weather(
    cityName: 'Kongens Lyngby [DK] (55.77, 12.5)',
    date: '2020-07-13 17:17:34.000',
    weather: 'Clouds, broken clouds',
    temp: '17.1 Celsius',
    tMin: '16.7 Celsius',
    tMax: '18.0 Celsius',
    tFeels: '13.4 Celsius',
    sunrise: '2020-07-13 04:43:53.000',
    sunset: '2020-07-13 21:47:15.000',
    weatherDesc: 'Clouds',
    icon: 'icon',
    cond: 0,
  );
  String tCityName = 'Visakhapatnam';

  group('get current weather', () {
    test(
      'should return current weather when a call to data source is successful',
      () async {
        // arrange
        when(testRemoteDataSource.getWeather(tCityName))
            .thenAnswer((_) async => tWeatherModel);

        // act
        final result = await weatherRepositoryImpl.getCurrentWeather(tCityName);

        // assert
        verify(testRemoteDataSource.getWeather(tCityName));
        expect(result, equals(Right(tWeather)));
      },
    );

    test(
      'should return server failure when a call to data source is unsuccessful',
      () async {
        // arrange
        when(testRemoteDataSource.getWeather(tCityName))
            .thenThrow(OpenWeatherAPIException(''));

        // act
        final result = await weatherRepositoryImpl.getCurrentWeather(tCityName);

        // assert
        verify(testRemoteDataSource.getWeather(tCityName));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );
  });
}
