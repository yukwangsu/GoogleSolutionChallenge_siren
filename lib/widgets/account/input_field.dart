import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController inputController;
  final bool isSecret;

  const InputField({
    super.key,
    required this.inputController,
    required this.isSecret,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: inputController,
      obscureText: isSecret,
      cursorColor: const Color(0xFFA3A3A3),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFFA3A3A3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFFA3A3A3)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 15.0,
        ),
      ),
    );
  }
}
