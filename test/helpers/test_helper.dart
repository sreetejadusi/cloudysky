import 'package:cloudysky/data/datasources/remote_data_source.dart';
import 'package:cloudysky/domain/repositories/weather_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [
    WeatherRepository,
    RemoteDataSource,
  ],
  customMocks: [
    MockSpec<http.Client>(as: #MockHttpClient),
    MockSpec<RemoteDataSource>(as: #TestRemoteDataSource)
  ],
)
void main() {}
