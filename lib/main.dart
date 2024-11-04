

import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:hospital_locator/screen/newScreen.dart';
import 'package:hospital_locator/screen/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    // WebView.platform = AndroidWebView();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(themeMode: ThemeMode.dark, 
    debugShowCheckedModeBanner: false,
     home: WelcomeScreen());
  }
}


