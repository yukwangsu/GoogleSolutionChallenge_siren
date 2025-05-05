import 'package:flutter/material.dart';

class InputTitle extends StatelessWidget {
  final String title;

  const InputTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17.0),
          )
        ],
      ),
    );
  }
}
