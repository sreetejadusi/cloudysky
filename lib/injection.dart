import 'package:cloudysky/data/constants.dart';
import 'package:cloudysky/data/datasources/remote_data_source.dart';
import 'package:cloudysky/data/repositories/weather_respository.dart';
import 'package:cloudysky/domain/repositories/weather_repository.dart';
import 'package:cloudysky/domain/usecases/get_weather.dart';
import 'package:cloudysky/presentation/bloc/weather_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(() => WeatherBloc(locator()));

  // usecase
  locator.registerLazySingleton(() => GetCurrentWeather(locator()));

  // repository
  locator.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );

  // data source
  locator.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(),
  );
}
