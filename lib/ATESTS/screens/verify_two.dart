import 'dart:typed_data';
import 'package:aft/ATESTS/screens/verify_complete.dart';
import 'package:flutter/material.dart';
import '../camera/camera_screen.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import 'verify_three.dart';

class VerifyTwo extends StatefulWidget {
  var durationInDay;

  VerifyTwo({Key? key, this.durationInDay}) : super(key: key);

  @override
  State<VerifyTwo> createState() => _VerifyTwoState();
}

class _VerifyTwoState extends State<VerifyTwo> {
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
                        'Step 1/2',
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
                      color: darkBlue,
                      border:
                          Border(bottom: BorderSide(color: darkBlue, width: 0)),
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
                          child: SizedBox(child: Image.asset('assets/id4.jpg')),
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
                          color: darkBlue,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Text(
                                        'What are the few requirements needed to successfully complete the account verification process?',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0,
                                        ),
                                      ),
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
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "• You must have a valid identification card with a photo. Example: Driver's License, Passport, Government Issued ID, etc.",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.5,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                        Container(height: 8),
                                        const Text(
                                          '• You must be over 18 years of age.',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.5,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                        Container(height: 8),
                                        const Text(
                                          "• You do not already have another verified account on Fairtalk.",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.5,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                        // Container(height: 8),
                                        // const Text(
                                        //   "• And that's all!",
                                        //   textAlign: TextAlign.start,
                                        //   style: TextStyle(
                                        //     color: Colors.white,
                                        //     fontSize: 14.5,
                                        //     letterSpacing: 0,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Column(
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
                                            cameraFileType:
                                                CameraFileType.image,
                                            add: "one",
                                          );
                                          if (file != null) {
                                            emailAttachmentPhotos.clear();
                                            emailAttachmentPhotos.add(file);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VerifyThree(
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
                                            const Text(
                                                'Take picture of ID card',
                                                style: TextStyle(
                                                    fontSize: 16.5,
                                                    color: Color.fromARGB(
                                                        255, 25, 61, 94),
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0)),
                                            Container(width: 6),
                                            const Icon(
                                              Icons.keyboard_arrow_right,
                                              color: Color.fromARGB(
                                                  255, 25, 61, 94),
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                        width: double.infinity,
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
