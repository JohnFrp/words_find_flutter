import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:words_find/model/words.find.dart';
import 'package:words_find/provider/theme.provider.dart';

void main(List<String> args) {
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const WordFind(),
    );
  }
}
