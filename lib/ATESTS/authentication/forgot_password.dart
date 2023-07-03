import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 245, 245, 245),
          appBar: AppBar(
            // title: Text('Back'),
            elevation: 4,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: [
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Material(
                            shape: const CircleBorder(),
                            color: Colors.transparent,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              splashColor: Colors.grey.withOpacity(0.5),
                              child: const Icon(Icons.keyboard_arrow_left,
                                  color: Colors.black),
                              onTap: () {
                                Future.delayed(const Duration(milliseconds: 50),
                                    () {
                                  Navigator.of(context).pop();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'User Credential Recovery',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              shrinkWrap: true,
              reverse: true,
              children: [
                const SizedBox(height: 6),
                // Container(
                //   width: MediaQuery.of(context).size.width - 32,
                //   decoration: const BoxDecoration(
                //     border: Border(
                //       top: BorderSide(width: 0.5, color: Colors.grey),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 24),
                const Text(
                    'To reset your password, you must first provide your email address.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.5,
                        color: Colors.black)),
                const SizedBox(height: 12),
                Theme(
                  data: themeData.copyWith(inputDecorationTheme:
                      themeData.inputDecorationTheme.copyWith(
                    prefixIconColor: MaterialStateColor.resolveWith(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.focused)) {
                        return darkBlue;
                      }

                      return Colors.grey;
                    }),
                  )),
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    controller: emailController,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              const BorderSide(color: darkBlue, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1),
                        ),
                        labelText: 'Email',
                        labelStyle: const TextStyle(
                            fontSize: 16,
                            letterSpacing: 0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                        // labelText: 'Username',
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                        )),
                  ),
                ),
                const SizedBox(height: 12),
                UnconstrainedBox(
                  child: Material(
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      splashColor: Colors.black.withOpacity(0.3),
                      onTap: resetPassword,
                      child: Container(
                        width: 170,
                        // width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            color: Colors.transparent),
                        child: const Text('Reset Password',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: MediaQuery.of(context).size.width - 32,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Forgot your username or email address?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.5,
                        color: Colors.black)),
                const SizedBox(height: 12),
                const Text('Contact us by email:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.5,
                        color: Colors.black)),
                Text(
                  '$email ',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.5,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: MediaQuery.of(context).size.width - 32,
                  decoration: const BoxDecoration(
                    // color: Colors.red,
                    border: Border(
                      top: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ].reversed.toList(),
            ),
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => Center(),
    // );
    String res = "Some error occurred.";
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      if (!mounted) return;
      showSnackBar(
          'Reset password email sent, please verify your mailbox.', context);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'unknown' || e.code == 'invalid-email') {
        res = "Please enter a valid email address.";
      } else if (e.code == 'user-not-found') {
        res = "No registered user found under this email address.";
      }
      // print(e);
      showSnackBarError(res.toString(), context);
      // Navigator.of(context).pop();
    } catch (err) {
      // res = err.toString();
      // showSnackBar(res.toString(), context);
    }
    // return showSnackBar(res.toString(), context);
  }
}
