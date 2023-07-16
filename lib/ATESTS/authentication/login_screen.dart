import 'package:aft/ATESTS/provider/user_provider.dart';
import 'package:aft/ATESTS/services/firebase_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../methods/auth_methods.dart';
import '../models/user.dart';
import '../provider/google_sign_in.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import 'forgot_password.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  var durationInDay;

  LoginScreen({Key? key, this.durationInDay}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isLoadingGoogle = false;
  bool _passwordVisible = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  void loginUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // Future.delayed(const Duration(milliseconds: 50), () async {
    setState(() {
      _isLoading = true;
    });
    // String email = _emailController.text;
    String email = _emailController.text.toLowerCase();

    // Login with username
    if (!email.contains('@')) {
      var user = await FirebaseFirestore.instance
          .collection('users')
          // .where('username', isEqualTo: email)
          .where('usernameLower', isEqualTo: email)
          .get();
      if (user.docs.isNotEmpty) {
        email = user.docs.first.data()['aEmail'];
      }
    }
    String res = await AuthMethods()
        .loginUser(email: email, password: _passwordController.text);
    await userProvider.refreshTokenAndTopic();
    if (res != "success") {
      Future.delayed(const Duration(milliseconds: 1500), () {
        setState(() {
          _isLoading = false;
        });
      });
      if (!mounted) return;
      showSnackBarError(res, context);
    } else if (res == "success") {
      User? user = await AuthMethods().getUserDetails();
      if (user != null) {
        if (user.fcmToken != null && user.fcmToken!.isNotEmpty) {
          FirebaseNotification.subscribeTopic(user.fcmTopic!);
        }
        if (user.userReportCounter > 2) {
          AuthMethods().signOut();
          // DialogUtils.showMessageDialog();
          suspensionDialog(context: context);
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }
      if (!mounted) return;
      goToHome(context);
      showSnackBar("Successfully logged in.", context);
    } else {}
    setState(() {
      _isLoading = false;
    });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            darkBlue,
            testColor,
          ],
        )),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width > 600
                                ? 100
                                : 32),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 1 - 40,
                                child:
                                    Image.asset('assets/fairtalk_white.png')),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1 - 40,
                              child: const Text(
                                'A platform built to unite us all.',
                                style: TextStyle(
                                    color: whiteDialog,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    fontFamily: 'Capitalis'),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 36),
                            PhysicalModel(
                              borderRadius: BorderRadius.circular(25),
                              color: testColor,
                              elevation: 3,
                              child: TextField(
                                cursorColor: Colors.white,
                                style: const TextStyle(color: whiteDialog),
                                textInputAction: TextInputAction.next,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                        color: whiteDialog, width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                        color: testColor, width: 0),
                                  ),
                                  labelText: 'Username or Email',
                                  labelStyle: const TextStyle(
                                      fontSize: 14,
                                      color: whiteDialog,
                                      fontWeight: FontWeight.bold),
                                  // labelText: 'Username',
                                  fillColor: testColor,
                                  filled: true,
                                  prefixIcon: const Icon(Icons.person_outlined,
                                      color: whiteDialog),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            PhysicalModel(
                              borderRadius: BorderRadius.circular(25),
                              color: testColor,
                              elevation: 3,
                              child: TextField(
                                cursorColor: Colors.white,
                                style: const TextStyle(color: whiteDialog),
                                controller: _passwordController,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                        color: whiteDialog, width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                        color: testColor, width: 0),
                                  ),
                                  labelText: 'Password',
                                  labelStyle: const TextStyle(
                                      fontSize: 14,
                                      color: whiteDialog,
                                      fontWeight: FontWeight.bold),
                                  hintStyle: const TextStyle(
                                      fontSize: 14,
                                      color: whiteDialog,
                                      fontWeight: FontWeight.bold),
                                  fillColor: testColor,
                                  filled: true,
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Colors.white,
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                    child: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: whiteDialog,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                obscureText: !_passwordVisible,
                              ),
                            ),
                            const SizedBox(height: 14),
                            PhysicalModel(
                              color: whiteDialog,
                              elevation: 3,
                              borderRadius: BorderRadius.circular(50),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  splashColor: Colors.black.withOpacity(0.3),
                                  onTap: loginUser,
                                  child: Container(
                                    height: 45,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: _isLoading
                                        ? const Center(
                                            child: SizedBox(
                                                height: 18,
                                                width: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: darkBlue,
                                                )),
                                          )
                                        : const Text('Log in',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: darkBlue,
                                              fontWeight: FontWeight.bold,
                                            )),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width >
                                            600
                                        ? MediaQuery.of(context).size.width /
                                                2 -
                                            130
                                        : MediaQuery.of(context).size.width /
                                                2 -
                                            70,
                                    // MediaQuery.of(context).size.width / 2 - 194,
                                    decoration: const BoxDecoration(
                                      // color: Colors.red,
                                      border: Border(
                                        top: BorderSide(
                                            width: 1, color: whiteDialog),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 33,
                                  alignment: Alignment.center,
                                  child: const Text('or',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: whiteDialog,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Expanded(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width >
                                            600
                                        ? MediaQuery.of(context).size.width /
                                                2 -
                                            130
                                        : MediaQuery.of(context).size.width /
                                                2 -
                                            70,
                                    decoration: const BoxDecoration(
                                      // color: Colors.red,
                                      border: Border(
                                        top: BorderSide(
                                            width: 1, color: whiteDialog),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            PhysicalModel(
                              color: whiteDialog,
                              elevation: 3,
                              borderRadius: BorderRadius.circular(50),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  splashColor: Colors.grey.withOpacity(0.3),
                                  onTap: () async {
                                    final provider =
                                        Provider.of<GoogleSignInProvider>(
                                            context,
                                            listen: false);
                                    final user=await provider.googleLogin();
                                    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                                if(user!=null) {

                                  {
                                    DocumentSnapshot snap =
                                    await _firestore.collection('users').doc(user.uid).get();
                                    if(snap.data() == null)
                                    {
                                      final GoogleSignIn googleSignIn = GoogleSignIn();

                                        googleSignIn.signOut();




                                      showSnackBar(
                                          "You need to Sign Up", context);


                                    }
                                    else
                                      {
                                        goToHome(context);

                                        showSnackBar(
                                            "Successfully logged in.", context);
                                      }

                                  }

                                  }},
                                  child: Container(
                                    width: double.infinity,
                                    height: 45,
                                    alignment: Alignment.center,
                                    child: _isLoadingGoogle
                                        ? const Center(
                                            child: SizedBox(
                                                height: 18,
                                                width: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: darkBlue,
                                                )),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                  'assets/google-logo.png',
                                                  height: 23),
                                              const SizedBox(width: 16),
                                              const Text(
                                                'Log in with Google',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: darkBlue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(height: 7),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Expanded(
                            //       child: Container(
                            //         width: MediaQuery.of(context).size.width >
                            //                 600
                            //             ? MediaQuery.of(context).size.width /
                            //                     2 -
                            //                 130
                            //             : MediaQuery.of(context).size.width /
                            //                     2 -
                            //                 70,
                            //         // MediaQuery.of(context).size.width / 2 - 194,
                            //         decoration: const BoxDecoration(
                            //           // color: Colors.red,
                            //           border: Border(
                            //             top: BorderSide(
                            //                 width: 1, color: whiteDialog),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //     Container(
                            //       width: 33,
                            //       alignment: Alignment.center,
                            //       child: const Text('or',
                            //           style: TextStyle(
                            //             fontSize: 14,
                            //             color: whiteDialog,
                            //             fontWeight: FontWeight.bold,
                            //           )),
                            //     ),
                            //     Expanded(
                            //       child: Container(
                            //         width: MediaQuery.of(context).size.width >
                            //                 600
                            //             ? MediaQuery.of(context).size.width /
                            //                     2 -
                            //                 130
                            //             : MediaQuery.of(context).size.width /
                            //                     2 -
                            //                 70,
                            //         decoration: const BoxDecoration(
                            //           // color: Colors.red,
                            //           border: Border(
                            //             top: BorderSide(
                            //                 width: 1, color: whiteDialog),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(height: 7),
                            // PhysicalModel(
                            //   color: whiteDialog,
                            //   elevation: 3,
                            //   borderRadius: BorderRadius.circular(50),
                            //   child: Material(
                            //     color: Colors.transparent,
                            //     borderRadius: BorderRadius.circular(25),
                            //     child: InkWell(
                            //       borderRadius: BorderRadius.circular(25),
                            //       splashColor: Colors.white.withOpacity(0.5),
                            //       onTap: () {
                            //         Future.delayed(
                            //             const Duration(milliseconds: 150), () {
                            //           goToHomeAsGuest(context);
                            //         });
                            //       },
                            //       child: Container(
                            //         height: 45,
                            //         width: double.infinity,
                            //         alignment: Alignment.center,
                            //         padding: const EdgeInsets.symmetric(
                            //             vertical: 12),
                            //         decoration: const ShapeDecoration(
                            //             shape: RoundedRectangleBorder(
                            //               borderRadius: BorderRadius.all(
                            //                 Radius.circular(25),
                            //               ),
                            //             ),
                            //             color: Colors.transparent),
                            //         child: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           children: const [
                            //             Icon(Icons.account_circle,
                            //                 size: 23, color: darkBlue),
                            //             SizedBox(width: 6),
                            //             Text('Continue as a Guest',
                            //                 style: TextStyle(
                            //                   fontSize: 16,
                            //                   color: darkBlue,
                            //                   fontWeight: FontWeight.bold,
                            //                 )),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 150),
                                () {
                              goToHomeAsGuest(context);
                            });
                          },
                          borderRadius: BorderRadius.circular(25),
                          splashColor: Colors.white.withOpacity(0.3),
                          child: SizedBox(
                            width: 200,
                            height: 45,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.account_circle,
                                    color: whiteDialog, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  "Continue as a Guest",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: whiteDialog,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  splashColor: Colors.white.withOpacity(0.3),
                                  onTap: () {
                                    Future.delayed(
                                        const Duration(milliseconds: 150), () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignupScreen(
                                                durationInDay:
                                                    widget.durationInDay)),
                                      );
                                    });
                                  },
                                  child: SizedBox(
                                    width: 140,
                                    height: 45,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Don't have an account?",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 230, 230),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            )),
                                        Container(height: 2),
                                        const Text(
                                          "Sign up",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: whiteDialog,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  splashColor: Colors.white.withOpacity(0.3),
                                  onTap: () {
                                    Future.delayed(
                                        const Duration(milliseconds: 150), () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPassword(),
                                        ),
                                      );
                                    });
                                  },
                                  child: SizedBox(
                                    width: 140,
                                    height: 45,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Forgot password?",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 230, 230),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            )),
                                        Container(height: 2),
                                        const Text(
                                          "Click here",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: whiteDialog,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
