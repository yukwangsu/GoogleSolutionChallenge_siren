import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const NextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: const Color(0xFF7b9e89),
          foregroundColor: Colors.white,
          elevation: 0,
          side: const BorderSide(color: Color(0xFFA3A3A3), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // radius 5
          ),
        ),
        child: Text(
          text,
        ),
      ),
    );
  }
}
