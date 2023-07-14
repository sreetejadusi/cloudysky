import 'package:bloc/bloc.dart';
import 'package:cloudysky/domain/usecases/get_weather.dart';
import 'package:cloudysky/presentation/bloc/weather_event.dart';
import 'package:cloudysky/presentation/bloc/weather_state.dart';
import 'package:equatable/equatable.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeather _getCurrentWeather;
  WeatherBloc(this._getCurrentWeather) : super(WeatherEmpty()) {
    on<OnCityChanged>(
      (event, emit) async {
        print('object');
        final cityName = event.cityName;
        emit(WeatherLoading());
        final result = await _getCurrentWeather.execute(cityName);
        result.fold((failure) {
          emit(WeatherError(failure.message));
        }, (data) {
          emit(WeatherHasData(data));
        });
      },
    );
  }
}
