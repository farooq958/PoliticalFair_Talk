import 'package:flutter/material.dart';
import '../info screens/how_it_works.dart';
import 'verify_two.dart';

class VerifyOne extends StatefulWidget {
  const VerifyOne({Key? key}) : super(key: key);

  @override
  State<VerifyOne> createState() => _VerifyOneState();
}

class _VerifyOneState extends State<VerifyOne> {
  @override
  Widget build(BuildContext context) {
    var safePadding = MediaQuery.of(context).padding.top;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 56,
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: [
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Material(
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              splashColor: Colors.grey.withOpacity(0.5),
                              child: const Icon(Icons.keyboard_arrow_left,
                                  color: Color.fromARGB(255, 25, 61, 94)),
                              onTap: () {
                                Future.delayed(
                                  const Duration(milliseconds: 50),
                                  () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'Account Verification',
                        style: TextStyle(
                            color: Color.fromARGB(255, 25, 61, 94),
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 36, 64, 101),
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromARGB(255, 36, 64, 101),
                              width: 0)),
                    ),
                    width: MediaQuery.of(context).size.width * 0.5,
                    height:
                        MediaQuery.of(context).size.height - 56 - safePadding >=
                                600
                            ? (MediaQuery.of(context).size.height -
                                    56 -
                                    safePadding) *
                                0.35
                            : 182,
                  ),
                  Positioned(
                    child: Container(
                      height: MediaQuery.of(context).size.height -
                                  56 -
                                  safePadding >=
                              600
                          ? (MediaQuery.of(context).size.height -
                                  56 -
                                  safePadding) *
                              0.35
                          : 182,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(75),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height -
                                    56 -
                                    safePadding >=
                                600
                            ? (MediaQuery.of(context).size.height -
                                    56 -
                                    safePadding) *
                                0.35
                            : 182,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: SizedBox(
                            // height: 105,
                            child: Image.asset('assets/stepOneVerif.png'),
                          ),
                        )),
                  ),
                ],
              ),
              Stack(
                children: [
                  Positioned(
                    child: Center(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 36, 64, 101),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(75),
                          ),
                        ),
                        padding: const EdgeInsets.only(top: 20, bottom: 0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height -
                                    56 -
                                    safePadding >=
                                600
                            ? (MediaQuery.of(context).size.height -
                                    56 -
                                    safePadding) *
                                0.65
                            : 362,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              padding: const EdgeInsets.only(
                                  right: 12, left: 12, top: 10, bottom: 6),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 25, 61, 94),
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 2, color: Colors.white),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Why does Fairtalk have an account verification system?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3),
                                  ),
                                  Container(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              width: 0, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(height: 8),
                                  const Text(
                                    "Because it helps eliminate all forms of voting manipulation. Without a verification system like this, it would be very easy for anyone to simply create multiple accounts and unfairly manipulate the platform's voting metrics.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        letterSpacing: 0.3),
                                  ),
                                  // Container(height: 8),
                                  // const Text(
                                  //   "Without a verification system, it would be very easy for anyone to simply create multiple accounts and unfairly manipulate the platform's voting metrics.",
                                  //   textAlign: TextAlign.center,
                                  //   style: TextStyle(
                                  //       color: Colors.white,
                                  //       fontSize: 14,
                                  //       letterSpacing: 0.3),
                                  // ),
                                  Container(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(5),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          splashColor:
                                              Colors.blue.withOpacity(0.5),
                                          onTap: () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 150), () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HowItWorks()),
                                              );
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.info_outline,
                                                    color: Colors.blue,
                                                    size: 14),
                                                Container(width: 4),
                                                const Text(
                                                    'Learn more about Fairtalk',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 14)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(height: 0),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Material(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    splashColor: Colors.grey.withOpacity(0.5),
                                    onTap: () {
                                      Future.delayed(
                                          const Duration(milliseconds: 150),
                                          () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const VerifyTwo()),
                                        );
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                              'Start Account Verification',
                                              style: TextStyle(
                                                  fontSize: 16.5,
                                                  color: Color.fromARGB(
                                                      255, 25, 61, 94),
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.3)),
                                          Container(width: 6),
                                          const Icon(
                                            Icons.keyboard_arrow_right,
                                            size: 20,
                                            color:
                                                Color.fromARGB(255, 25, 61, 94),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      decoration: const ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25),
                                          ),
                                        ),
                                        color: Colors.transparent,
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
