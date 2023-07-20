import 'dart:convert';

import 'package:cloudysky/data/models/weather_model.dart';
import 'package:cloudysky/domain/entities/weather.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/json_reader.dart';

void main() {
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

  group('to entity', () {
    test('should be a subclass of weather entity', () async {
      final result = tWeatherModel.toEntity();
      expect(result, equals(tWeather));
    });
  });

  group('from json', () {
    test('should return a valid model from json', () {
      final Map<String, dynamic> jsonMap = json
          .decode(readJson('/helpers/dummy_data/dummy_weather_response.json'));
      final result = WeatherModel.fromJson(jsonMap);

      expect(result, equals(tWeatherModel));
    });
  });
  group('to json', () {
    test(
      'should return a json map containing proper data',
      () async {
        final result = tWeatherModel.toJson();
        final expectedJsonMap = {
          "cityName": "Kongens Lyngby [DK] (55.77, 12.5)",
          "date": "2020-07-13 17:17:34.000",
          "weather": "Clouds, broken clouds",
          "temp": "17.1 Celsius",
          "tMin": "16.7 Celsius",
          "tMax": "18.0 Celsius",
          "tFeels": "13.4 Celsius",
          "sunrise": "2020-07-13 04:43:53.000",
          "sunset": "2020-07-13 21:47:15.000"
        };
        expect(result, equals(expectedJsonMap));
      },
    );
  });
}
