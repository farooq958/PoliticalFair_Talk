import 'dart:typed_data';
import 'package:aft/ATESTS/provider/user_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../info screens/welcome_screen.dart';
import '../methods/auth_methods.dart';
import '../utils/utils.dart';
import 'login_screen.dart';
import '../info screens/data_privacy.dart';
import '../info screens/terms_conditions.dart';
import 'package:aft/ATESTS/methods/firestore_methods.dart';

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
        // if (!mounted) return;
        // showSnackBar("Welcome ${_usernameController.text.trim()}!", context);
        goToHome(context);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(
                username: _usernameController.text.trim(),
                durationInDay: widget.durationInDay),
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
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.transparent,
        child: SafeArea(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 1,
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
                      const SizedBox(height: 20),
                      Image.asset(
                        width: MediaQuery.of(context).size.width * 1 - 80,
                        'assets/fairtalk_blue_transparent.png',
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 1 - 80,
                        child: const Text(
                          'A platform built to unite us all.',
                          style: TextStyle(
                              color: Color.fromARGB(255, 36, 64, 101),
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                              fontFamily: 'Capitalis'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: SizedBox(
                          height: 60,
                          child: Theme(
                            data: themeData.copyWith(inputDecorationTheme:
                                themeData.inputDecorationTheme.copyWith(
                              prefixIconColor: MaterialStateColor.resolveWith(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.focused)) {
                                  return const Color.fromARGB(255, 36, 64, 101);
                                }

                                return Colors.grey;
                              }),
                            )),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              controller: _usernameController,
                              maxLength: 16,
                              decoration: InputDecoration(
                                  counterText: '',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 36, 64, 101),
                                        width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  labelText: 'Username',
                                  labelStyle: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                  hintStyle: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                  fillColor:
                                      const Color.fromARGB(255, 245, 245, 245),
                                  filled: true,
                                  prefixIcon: const Icon(
                                    Icons.person_outlined,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Theme(
                        data: themeData.copyWith(inputDecorationTheme:
                            themeData.inputDecorationTheme.copyWith(
                          prefixIconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return const Color.fromARGB(255, 36, 64, 101);
                            }

                            return Colors.grey;
                          }),
                        )),
                        child: TextField(
                          textInputAction: TextInputAction.next,
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
                                    color: Color.fromARGB(255, 36, 64, 101),
                                    width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1),
                              ),
                              labelText: 'Email Address',
                              labelStyle: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                              hintStyle: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                              fillColor:
                                  const Color.fromARGB(255, 245, 245, 245),
                              filled: true,
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                              )),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Theme(
                        data: themeData.copyWith(inputDecorationTheme:
                            themeData.inputDecorationTheme.copyWith(
                          prefixIconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return const Color.fromARGB(255, 36, 64, 101);
                            }

                            return Colors.grey;
                          }),
                        )),
                        child: TextField(
                          controller: _passwordController,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 36, 64, 101),
                                  width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                            ),
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                            hintStyle: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                            fillColor: const Color.fromARGB(255, 245, 245, 245),
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.lock_outline,
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
                                color: Colors.grey,
                                size: 22,
                              ),
                            ),
                          ),
                          obscureText: !_passwordVisible,
                        ),
                      ),
                      const SizedBox(height: 24),
                      PhysicalModel(
                        color: const Color.fromARGB(255, 36, 64, 101),
                        elevation: 3,
                        borderRadius: BorderRadius.circular(50),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            splashColor: Colors.black.withOpacity(0.3),
                            onTap: signUpUser,
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                                color: Colors.transparent,
                              ),
                              child: _isLoading
                                  ? const Center(
                                      child: SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          )),
                                    )
                                  : const Text('Sign Up',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, right: 12, left: 12),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                  text: 'By signing up, you agree to our ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12)),
                              TextSpan(
                                  text: 'Terms of Use',
                                  style: const TextStyle(
                                      color: Colors.blue, fontSize: 12),
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
                                      color: Colors.black, fontSize: 12)),
                              TextSpan(
                                  text: 'Privacy Policy.',
                                  style: const TextStyle(
                                      color: Colors.blue, fontSize: 12),
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
                      ),
                      const SizedBox(height: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(25),
                              splashColor: Colors.grey.withOpacity(0.3),
                              onTap: navigateToLogin,
                              child: SizedBox(
                                height: 45,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("Already have an account?",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13)),
                                    Text(
                                      "Log In",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromARGB(255, 81, 81, 81),
                                          fontSize: 14),
                                    ),
                                  ],
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
