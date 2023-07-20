import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:cloudysky/domain/entities/weather.dart';
import 'package:cloudysky/presentation/bloc/weather_bloc.dart';
import 'package:cloudysky/presentation/bloc/weather_event.dart';
import 'package:cloudysky/presentation/bloc/weather_state.dart';
import 'package:cloudysky/presentation/pages/weather_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

class FakeWeatherState extends Fake implements WeatherState {}

class FakeWeatherEvent extends Fake implements WeatherEvent {}

void main() {
  late MockWeatherBloc mockWeatherBloc;

  setUpAll(() async {
    HttpOverrides.global = null;
    registerFallbackValue(FakeWeatherState());
    registerFallbackValue(FakeWeatherEvent());

    final di = GetIt.instance;
    di.registerFactory(() => mockWeatherBloc);
  });

  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
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

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WeatherBloc>.value(
      value: mockWeatherBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'text field should trigger state to change from empty to loading',
    (WidgetTester tester) async {
      // arrange
      when(() => mockWeatherBloc.state).thenReturn(WeatherEmpty());

      // act
      await tester.pumpWidget(_makeTestableWidget(WeatherPage()));
      await tester.enterText(find.byType(TextField), 'Visakhapatnam');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // assert
      verify(() => mockWeatherBloc.add(OnCityChanged('Visakhapatnam')));
      expect(find.byType(TextField), equals(findsOneWidget));
    },
  );

  testWidgets(
    'should show progress indicator when state is loading',
    (WidgetTester tester) async {
      // arrange
      when(() => mockWeatherBloc.state).thenReturn(WeatherLoading());

      // act
      await tester.pumpWidget(_makeTestableWidget(WeatherPage()));

      // assert
      expect(find.byType(CircularProgressIndicator), equals(findsOneWidget));
    },
  );

  testWidgets(
    'should show widget contain weather data when state is has data',
    (WidgetTester tester) async {
      // arrange
      when(() => mockWeatherBloc.state).thenReturn(WeatherHasData(tWeather));

      // act
      await tester.pumpWidget(_makeTestableWidget(WeatherPage()));
      // await tester.runAsync(() async {
      //   final HttpClient client = HttpClient();
      //   await client.getUrl(Uri.parse(Urls.weatherIcon('02d')));
      // });
      await tester.pumpAndSettle();

      // assert
      expect(find.byKey(Key('weather_data')), equals(findsOneWidget));
    },
  );
}
