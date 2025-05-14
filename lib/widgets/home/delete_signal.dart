import 'package:flutter/material.dart';
import 'package:flutter_siren/variables/variables.dart';

class DeleteSignal extends StatelessWidget {
  final String word;

  const DeleteSignal({
    super.key,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(light_green),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
          child: Text(
        word,
        style: const TextStyle(fontSize: 16),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      )),
    );
  }
}
