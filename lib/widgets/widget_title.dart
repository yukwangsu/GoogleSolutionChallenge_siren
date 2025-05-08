import 'package:flutter/material.dart';
import 'package:flutter_siren/variables/variables.dart';

class WidgetTitle extends StatelessWidget {
  final String title;

  const WidgetTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/siren_img.png'),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Color(green),
          ),
        )
      ],
    );
  }
}
