import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constant.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: GoogleFonts.fredoka(),
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Ask gemini...',
        hintStyle: GoogleFonts.fredoka(color: greenDark),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: greenDark,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: greenDark,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: const BorderSide(
            color: greenDark,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
