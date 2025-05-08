import 'package:flutter/material.dart';
import 'package:flutter_siren/variables/variables.dart';

class Signal extends StatelessWidget {
  final String word;

  const Signal({
    super.key,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      height: 37.0,
      decoration: BoxDecoration(
        color: const Color(grey),
        border: Border.all(
          color: const Color(green),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Center(
        child: Text(
          word,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
