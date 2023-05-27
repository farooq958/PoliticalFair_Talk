import 'dart:typed_data';
import 'package:aft/ATESTS/screens/verify_complete.dart';
import 'package:flutter/material.dart';
import '../camera/camera_screen.dart';
import '../utils/utils.dart';

class VerifyThree extends StatefulWidget {
  var durationInDay;
  VerifyThree({Key? key, this.durationInDay}) : super(key: key);

  @override
  State<VerifyThree> createState() => _VerifyThreeState();
}

class _VerifyThreeState extends State<VerifyThree> {
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
                        'Step 2/2',
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
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(75),
                              child: Image.asset(
                                'assets/selfie2.jpg',
                              )),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 25, 61, 94),
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 2, color: Colors.white),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Now we need to verify that the person on the ID card is you.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
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
                                    "For this step, you'll need to take a picture of yourself holding your ID card. Please make sure that your ID card isn't blocking any parts of your face.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
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
                                          () async {
                                        Uint8List? file = await openCamera(
                                          context: context,
                                          cameraFileType: CameraFileType.image,
                                          add: "two",
                                        );
                                        if (file != null) {
                                          if (emailAttachmentPhotos.length ==
                                              2) {
                                            emailAttachmentPhotos.removeAt(1);
                                          }
                                          emailAttachmentPhotos.insert(1, file);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VerifyComplete(
                                                        durationInDay: widget
                                                            .durationInDay)),
                                          );
                                        }
                                      });
                                    },
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: const [
                                              Text('Take picture of yourself',
                                                  style: TextStyle(
                                                      fontSize: 16.5,
                                                      color: Color.fromARGB(
                                                          255, 25, 61, 94),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.3)),
                                              Text('holding ID card',
                                                  style: TextStyle(
                                                      fontSize: 16.5,
                                                      color: Color.fromARGB(
                                                          255, 25, 61, 94),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.3)),
                                            ],
                                          ),
                                          Container(width: 8),
                                          const Icon(
                                            Icons.keyboard_arrow_right,
                                            size: 20,
                                            color:
                                                Color.fromARGB(255, 25, 61, 94),
                                          ),
                                        ],
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
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
