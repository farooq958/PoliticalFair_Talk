import 'dart:typed_data';
import 'package:aft/ATESTS/provider/user_provider.dart';
import 'package:animate_gradient/animate_gradient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../info screens/welcome_screen.dart';
import '../methods/auth_methods.dart';
import '../provider/google_sign_in.dart';
import '../services/auth_service.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import 'google_username.dart';
import 'login_screen.dart';
import '../info screens/data_privacy.dart';
import '../info screens/terms_conditions.dart';
import 'package:aft/ATESTS/methods/firestore_methods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupScreen extends StatefulWidget {
  var durationInDay;
  SignupScreen({Key? key, this.durationInDay}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;
  bool _isLoadingGoogle = false;
  bool _passwordVisible = false;
  String oneValue = '';

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  // // Validates "username" field
  // Future<String?> usernameValidator({required String? username}) async {
  //   // Validates username complexity
  //   bool isUsernameComplex(String? text) {
  //     final String _text = (text ?? "");
  //     // String? p = r"^(?=(.*[0-9]))(?=(.*[A-Za-z]))";
  //     String? p = r"^(?=(.*[ @$!%*?&=_+/#^.~`]))";
  //     RegExp regExp = RegExp(p);
  //     return regExp.hasMatch(_text);
  //   }

  //   final String _text = (username ?? "");

  //   // Complexity check
  //   if (isUsernameComplex(_text)) {
  //     return "Username should only be letters and numbers";
  //   }
  //   // Length check
  //   else if (_text.length < 3 || _text.length > 16) {
  //     return "Username should be 3-16 characters long";
  //   }

  //   // Availability check
  //   var val = await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('username', isEqualTo: _text)
  //       .get();
  //   if (val.docs.isNotEmpty) {
  //     return "This username is not available";
  //   }

  //   return null;
  // }

  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // return await FirebaseAuth.instance.signInWithCredential(credential);

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void signUpUser() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Validates username
      String? userNameValid =
          await usernameValidator(username: _usernameController.text);
      if (userNameValid != null) {
        if (!mounted) return;
        showSnackBarError(userNameValid, context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      String res = await AuthMethods().signUpUser(
        username: _usernameController.text.trim(),
        aEmail: _emailController.text.trim(),
        password: _passwordController.text,
        profilePicFile: _image,
        aaCountry: '',
        pending: 'false',
        bio: '',
        gMessageTime: 0,
        nMessageTime: 0,
        gPollTime: 0,
        nPollTime: 0,
      );

      if (res != "success") {
        Future.delayed(const Duration(milliseconds: 1500), () {
          setState(() {
            _isLoading = false;
          });
        });
        if (!mounted) return;
        showSnackBarError(res, context);
      } else {
        // goToHome(context);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(
              username: _usernameController.text.trim(),
            ),
          ),
          (route) => false,
        );
        FirestoreMethods().postCounter('user');
      }
    } catch (e) {
      // debugPrint('signup error $e $st');
    }
  }

  void navigateToLogin() {
    Future.delayed(const Duration(milliseconds: 150), () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              LoginScreen(durationInDay: widget.durationInDay),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      // backgroundColor: Colors.white,
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
          child: Container(
            // width: double.infinity,
            // height: MediaQuery.of(context).size.height * 1,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                // reverse: true,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.width > 600 ? 100 : 32),
                    child: Column(children: [
                      const SizedBox(height: 30),
                      Image.asset(
                        width: MediaQuery.of(context).size.width * 1 - 40,
                        'assets/fairtalk_new_white_transparent.png',
                      ),
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
                          controller: _usernameController,
                          maxLength: 16,
                          decoration: InputDecoration(
                            counterText: '',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                  color: whiteDialog, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide:
                                  const BorderSide(color: testColor, width: 0),
                            ),
                            labelText: 'Username',
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
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.white,
                          style: const TextStyle(color: whiteDialog),
                          controller: _emailController,
                          onChanged: (val) {
                            setState(() {
                              // emptyPollQuestion = false;
                            });
                          },
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
                              labelText: 'Email Address',
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
                              prefixIcon: const Icon(Icons.email_outlined,
                                  color: whiteDialog)),
                        ),
                      ),
                      const SizedBox(height: 14),
                      PhysicalModel(
                        borderRadius: BorderRadius.circular(25),
                        color: testColor,
                        elevation: 3,
                        child: TextField(
                          controller: _passwordController,
                          cursorColor: Colors.white,
                          style: const TextStyle(color: whiteDialog),
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                  color: whiteDialog, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide:
                                  const BorderSide(color: testColor, width: 0),
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
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: whiteDialog),
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
                        borderRadius: BorderRadius.circular(25),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            splashColor: Colors.black.withOpacity(0.3),
                            onTap: signUpUser,
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              alignment: Alignment.center,
                              // padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                // border: Border.all(
                                //     color: Colors.white, width: 2),
                              ),

                              child: _isLoading
                                  ? const Center(
                                      child: SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          color: darkBlue,
                                        ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('Sign up',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: darkBlue,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    ),
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
                              width: MediaQuery.of(context).size.width > 600
                                  ? MediaQuery.of(context).size.width / 2 - 130
                                  : MediaQuery.of(context).size.width / 2 - 70,
                              // MediaQuery.of(context).size.width / 2 - 194,
                              decoration: const BoxDecoration(
                                // color: Colors.red,
                                border: Border(
                                  top: BorderSide(width: 1, color: whiteDialog),
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
                              width: MediaQuery.of(context).size.width > 600
                                  ? MediaQuery.of(context).size.width / 2 - 130
                                  : MediaQuery.of(context).size.width / 2 - 70,
                              decoration: const BoxDecoration(
                                // color: Colors.red,
                                border: Border(
                                  top: BorderSide(width: 1, color: whiteDialog),
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
                              // final provider =
                              //     Provider.of<GoogleSignInProvider>(context,
                              //         listen: false);

                              // provider.googleLogin();
                              await signInWithGoogle();
                              if (mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CreateUsernameGoogle(),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                // border: Border.all(
                                //     color: Colors.white, width: 2),
                              ),
                              child: _isLoadingGoogle
                                  ? const Center(
                                      child: SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            color: darkBlue,
                                          )),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/google-logo.png',
                                            height: 23),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Sign up with Google',
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
                      const SizedBox(height: 7),
                      RichText(
                        softWrap: true,
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'By signing up, you agree to our ',
                                style: TextStyle(
                                    color: whiteDialog,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: 'Terms of Use',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 103, 187, 255),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const TermsConditions(),
                                      ),
                                    );
                                  }),
                            const TextSpan(
                                text:
                                    ' and confirm that you have read and understood our ',
                                style: TextStyle(
                                    color: whiteDialog,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: 'Privacy Policy.',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 103, 187, 255),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DataPrivacy(),
                                      ),
                                    );
                                  }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(25),
                              splashColor: Colors.white.withOpacity(0.3),
                              onTap: navigateToLogin,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: SizedBox(
                                  height: 45,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("Already have an account?",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 230, 230, 230),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Text(
                                        "Log in",
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ]),
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
