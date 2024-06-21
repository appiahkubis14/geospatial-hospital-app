import 'dart:async';

import 'package:hospitalmap/screens/map.dart';
import 'package:hospitalmap/social_auth/provider/sign_in_provider.dart';

import 'package:hospitalmap/social_auth/utils/config.dart';
import 'package:hospitalmap/social_auth/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:hospitalmap/welcome/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const String mapUrl =
      "https://accugeo.maps.arcgis.com/apps/webappviewer/index.html?id=863e254d0ce0497d93f696c57d28daf9";

  // init state
  @override
  void initState() {
    final sp = context.read<SignInProvider>();
    super.initState();
    // create a timer of 2 seconds
    Timer(const Duration(seconds: 2), () {
      sp.isSignedIn == false
          ? nextScreen(context, const WelcomeScreen())
          : nextScreen(context, const WebViewMap(url: mapUrl));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(),
      ),
    );
  }
}
//lAAZckPyymaD8BTZmEzTM82Whi42
// libhospitalmap/social_auth/screens/splash_screen.dart
