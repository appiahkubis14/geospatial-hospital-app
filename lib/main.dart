<<<<<<< HEAD
// ignore_for_file: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hospitalmap/firebase_options.dart';
import 'package:hospitalmap/social_auth/provider/internet_provider.dart';
import 'package:hospitalmap/social_auth/provider/sign_in_provider.dart';
import 'package:hospitalmap/social_auth/screens/splash_screen.dart';
import 'package:hospitalmap/welcome/screens/welcome_screen.dart';
import 'package:hospitalmap/welcome/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kDebugMode) {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    );
  } else {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => SignInProvider()),
        ),
        ChangeNotifierProvider(
          create: ((context) => InternetProvider()),
        ),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        theme: darkMode,
        home: const SplashScreen(),
      ),
    );
  }
}
=======
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


>>>>>>> 7693faa (updated repo)
