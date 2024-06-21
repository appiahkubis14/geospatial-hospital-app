// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hospitalmap/auth/services/forgot_password.dart';
import 'package:hospitalmap/screens/map.dart';
import 'package:hospitalmap/social_auth/provider/internet_provider.dart';
import 'package:hospitalmap/social_auth/provider/sign_in_provider.dart';
import 'package:hospitalmap/social_auth/utils/next_screen.dart';
import 'package:hospitalmap/social_auth/utils/snack_bar.dart';
import 'package:hospitalmap/welcome/screens/signup_screen.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:hospitalmap/welcome/widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:twitter_login/twitter_login.dart';
import '../theme/theme.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String email = "", password = "";
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  bool isloading = false;

  static const String mapUrl =
      "https://accugeo.maps.arcgis.com/apps/webappviewer/index.html?id=863e254d0ce0497d93f696c57d28daf9";

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WebViewMap(url: mapUrl),
        ),
      );
      ;
      setState(() {
        isloading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0),
            )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0),
            )));
      }
    }
  }

  Future<UserCredential> signInWithTwitter() async {
    try {
      // Create a TwitterLogin instance
      final twitterLogin = TwitterLogin(
        apiKey: 'wXx8f93URcz8JoJuLcoNjE9lK',
        apiSecretKey: 'I2fzUOCYnGn15LStqST0FIWo98dO1vsB8RCX1mhvmJZ3Qlv2L3',
        redirectURI: 'yamforo://',
      );

      // Trigger the sign-in flow
      final authResult = await twitterLogin.login();

      // Check if authentication was successful
      if (authResult.status == TwitterLoginStatus.loggedIn) {
        // Create a credential from the access token
        final twitterAuthCredential = TwitterAuthProvider.credential(
          accessToken: authResult.authToken!,
          secret: authResult.authTokenSecret!,
        );

        // Sign in with Firebase Auth using Twitter credentials
        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(twitterAuthCredential);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WebViewMap(url: mapUrl),
          ),
        );
        // Return the signed-in user
        return userCredential;
      } else {
        throw Exception('Twitter authentication failed');
      }
    } catch (e) {
      print('Error signing in with Twitter: $e');
      throw e;
    }
  }

  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController facebookController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController twitterController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController phoneController =
      RoundedLoadingButtonController();

  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: _emailcontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          hintText: 'Enter Email',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: _passwordcontroller,
                        obscureText: false,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberPassword,
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberPassword = value!;
                                  });
                                },
                                activeColor: lightColorScheme.primary,
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPassword(),
                                )),
                            child: Text(
                              'Forget password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formSignInKey.currentState!.validate() &&
                                  rememberPassword) {
                                setState(() {
                                  email = _emailcontroller.text;
                                  password = _passwordcontroller.text;
                                  isloading = true;
                                });

                                userLogin();
                              } else if (!rememberPassword) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please agree to the processing of personal data',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: isloading
                                ? const Center(
                                    child: CupertinoActivityIndicator(
                                      color: Colors.black,
                                    ),
                                  )
                                : const Text('Sign in')),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Sign up with',
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundedLoadingButton(
                              onPressed: () {
                                SignInProvider().signInWithGoogle();
                                Navigator.pushReplacementNamed(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const WebViewMap(url: mapUrl),
                                    ) as String);
                              },
                              controller: googleController,
                              successColor: Colors.red,
                              completionDuration: Duration(seconds: 15),
                              width: 50,
                              elevation: 0,
                              borderRadius: 25,
                              color: const Color.fromARGB(255, 171, 202, 204),
                              child: Wrap(
                                children: [Brand(Brands.google)],
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            // facebook login button
                            // RoundedLoadingButton(
                            //   onPressed: () {
                            //     SignInProvider().signInWithFacebook();
                            //   },
                            //   controller: facebookController,
                            //   successColor: Colors.blue,
                            //   width: 50,
                            //   elevation: 0,
                            //   color: const Color.fromARGB(255, 171, 202, 204),
                            //   borderRadius: 25,
                            //   child: Wrap(
                            //     children: [Brand(Brands.facebook)],
                            //   ),
                            // ),
                            // const SizedBox(
                            //   height: 10,
                            // ),

                            // twitter loading button
                            RoundedLoadingButton(
                              onPressed: () {
                                signInWithTwitter();
                                Navigator.pushReplacementNamed(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const WebViewMap(url: mapUrl),
                                    ) as String);
                              },
                              controller: twitterController,
                              successColor: Colors.lightBlue,
                              width: 50,
                              elevation: 0,
                              color: const Color.fromARGB(255, 171, 202, 204),
                              borderRadius: 25,
                              child: Wrap(
                                children: [Brand(Brands.twitter)],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // phoneAuth loading button
                            // RoundedLoadingButton(
                            //   onPressed: () {
                            //     nextScreenReplace(
                            //         context, const PhoneAuthScreen());
                            //     phoneController.reset();
                            //   },
                            //   controller: phoneController,
                            //   successColor: Colors.black,
                            //   width: 50,
                            //   elevation: 0,
                            //   color: const Color.fromARGB(255, 171, 202, 204),
                            //   borderRadius: 25,
                            //   child: Wrap(
                            //     children: [Brand(Brands.phone)],
                            //   ),
                            // ),
                            // RoundedLoadingButton(
                            //   onPressed: () {
                            //     SignInProvider().signInWithApple();
                            //   },
                            //   controller: phoneController,
                            //   successColor: Colors.black,
                            //   width: 50,
                            //   elevation: 0,
                            //   color: const Color.fromARGB(255, 171, 202, 204),
                            //   borderRadius: 25,
                            //   child: Wrap(
                            //     children: [Brand(Brands.apple_logo)],
                            //   ),
                            // ),
                          ]),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // don't have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future handleTwitterAuth() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
      googleController.reset();
    } else {
      await sp.signInWithTwitter().then((value) {
        if (sp.hasError == true) {
          openSnackbar(context, sp.errorCode.toString(), Colors.red);
          twitterController.reset();
        } else {
          // checking whether user exists or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user exists
              await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        twitterController.success();
                        handleAfterSignIn();
                      })));
            } else {
              // user does not exist
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        twitterController.success();
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

  // handling google sigin in
  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          openSnackbar(context, sp.errorCode.toString(), Colors.red);
          googleController.reset();
        } else {
          // checking whether user exists or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user exists
              await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        googleController.success();
                        handleAfterSignIn();
                      })));
            } else {
              // user does not exist
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        googleController.success();
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

  // handling facebookauth
  // handling google sigin in
  Future handleFacebookAuth() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
      facebookController.reset();
    } else {
      await sp.signInWithFacebook().then((value) {
        if (sp.hasError == true) {
          openSnackbar(context, sp.errorCode.toString(), Colors.red);
          facebookController.reset();
        } else {
          // checking whether user exists or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user exists
              await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        facebookController.success();
                        handleAfterSignIn();
                      })));
            } else {
              // user does not exist
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        facebookController.success();
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

  // handle after signin
  handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      nextScreenReplace(context, const WebViewMap(url: mapUrl));
    });
  }
}
