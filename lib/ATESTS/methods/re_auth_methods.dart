import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../responsive/my_flutter_app_icons.dart';
import '../utils/utils.dart';

import 'auth_methods.dart';

class ReAuthenticationDialog extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final username;

  const ReAuthenticationDialog({Key? key, required this.username})
      : super(key: key);

  @override
  State<ReAuthenticationDialog> createState() => _ReAuthenticationDialogState();
}

class _ReAuthenticationDialogState extends State<ReAuthenticationDialog> {
  bool _isLoading = false;
  bool _authenticationFailed = false;
  bool _passwordVisible = false;
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 300,
            // height: _authenticationFailed ? 259 : 235,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: Colors.white),
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      widget.username
                          ? 'To change your username, you must first confirm your password.'
                          : 'To change your email address, you must first confirm your password.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 83, 83, 83))),
                  Padding(
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
                                      size: 16,
                                      color: Color.fromARGB(255, 220, 105, 96)),
                                  Container(width: 4),
                                  const Text('Wrong password.',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 220, 105, 96),
                                        letterSpacing: 0.2,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        PhysicalModel(
                          elevation: 2,
                          color: const Color.fromARGB(255, 237, 237, 237),
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
                        color: const Color.fromARGB(255, 36, 64, 101),
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
                                if (!mounted) return;
                                showSnackBar(
                                    widget.username
                                        ? 'Username successfully changed.'
                                        : 'Email successfully changed.',
                                    context);
                                Navigator.pop(context, true);
                              } else {
                                setState(() {
                                  _authenticationFailed = true;
                                  _isLoading = false;
                                });
                                // showSnackBar('Wrong password.', context);
                              }
                            });
                          },
                          child: Container(
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
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'CONFIRM',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          letterSpacing: 0.2,
                                          fontWeight: FontWeight.bold,
                                        ),
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
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: PhysicalModel(
                color: Color.fromARGB(255, 36, 64, 101),
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  radius: 43.5,
                  backgroundColor: Color.fromARGB(255, 36, 64, 101),
                  child: Icon(
                    MyFlutterApp.exclamation,
                    size: 45,
                    color: Colors.white,
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
