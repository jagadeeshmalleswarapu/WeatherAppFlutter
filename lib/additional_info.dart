import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  final IconData icon;
  final String textVal;
  final String textNum;
  const AdditionalInfo({super.key, required this.icon, required this.textVal
  ,required this.textNum});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(
          height: 8,
        ),
        Text(textVal),
        const SizedBox(
          height: 8,
        ),
        Text(
          textNum,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
