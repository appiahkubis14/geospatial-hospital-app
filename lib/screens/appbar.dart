// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hospitalmap/welcome/screens/signin_screen.dart';

class CustomIons extends StatefulWidget {
  const CustomIons({super.key});

  @override
  State<CustomIons> createState() => _CustomIonsState();
}

class _CustomIonsState extends State<CustomIons> {
  final GeolocatorPlatform _geoPlatform = GeolocatorPlatform.instance;

  void _locationSettings() async {
    await _geoPlatform.openLocationSettings();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          useRootNavigator: true,
          barrierDismissible: true,
          useSafeArea: true,
          context: context,
          builder: (context) {
            return AlertDialog(
              scrollable: true,
              actionsAlignment: MainAxisAlignment.center,
              content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const SignInScreen();
                              },
                            ));
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 255, 156, 7),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: const Icon(Icons.location_on),
                              ),
                              const SizedBox(height: 10),
                              const Text('Sign In'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const SignInScreen();
                              },
                            ));
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 247, 7, 255),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: const Icon(Icons.person),
                              ),
                              const SizedBox(height: 10),
                              const Text('Sign Up'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const SignInScreen();
                              },
                            ));
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 15, 255, 7),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: const Icon(Icons.settings),
                              ),
                              const SizedBox(height: 10),
                              const Text('Sign Out'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      icon: const Icon(
        Icons.menu,
      ),
    );
  }
}
