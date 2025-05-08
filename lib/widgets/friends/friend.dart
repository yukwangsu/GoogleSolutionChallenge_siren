import 'package:flutter/material.dart';
import 'package:flutter_siren/variables/variables.dart';

class Friend extends StatelessWidget {
  final String id;
  final String name;

  const Friend({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 49.0,
      decoration: BoxDecoration(
        color: const Color(grey),
        border: Border.all(
          color: const Color(green),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      child: Row(
        children: [
          // user icon
          const Icon(Icons.person),
          const SizedBox(
            width: 24,
          ),

          // user name
          Text(
            name,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(green),
            ),
          ),
        ],
      ),
    );
  }
}
