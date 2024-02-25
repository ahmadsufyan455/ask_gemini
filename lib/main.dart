import 'package:ask_gemini/chat_screen.dart';
import 'package:ask_gemini/constant.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ask Gemini',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          color: greenAncent,
        ),
      ),
      home: const ChatScreen(),
    );
  }
}
