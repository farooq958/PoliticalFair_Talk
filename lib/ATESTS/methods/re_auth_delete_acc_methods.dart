import 'package:aft/ATESTS/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart' as f_auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';

import '../utils/global_variables.dart';

import 'auth_methods.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({Key? key}) : super(key: key);

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  bool _isLoading = false;
  bool _authenticationFailed = false;
  bool _passwordVisible = false;
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final f_auth.FirebaseAuth _auth = f_auth.FirebaseAuth.instance;
    f_auth.User? firebaseUser = _auth.currentUser;
    print("providerdata");
    String? providerAuth=firebaseUser?.providerData[0].providerId;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color.fromARGB(255, 231, 104, 104)),
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'DELETE ACCOUNT',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: whiteDialog),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                      'To delete your account, you must first confirm your password. Warning: This action is permanent and cannot be undone.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: whiteDialog)),
                  // SizedBox(height: 4),
                  // Text(
                  //     'Warning: This action is permanent and cannot be undone.',
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //         fontSize: 13,
                  //         letterSpacing: 0.2,
                  //         fontWeight: FontWeight.w500,
                  //         color: whiteDialog)),
                 providerAuth=="google.com"?const SizedBox(height: 10,) : Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 15,
                      left: 0,
                      right: 0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: _authenticationFailed,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: SizedBox(
                              height: 20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error,
                                      size: 16, color: whiteDialog),
                                  Container(width: 4),
                                  const Text('Wrong password.',
                                      style: TextStyle(
                                        color: whiteDialog,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.2,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        PhysicalModel(
                          elevation: 2,
                          color: whiteDialog,
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                              // hintText: 'Enter your password',
                              // textInputType: TextInputType.text,
                              // textEditingController: passwordController,
                              // isPass: true,
                              controller: passwordController,
                              obscureText: !_passwordVisible,
                              onChanged: (val) {
                                setState(() {
                                  _authenticationFailed = false;
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter your password',
                                contentPadding:
                                    const EdgeInsets.only(left: 12, top: 16),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  child: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(25),
                        color: whiteDialog,
                        elevation: 3,
                        child: InkWell(
                          splashColor: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(25),
                          onTap: () {
                            final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false);
                            Future.delayed(const Duration(milliseconds: 150),
                                () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                _isLoading = true;
                              });

                              final User? user = Provider.of<UserProvider>(
                                      context,
                                      listen: false)
                                  .getUser;
if(providerAuth=='google.com'){
  //User? _user;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleUser =
  await googleSignIn.signIn();

  if (googleUser == null) return null;
  // _user = googleUser;

  final googleAuth = await googleUser.authentication;

  final credential = f_auth.GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Re-authenticate the user with Google credentials
  final f_auth.UserCredential? userCredential = await firebaseUser?.reauthenticateWithCredential(credential);
  if(userCredential?.user != null)
    {
      setState(() {
        _authenticationFailed = false;
        _isLoading = false;
      });
      Navigator.pop(context, true);

    }
  else
    {

      setState(() {
        _authenticationFailed = true;
        _isLoading = false;
      });
      showSnackBar('Something Went Wrong Could Not Delete try again later',context);
      Navigator.pop(context, true);
      return null;

    }
}
else
  {
    String res = await AuthMethods().loginUser(
      email: user?.aEmail ?? '',
      password: passwordController.text,
    );
    await userProvider.refreshTokenAndTopic();
    if (res == "success") {
      setState(() {
        _authenticationFailed = false;
        _isLoading = false;
      });

      Navigator.pop(context, true);
    } else {
      setState(() {
        _authenticationFailed = true;
        _isLoading = false;
      });
    }
  }


                            });
                          },
                          child: Container(
                            // width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.transparent,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: _isLoading
                                ? const Center(
                                    child: SizedBox(
                                      height: 19,
                                      width: 19,
                                      child: CircularProgressIndicator(
                                        color:
                                            Color.fromARGB(255, 231, 104, 104),
                                      ),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('CONFIRM',
                                          style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 0.2,
                                            color: Color.fromARGB(
                                                255, 234, 79, 79),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Color.fromARGB(255, 231, 104, 104),
              child: PhysicalModel(
                color: whiteDialog,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: whiteDialog,
                  child: Icon(
                    Icons.delete,
                    size: 65,
                    color: Color.fromARGB(255, 231, 104, 104),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
