import 'package:flutter/material.dart';
import 'package:hospitalmap/welcome/screens/signin_screen.dart';
import 'package:hospitalmap/welcome/screens/signup_screen.dart';
import 'package:hospitalmap/welcome/theme/theme.dart';
import 'package:hospitalmap/welcome/widgets/custom_scaffold.dart';
import 'package:hospitalmap/welcome/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: 'Welcome To Hospital Map\n',
                            style: TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.w600,
                            )),
                        WidgetSpan(
                            child: SizedBox(
                          height: 70,
                        )),
                        TextSpan(
                            text: """
This app helps you find hospitals and navigate to them using Google Maps. Here's what you can do:

Find Nearby Hospitals: Explore hospitals near your location on the map.

Get Directions: Get turn-by-turn directions to your selected hospital.

View Hospital Details: Tap on markers to see hospital names, addresses, and contact information.
                                """,
                            style: TextStyle(
                              fontSize: 15,
                              // height: 0,
                            ))
                      ],
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  const Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign in',
                      onTap: SignInScreen(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign up',
                      onTap: const SignUpScreen(),
                      color: Colors.white,
                      textColor: lightColorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
