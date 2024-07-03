import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/secrat.dart';
import 'package:weather_app/weather_forecast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl_browser.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Rajahmundry';
      final result = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&units=metric&APPID=$openWeatherAPIKey'),
      );

      // print(result.body);
      final data = jsonDecode(result.body);
      if (data["cod"] != "200") {
        throw 'An unexpected error occurred, as status cod is not 200';
      }

      return data;
    } catch (e) {
      throw 'An unexpected error occurred - ${e.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
          future: getCurrentWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final data = snapshot.data!;

            final currentWeatherData = data['list'][0];
            final currentWeatherList = data['list'];

            final currentTemp = currentWeatherData['main']['temp'];

            final currentSky = currentWeatherData['weather'][0]['main'];
            final currentPressure = currentWeatherData['main']['pressure'];
            final currentHumidity = currentWeatherData['main']['humidity'];
            final currentWindSpeed = currentWeatherData['wind']['speed'];

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // main card
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: EdgeInsets.all(28.0),
                              child: Column(
                                children: [
                                  Text(
                                    '$currentTemp°C',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    currentSky == 'Clouds' ?
                                        Icons.cloud: currentSky == 'Rain' ?
                                    Icons.water_outlined: Icons.sunny,
                                    size: 64,
                                  ),
                                  Text(
                                    currentSky,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Weather forecast cards --------------
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Weather Forecast',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: [
                    //
                    //       for(int i=0; i<=7;  i++)
                    //         WeatherForecast(
                    //           time:
                    //           DateTime.parse(currentWeatherList[i + 2]['dt_txt']).toLocal().toString(),
                    //           iconData: currentWeatherList[i + 2]['weather'][0]['main'] == 'Clouds' ||
                    //               currentWeatherList[i + 2]['weather'][0]['main'] == 'Rain' ?
                    //           Icons.cloud: Icons.sunny,
                    //           temperature: currentWeatherList[i + 2]['main']['temp'].toString(),
                    //         )
                    //
                    //     ],
                    //   ),
                    // ),

                    SizedBox(
                      height: 120,
                      child:ListView.builder(
                        scrollDirection: Axis.horizontal,
                      itemCount: 5,
                        itemBuilder: (context, i){
                        final hourly = currentWeatherList[i + 1];
                        final time = DateTime.parse(hourly['dt_txt']);
                        final weatherSymbol = hourly['weather'][0]['main'];
                        return WeatherForecast(time: DateFormat.j().format(time),
                            iconData: weatherSymbol == 'Clouds'
                                 ?
                                          Icons.cloud: weatherSymbol == 'Rain' ?
                            Icons.water_outlined:
                            Icons.sunny,
                            temperature: "${hourly['main']['temp']}°");
                        }

                    ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // Additional information
                    const Text(
                      'Additional Information',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalInfo(
                          icon: Icons.water_drop,
                          textVal: 'Humidity',
                          textNum: '$currentHumidity',
                        ),
                        AdditionalInfo(
                          icon: Icons.air,
                          textVal: 'Wind Speed',
                          textNum: '$currentWindSpeed',
                        ),
                        AdditionalInfo(
                          icon: Icons.beach_access,
                          textVal: 'Pressure',
                          textNum: '$currentPressure',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
