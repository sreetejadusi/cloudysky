import 'dart:ui';

import 'package:cloudysky/data/constants.dart';
import 'package:cloudysky/data/failure.dart';
import 'package:cloudysky/presentation/bloc/weather_bloc.dart';
import 'package:cloudysky/presentation/bloc/weather_event.dart';
import 'package:cloudysky/presentation/bloc/weather_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:quotes_widget/quotes_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  Future<void> getPrefs(BuildContext context) async {
    try {
      SharedPreferences.getInstance().then((value) {
        context
            .read<WeatherBloc>()
            .add(OnCityChanged(value.getString('place') ?? ''));
      });
    } catch (e) {
      throw ServerFailure('No Internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    getPrefs(context);
    ThemeBuilder themeData = ColorTheme.cloudyOne;
    return Scaffold(
      body: BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
        if (state is WeatherHasData) {
          switch (state.result.cond.toString()[0]) {
            case '2':
              themeData = ColorTheme.rainyTwo;
              break;
            case '3':
              themeData = ColorTheme.rainyThree;
              break;
            case '5':
              themeData = ColorTheme.rainyOne;
              break;
            case '6':
              themeData = ColorTheme.snowyTwo;
              break;
            case '7':
              themeData = ColorTheme.cloudyOne;
              break;
            case '8':
              if (state.result.cond.toString() == '800') {
                themeData = ColorTheme.sunnyOne;
              } else {
                themeData = ColorTheme.cloudyTwo;
              }
              break;
            default:
              themeData = ColorTheme.cloudyOne;
          }
        }

        return state is WeatherLoading
            ? const Center(child: CircularProgressIndicator())
            : state is WeatherHasData
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: themeData.blackShade,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/${themeData.bg}.png'),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Container(
                            margin: EdgeInsets.all(48),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(24)),
                            child: Image.asset('assets/logo.png')),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.4,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: themeData.primary,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // SvgPicture.asset(
                                  //   'assets/$icon.svg',
                                  //   height: Theme.of(context)
                                  //       .textTheme
                                  //       .displayMedium!
                                  //       .fontSize,
                                  //   // colorFilter: ColorFilter.mode(
                                  //   //     Colors.white, BlendMode.clear),
                                  //   color: themeData.secondary,
                                  // ),
                                  Image.network(
                                    'https://openweathermap.org/img/wn/${state.result.icon}@2x.png',
                                    color: themeData.secondary,
                                  ),

                                  Text(
                                    '${state.result.tempC}°C',
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .fontSize,
                                        color: themeData.secondary),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.008,
                              ),
                              Text(
                                state.result.weather,
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .fontSize,
                                    fontWeight: FontWeight.w700,
                                    color: themeData.secondary),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.004,
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: themeData.secondary,
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Change city'),
                                      content: Container(
                                        padding: EdgeInsets.only(left: 12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: themeData.secondary,
                                          ),
                                        ),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Look at the city of...',
                                            border: InputBorder.none,
                                          ),
                                          controller: textEditingController,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel')),
                                        TextButton(
                                            onPressed: () {
                                              if (textEditingController
                                                  .text.isNotEmpty) {
                                                context.read<WeatherBloc>().add(
                                                    OnCityChanged(
                                                        textEditingController
                                                            .text
                                                            .trim()));
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Submit')),
                                      ],
                                    ),
                                  );
                                },
                                child: Text(
                                  state.result.cityName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .fontSize,
                                    color: themeData.secondary,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.004,
                              ),
                              Text(
                                state.result.date,
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .fontSize,
                                    color: themeData.secondary),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Min ${state.result.tMin}°',
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .fontSize,
                                          color: themeData.secondary),
                                    ),
                                    Container(
                                      width: 2,
                                      height: 20,
                                      color: themeData.secondary,
                                    ),
                                    Text(
                                      'Max ${state.result.tMax}°',
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .fontSize,
                                          color: themeData.secondary),
                                    ),
                                    Container(
                                      width: 2,
                                      height: 20,
                                      color: themeData.secondary,
                                    ),
                                    Text(
                                      'Feels like ${state.result.tFeels}°',
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .fontSize,
                                          color: themeData.secondary),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.004,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Sunrise ${state.result.sunrise}',
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .fontSize,
                                          color: themeData.secondary),
                                    ),
                                    Container(
                                      width: 2,
                                      height: 20,
                                      color: themeData.secondary,
                                    ),
                                    Text(
                                      'Sunset ${state.result.sunset}',
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .fontSize,
                                          color: themeData.secondary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 64,
                        ),
                        QuotesWidget(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.9,
                            quoteFontSize: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .fontSize!,
                            authorFontSize: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .fontSize!),
                        Spacer()
                      ],
                    ),
                  )
                : state is WeatherError
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/logo.png'),
                          Center(
                              child: Text('Enter city name to fetch weather')),
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 12),
                            margin: EdgeInsets.symmetric(horizontal: 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: themeData.secondary,
                              ),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Look at the city of...',
                                border: InputBorder.none,
                              ),
                              controller: textEditingController,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 24),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                      Color(0xFF009AFF),
                                    ),
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)))),
                                onPressed: () {
                                  context.read<WeatherBloc>().add(OnCityChanged(
                                      textEditingController.text.trim()));
                                },
                                child: Text('Tell me the Weather')),
                          )
                        ],
                      )
                    : SizedBox();
      }),
    );
  }
}
