// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison, unused_local_variable, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hospitalmap/screens/map.dart';
import 'package:hospitalmap/social_auth/provider/sign_in_provider.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:hospitalmap/welcome/screens/signin_screen.dart';
import 'package:hospitalmap/welcome/theme/theme.dart';
import 'package:hospitalmap/welcome/widgets/custom_scaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:twitter_login/twitter_login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email = "", password = "", name = "";
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _namecontroller = TextEditingController();
  bool isloading = false;
  File? _image;

  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController facebookController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController twitterController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController phoneController =
      RoundedLoadingButtonController();

  static const String mapUrl =
      "https://accugeo.maps.arcgis.com/apps/webappviewer/index.html?id=863e254d0ce0497d93f696c57d28daf9";

  registration() async {
    if (password != null &&
        _namecontroller.text != "" &&
        _emailcontroller.text != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        saveUserDataToDatabase();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Registered Successfully",
          style: TextStyle(fontSize: 20.0),
        )));
        setState(() {
          isloading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignInScreen()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
      }
    }
  }

  selectImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(source: source);

    if (imageFile != null) {
      setState(() {
        _image = File(imageFile.path);
      });
    }
  }

  Future<String> _uploadImage() async {
    final storage = FirebaseStorage.instance;
    final imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = storage.ref().child('Images').child(imageName);
    final uploadTask = ref.putFile(_image!);
    final snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  void saveUserDataToDatabase() async {
    try {
      await Firebase.initializeApp();

      final imageUrl = await _uploadImage();
      final userData = {
        'IMAGE URL': imageUrl,
        'NAME': _namecontroller.text,
        'EMAIL': _emailcontroller.text,
        'PASSWORD': _passwordcontroller.text
      };

      await FirebaseFirestore.instance.collection('users').add(userData);

      setState(() {
        isloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('      Congratulation \n     User data saved successfully'),
          showCloseIcon: true,
          backgroundColor: Color.fromARGB(255, 54, 244, 54),
          dismissDirection: DismissDirection.up,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
        ),
      );
    } catch (error) {
      setState(() {
        isloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          content: Text('Failed to save user data: $error'),
          showCloseIcon: true,
          backgroundColor: Colors.red,
          dismissDirection: DismissDirection.up,
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<bool> query(String code, String field) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('ghis-ss-members')
        .where(field, isEqualTo: code)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> _showImageSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    selectImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 7, 131),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: const Icon(Icons.camera_alt),
                      ),
                      const SizedBox(height: 20),
                      const Text('CAMERA'),
                    ],
                  ),
                ),
                const SizedBox(width: 45),
                GestureDetector(
                  onTap: () {
                    selectImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 247, 7, 255),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: const Icon(Icons.photo),
                      ),
                      const SizedBox(height: 20),
                      const Text('GALLERY'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//GOOGLE SIGN IN
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

//FACEBOOK SIGN IN
  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

//APPLE SIGN IN
  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();

    try {
      // Sign in with Apple using Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(appleProvider);
      String? authCode = userCredential.additionalUserInfo?.authorizationCode;
      await FirebaseAuth.instance.revokeTokenWithAuthorizationCode(authCode!);
      return userCredential;
    } catch (e) {
      print('Error signing in with Apple: $e');
      throw FirebaseAuthException(
        code: 'apple_sign_in_failed',
        message: 'Error signing in with Apple',
      );
    }
  }

//TWITTER SIGN IN

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

  // Future<UserCredential> signInWithTwitter() async {
  //   // Create a TwitterLogin instance
  //   final twitterLogin = TwitterLogin(
  //       apiKey: 'dcYK0pY7kbV5FKxb269vQavGD',
  //       apiSecretKey: 'NtzGwyiBPdbACphZXQw72pLWHVGoXHVfewyINlOFBBsoXNKKob',
  //       redirectURI:
  //           'https://hospitalmap-78d7e.firebaseapp.com/__/auth/handler');

  //   // Trigger the sign-in flow
  //   final authResult = await twitterLogin.login();

  //   // Create a credential from the access token
  //   final twitterAuthCredential = TwitterAuthProvider.credential(
  //     accessToken: authResult.authToken!,
  //     secret: authResult.authTokenSecret!,
  //   );

  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance
  //       .signInWithCredential(twitterAuthCredential);
  // }

  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
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
            flex: 18,
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
                // get started form
                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // get started text
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 90,
                                  backgroundImage: FileImage(_image!),
                                )
                              : const CircleAvatar(
                                  radius: 90,
                                  backgroundImage:
                                      AssetImage('assets/avatar.png')),
                          Positioned(
                            bottom: -10,
                            left: 120,
                            child: IconButton(
                              onPressed: () => _showImageSelectionDialog(),
                              icon: const Icon(
                                Icons.add_a_photo,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      // full name
                      TextFormField(
                        controller: _namecontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Full name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Full Name'),
                          hintText: 'Enter Full Name',
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
                      // email
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
                      // password
                      TextFormField(
                        controller: _passwordcontroller,
                        obscureText: true,
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
                      // i agree to the processing
                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (bool? value) {
                              setState(() {
                                agreePersonalData = value!;
                              });
                            },
                            activeColor: lightColorScheme.primary,
                          ),
                          const Text(
                            'I agree to the processing of ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          Text(
                            'Personal data',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: lightColorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // signup button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formSignupKey.currentState!.validate() &&
                                agreePersonalData) {
                              setState(() {
                                name = _namecontroller.text;
                                email = _emailcontroller.text;
                                password = _passwordcontroller.text;
                                isloading = true;
                              });

                              registration();
                            } else if (!agreePersonalData) {
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
                              : const Text('Sign up'),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      // sign up divider
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
                        height: 30.0,
                      ),
                      // sign up social media logo
                      Center(
                        child: Row(
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
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignInScreen(),
                                ),
                              );
                            },
                            child: isloading
                                ? const Center(
                                    child: CupertinoActivityIndicator(),
                                  )
                                : Text(
                                    'Sign in',
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

  // Future handleTwitterAuth() async {
  //   final sp = context.read<SignInProvider>();
  //   final ip = context.read<InternetProvider>();
  //   await ip.checkInternetConnection();

  //   if (ip.hasInternet == false) {
  //     openSnackbar(context, "Check your Internet connection", Colors.red);
  //     googleController.reset();
  //   } else {
  //     await sp.signInWithTwitter().then((value) {
  //       if (sp.hasError == true) {
  //         openSnackbar(context, sp.errorCode.toString(), Colors.red);
  //         twitterController.reset();
  //       } else {
  //         // checking whether user exists or not
  //         sp.checkUserExists().then((value) async {
  //           if (value == true) {
  //             // user exists
  //             await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
  //                 .saveDataToSharedPreferences()
  //                 .then((value) => sp.setSignIn().then((value) {
  //                       twitterController.success();
  //                       handleAfterSignIn();
  //                     })));
  //           } else {
  //             // user does not exist
  //             sp
  //                 .saveDataToFirestore()
  //                 .then((value) => sp.saveDataToSharedPreferences().then(
  //                       (value) => sp.setSignIn().then(
  //                         (value) {
  //                           twitterController.success();
  //                           handleAfterSignIn();
  //                         },
  //                       ),
  //                     ));
  //           }
  //         });
  //       }
  //     });
  //   }
  // }

  // // handling google sigin in
  // Future handleGoogleSignIn() async {
  //   final sp = context.read<SignInProvider>();
  //   final ip = context.read<InternetProvider>();
  //   await ip.checkInternetConnection();

  //   if (ip.hasInternet == false) {
  //     openSnackbar(context, "Check your Internet connection", Colors.red);
  //     googleController.reset();
  //   } else {
  //     await sp.signInWithGoogle().then((value) {
  //       if (sp.hasError == true) {
  //         openSnackbar(context, sp.errorCode.toString(), Colors.red);
  //         googleController.reset();
  //       } else {
  //         // checking whether user exists or not
  //         sp.checkUserExists().then((value) async {
  //           if (value == true) {
  //             // user exists
  //             await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
  //                 .saveDataToSharedPreferences()
  //                 .then((value) => sp.setSignIn().then((value) {
  //                       googleController.success();
  //                       handleAfterSignIn();
  //                     })));
  //           } else {
  //             // user does not exist
  //             sp.saveDataToFirestore().then((value) => sp
  //                 .saveDataToSharedPreferences()
  //                 .then((value) => sp.setSignIn().then((value) {
  //                       googleController.success();
  //                       handleAfterSignIn();
  //                     })));
  //           }
  //         });
  //       }
  //     });
  //   }
  // }

  // // handling facebookauth
  // // handling google sigin in
  // Future handleFacebookAuth() async {
  //   final sp = context.read<SignInProvider>();
  //   final ip = context.read<InternetProvider>();
  //   await ip.checkInternetConnection();

  //   if (ip.hasInternet == false) {
  //     openSnackbar(context, "Check your Internet connection", Colors.red);
  //     facebookController.reset();
  //   } else {
  //     await sp.signInWithFacebook().then((value) {
  //       if (sp.hasError == true) {
  //         openSnackbar(context, sp.errorCode.toString(), Colors.red);
  //         facebookController.reset();
  //       } else {
  //         // checking whether user exists or not
  //         sp.checkUserExists().then((value) async {
  //           if (value == true) {
  //             // user exists
  //             await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
  //                 .saveDataToSharedPreferences()
  //                 .then((value) => sp.setSignIn().then((value) {
  //                       facebookController.success();
  //                       handleAfterSignIn();
  //                     })));
  //           } else {
  //             // user does not exist
  //             sp.saveDataToFirestore().then((value) => sp
  //                 .saveDataToSharedPreferences()
  //                 .then((value) => sp.setSignIn().then((value) {
  //                       facebookController.success();
  //                       handleAfterSignIn();
  //                     })));
  //           }
  //         });
  //       }
  //     });
  //   }
  // }

  // static const String mapUrl =
  //     "https://accugeo.maps.arcgis.com/apps/webappviewer/index.html?id=863e254d0ce0497d93f696c57d28daf9";

  // // handle after signin
  // handleAfterSignIn() {
  //   Future.delayed(const Duration(milliseconds: 1000)).then((value) {
  //     nextScreenReplace(
  //         context,
  //         const WebViewMap(
  //           url: mapUrl,
  //         ));
  //   });
  // }
}
