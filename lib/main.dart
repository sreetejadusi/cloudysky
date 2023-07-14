import 'package:cloudysky/presentation/bloc/weather_bloc.dart';
import 'package:cloudysky/presentation/pages/weather_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'injection.dart' as di;

Future<void> main() async {
  di.init();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) async {
    if (prefs.getString('place') != null) {
      prefs.setString('place', '');
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<WeatherBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'CloudySky',
        theme: ThemeData(fontFamily: 'Poppins'),
        home: WeatherPage(),
      ),
    );
  }
}
