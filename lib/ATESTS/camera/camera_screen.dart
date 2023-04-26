import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import 'camera_loader.dart';
import 'preview.dart';

enum CameraFileType { image, video }

class CameraScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final add;
  const CameraScreen(
      {Key? key,
      required this.camera,
      required this.secondaryCamera,
      required this.cameraFileType,
      required this.add})
      : super(key: key);

  final CameraDescription camera;
  final CameraDescription? secondaryCamera;
  final CameraFileType cameraFileType;

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  // Controllers
  late CameraDescription selectedCamera;
  final StreamController<bool> _isCapturingStreamController =
      StreamController<bool>.broadcast();
  late CameraController controller;
  late Future<void> _initializeControllerFuture;
  bool _captureImage = true;

  @override
  void initState() {
    super.initState();
    selectedCamera =
        widget.add == "two" ? widget.secondaryCamera! : widget.camera;
    _captureImage = widget.cameraFileType == CameraFileType.image;
    _setDefaults();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
  }

  @override
  void dispose() {
    // _dispose();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: false,
          body: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                        color: Colors.black,
                        width: getScreenSize(context: context).width,
                        height: getScreenSize(context: context).height),
                    CameraPreview(
                      controller,
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 6, bottom: 6),
                            color: Colors.black.withOpacity(0.1),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        splashColor:
                                            Colors.grey.withOpacity(0.75),
                                        child: Icon(Icons.keyboard_arrow_left,
                                            size: 22,
                                            color:
                                                Colors.white.withOpacity(0.75)),
                                        onTap: () {
                                          Future.delayed(
                                              const Duration(milliseconds: 50),
                                              () {
                                            Navigator.of(context).pop();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  _captureImage == true &&
                                              widget.add == "true" ||
                                          _captureImage == true &&
                                              widget.add == "1"
                                      ? 'Take a picture'
                                      : _captureImage == true &&
                                              widget.add == "one"
                                          ? 'Take picture of ID card (front)'
                                          : _captureImage == true &&
                                                  widget.add == "two"
                                              ? 'Take picture of yourself holding ID card'
                                              : "Record a video",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.75),
                                      fontSize: widget.add == "two" ? 14 : 18,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3),
                                ),
                              ],
                            ),
                          ),
                          Positioned.fill(
                            child: StreamBuilder<bool>(
                              initialData: false,
                              stream: _isCapturingStreamController.stream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<bool> snapshot) {
                                return Visibility(
                                  visible: controller.value.isRecordingVideo,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      // color: Colors.white.withOpacity(0),
                                      border: Border.all(
                                        color: Colors.redAccent,
                                        width: 3.0,
                                      ),
                                    ),
                                    child: Container(),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            bottom: widget.add == "true" ? 20 : 10,
                            left: -1,
                            right: -1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(child: Container()),
                                Align(
                                  alignment: Alignment.center,
                                  child: StreamBuilder<bool>(
                                    initialData: false,
                                    stream: _isCapturingStreamController.stream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<bool> snapshot) {
                                      bool _isCapturing =
                                          snapshot.data ?? false;
                                      return _captureImage
                                          ? Center(
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  splashColor: Colors.white
                                                      .withOpacity(0.5),
                                                  onTap: _isCapturing
                                                      ? () {}
                                                      : () async {
                                                          _onImageCapture(
                                                              context: context);
                                                        },
                                                  child: Center(
                                                    child: Container(
                                                      height: 60,
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 2,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.75)),
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                      child: Icon(
                                                        Icons
                                                            .camera_alt_outlined,
                                                        color: Colors.white
                                                            .withOpacity(0.75),
                                                        size: 36,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                splashColor: Colors.white
                                                    .withOpacity(0.5),
                                                onTap: _isCapturing
                                                    ? () {}
                                                    : () async {
                                                        if (controller.value
                                                            .isRecordingVideo) {
                                                          stopVideoRecording();
                                                        } else {
                                                          startVideoRecording();
                                                        }
                                                      },
                                                child: Center(
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.75)),
                                                      color: Colors.transparent,
                                                    ),
                                                    child: Icon(
                                                      controller.value
                                                              .isRecordingVideo
                                                          ? Icons.stop
                                                          : Icons
                                                              .videocam_outlined,
                                                      color: Colors.white
                                                          .withOpacity(0.75),
                                                      size: 36,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                    },
                                  ),
                                ),
                                widget.add == "true"
                                    ? Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Visibility(
                                              visible: widget.secondaryCamera !=
                                                  null,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  splashColor: Colors.white
                                                      .withOpacity(0.5),
                                                  onTap: () {
                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 150),
                                                        () {
                                                      selectedCamera =
                                                          selectedCamera ==
                                                                  widget.camera
                                                              ? widget
                                                                  .secondaryCamera!
                                                              : widget.camera;
                                                      _setDefaults();
                                                      setState(() {});
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 52,
                                                    width: 52,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.75)),
                                                      color: Colors.transparent,
                                                    ),
                                                    child: Icon(
                                                      Icons
                                                          .cameraswitch_outlined,
                                                      color: Colors.white
                                                          .withOpacity(0.75),
                                                      size: 24,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Expanded(child: Container())
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const CameraLoader();
              }
            },
          ),
        ),
      ),
    );
  }

  // Methods

  // Set defaults
  void _setDefaults() {
    controller = CameraController(
      selectedCamera,
      ResolutionPreset.max,
    );

    _initializeControllerFuture = controller.initialize();
    _isCapturingStreamController.sink.add(false);
  }

  // Disposes controllers

  // ignore: unused_element
  void _dispose() {
    controller.dispose();
    _isCapturingStreamController.close();
  }

  // On capture
  void _onImageCapture({required BuildContext context}) async {
    _isCapturingStreamController.sink.add(true);
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      controller.setFlashMode(FlashMode.off);

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await controller.takePicture();

      _isCapturingStreamController.sink.add(false);

      // If the picture was taken, display it on a new screen.
      bool? selected = await Navigator.of(
        context,
      ).push<bool>(
        CupertinoPageRoute(builder: (BuildContext context) {
          return PreviewPictureScreen(
            filePath: image.path,
            cameraFileType: CameraFileType.image,
            add: widget.add,
          );
        }),
      );

      // If photo is selected return it
      if (selected ?? false) {
        Navigator.pop(context, [File(image.path)]);
      }
    } catch (e) {
      // If an error occurs, log the error to the console.
      // showAlert(
      //   context: context,
      //   titleText: Localization.of(context).trans(LocalizationValues.error),
      //   message: '$e',
      //   actionCallbacks: {
      //     Localization.of(context).trans(LocalizationValues.ok): () {}
      //   },
      // );
      _isCapturingStreamController.sink.add(false);
    }
  }

  void startVideoRecording() async {
    _isCapturingStreamController.sink.add(true);
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to start recording a video
      // where it was saved.
      await controller.startVideoRecording();
      _isCapturingStreamController.sink.add(false);
    } catch (e) {
      // If an error occurs, log the error to the console.
      // showAlert(
      //   context: context,
      //   titleText: Localization.of(context).trans(LocalizationValues.error),
      //   message: '$e',
      //   actionCallbacks: {
      //     Localization.of(context).trans(LocalizationValues.ok): () {}
      //   },
      // );
      _isCapturingStreamController.sink.add(false);
    }
  }

  void stopVideoRecording() async {
    _isCapturingStreamController.sink.add(true);
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to start recording a video
      // where it was saved.
      final video = await controller.stopVideoRecording();
      _isCapturingStreamController.sink.add(false);

      // If the picture was taken, display it on a new screen.
      bool? selected = await Navigator.of(
        context,
      ).push<bool>(CupertinoPageRoute(builder: (BuildContext context) {
        return PreviewPictureScreen(
          filePath: video.path,
          cameraFileType: CameraFileType.video,
          add: widget.add,
        );
      }));

      // If photo is  selected return it
      if (selected ?? false) {
        Navigator.pop(context, [File(video.path)]);
      }
    } catch (e) {
      // If an error occurs, log the error to the console.
      // showAlert(
      //   context: context,
      //   titleText: Localization.of(context).trans(LocalizationValues.error),
      //   message: '$e',
      //   actionCallbacks: {
      //     Localization.of(context).trans(LocalizationValues.ok): () {}
      //   },
      // );
      _isCapturingStreamController.sink.add(false);
    }
  }
}

class CircularOutlinedIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;
  final String? label;
  final Color? borderColor;

  const CircularOutlinedIconButton({
    Key? key,
    required this.onTap,
    required this.icon,
    this.label,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          shape: CircleBorder(
            side: BorderSide(
              color: borderColor ?? Colors.white,
              width: 2.0,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: icon,
            ),
          ),
        ),
        Visibility(
          visible: label != null,
          child: Text(label ?? ''),
        ),
      ],
    );
  }
}
