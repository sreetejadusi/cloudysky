import 'package:cloudysky/domain/entities/weather.dart';
import 'package:cloudysky/domain/usecases/get_weather.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helper.mocks.dart';

void main() {
  late MockWeatherRepository mockWeatherRepository;
  late GetCurrentWeather usecase;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetCurrentWeather(mockWeatherRepository);
  });
  const Weather testWeatherDetail = Weather(
    cityName: 'Kongens Lyngby [DK] (55.77, 12.5)',
    date: '2020-07-13 17:17:34.000',
    weather: 'Clouds, broken clouds',
    temp: '17.1 Celsius',
    tMin: '16.7 Celsius',
    tMax: '18.0 Celsius',
    tFeels: '13.4 Celsius',
    sunrise: '2020-07-13 04:43:53.000',
    sunset: '2020-07-13 21:47:15.000',
  );
  const String tCityName = 'Visakhapatnam';
  test('should get weather details from repository', () async {
    when(mockWeatherRepository.getCurrentWeather(tCityName))
        .thenAnswer((realInvocation) async => Right(testWeatherDetail));
    final result = await usecase.execute(tCityName);
    expect(result, equals(Right(testWeatherDetail)));
  });
}
