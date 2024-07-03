

import 'package:flutter/material.dart';

class WeatherForecast extends StatelessWidget {
  final String time;
  final IconData iconData;
  final String temperature;

  const WeatherForecast({super.key, required this.time, required this.iconData, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 10,
        child: Container(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: [
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                time,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: 8,
              ),
              Icon(
                iconData,
                size: 32,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(temperature),
            ],
          ),
        ),
      ),
    );
  }
}
