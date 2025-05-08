import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final TextEditingController inputController;
  final String hint;

  const InputText({
    super.key,
    required this.inputController,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: inputController,
      cursorColor: const Color(0xFFA3A3A3),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFFA3A3A3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFFA3A3A3)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 15.0,
        ),
      ),
    );
  }
}
