import 'package:cloudysky/data/failure.dart';
import 'package:cloudysky/domain/entities/weather.dart';
import 'package:cloudysky/domain/usecases/get_weather.dart';
import 'package:cloudysky/presentation/bloc/weather_bloc.dart';
import 'package:cloudysky/presentation/bloc/weather_event.dart';
import 'package:cloudysky/presentation/bloc/weather_state.dart';
import 'package:dartz/dartz.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'weather_bloc_test.mocks.dart';

@GenerateMocks([GetCurrentWeather])
void main() {
  late MockGetCurrentWeather mockGetCurrentWeather;
  late WeatherBloc weatherBloc;

  setUp(() {
    mockGetCurrentWeather = MockGetCurrentWeather();
    weatherBloc = WeatherBloc(mockGetCurrentWeather);
  });
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
  const String tCityName = 'Visakhapatnam';
  test('initial state should be empty', () {
    expect(weatherBloc.state, WeatherEmpty());
  });
  blocTest<WeatherBloc, WeatherState>(
    'should emit [loading, has data] when data is gotten successfully',
    build: () {
      when(mockGetCurrentWeather.execute(tCityName))
          .thenAnswer((realInvocation) async => Right(tWeather));
      return weatherBloc;
    },
    act: (bloc) => bloc.add(OnCityChanged(tCityName)),
    wait: const Duration(microseconds: 100),
    expect: () => [
      WeatherLoading(),
      WeatherHasData(tWeather),
    ],
    verify: (bloc) {
      verify(mockGetCurrentWeather.execute(tCityName));
    },
  );

  blocTest<WeatherBloc, WeatherState>(
    'should emit [loading, error] when get data is unsuccessful',
    build: () {
      when(mockGetCurrentWeather.execute(tCityName))
          .thenAnswer((realInvocation) async => const Left(ServerFailure('')));
      return weatherBloc;
    },
    act: (bloc) => bloc.add(OnCityChanged(tCityName)),
    expect: () => [
      WeatherLoading(),
      WeatherError(''),
    ],
    verify: (bloc) {
      verify(mockGetCurrentWeather.execute(tCityName));
    },
  );
}
