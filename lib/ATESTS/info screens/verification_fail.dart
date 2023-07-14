import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../methods/auth_methods.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../utils/global_variables.dart';

class VerificationFail extends StatefulWidget {
  final String reason;
  const VerificationFail({Key? key, required this.reason}) : super(key: key);

  @override
  State<VerificationFail> createState() => _VerificationFailState();
}

class _VerificationFailState extends State<VerificationFail> {
  var snap;

  void verificationFailed() async {
    try {
      String res = await AuthMethods().verificationFailed();
      if (res == "success") {
        Navigator.pop(context);
      } else {
        // showSnackBar(res, context);
      }
    } catch (e) {
      // showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
              child: Center(
                child: SingleChildScrollView(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 245, 245, 245),
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: const [
                            Text(
                                'Unfortunately, your account has failed to pass the verification process.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0)),
                            SizedBox(height: 10),
                            Icon(Icons.cancel, size: 60, color: Colors.red),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 245, 245, 245),
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Here's the reason why:",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        width: 1, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.reason == "unclearPictures"
                                  ? "One or both pictures taken were unclear. Please make sure that the quality of the pictures taken are clear and all of the information on your ID card can easily be read. You'll always have the opportunity to try the verification process again."
                                  : widget.reason == "alreadyHaveAnotherAccount"
                                      ? "Our dataset showed us that you've already created and verified another account on FairTalk. It wouldn't be fair for other users if you had access to multiple verified accounts and had the ability to vote multiple times. This is why this rule is stricly reinforced."
                                      : widget.reason == "twoPicturesDontMatch"
                                          ? "With the help of our facial recognition technology, the person on the ID card did not match the person holding the ID card. These results are not always 100% accurate and you'll always have the opportunity to try the verification process again."
                                          : widget.reason == "fakeId"
                                              ? "With the help of our technology, your identification card was classified as being inauthentic. These results are not always 100% accurate and you'll always have the opportunity to try the verification process again."
                                              : widget.reason == "under18"
                                                  ? "We're currently only accepting individuals who are over the age of 18. You'll always have the opportunity to get your account verified once you're over the age of 18!"
                                                  : "No reason found. This might've been an error.",

                              // "We've sent you an email detailing the reason why. We advise you to read it carefully. You'll always have the opportunity to try the verification process again. ",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        width: 1, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "If you have any questions, feel free to contact us by email: $email",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 10),
                        child: Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.blue,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            splashColor: Colors.black.withOpacity(0.3),
                            onTap: () {
                              Future.delayed(const Duration(milliseconds: 150),
                                  () {
                                verificationFailed();
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 4, top: 12, bottom: 12, right: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(width: 8),
                                    const Text(
                                      'Return to FairTalk',
                                      style: TextStyle(
                                          fontSize: 18,
                                          letterSpacing: 0.8,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
