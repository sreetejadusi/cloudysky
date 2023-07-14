import 'dart:convert';

import 'package:cloudysky/data/datasources/remote_data_source.dart';
import 'package:cloudysky/data/models/weather_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TestRemoteDataSource dataSource;
  const tCityName = 'Visakhapatnam';
  WeatherModel wModel = const WeatherModel(
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
  setUp(() {
    dataSource = TestRemoteDataSource();
  });
  test('should return weather model when response code is 200', () async {
    when(dataSource.getWeather(tCityName)).thenAnswer((realInvocation) async =>
        WeatherModel.fromJson(json.decode(
            readJson('helpers/dummy_data/dummy_weather_response.json'))));
    final result = await dataSource.getWeather(tCityName);
    expect(result, equals(wModel));
  });
}
