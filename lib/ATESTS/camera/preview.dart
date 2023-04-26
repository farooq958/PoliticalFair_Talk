import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import 'camera_loader.dart';
import 'camera_screen.dart';
import 'video_preview.dart';

class PreviewPictureScreen extends StatefulWidget {
  final String filePath;
  final bool? previewOnly;
  final CameraFileType cameraFileType;
  // ignore: prefer_typing_uninitialized_variables
  final add;

  const PreviewPictureScreen(
      {Key? key,
      required this.filePath,
      this.previewOnly,
      required this.cameraFileType,
      required this.add})
      : super(key: key);

  @override
  State<PreviewPictureScreen> createState() => _PreviewPictureScreenState();
}

class _PreviewPictureScreenState extends State<PreviewPictureScreen> {
  bool _captureImage = true;

  @override
  void initState() {
    _captureImage = widget.cameraFileType == CameraFileType.image;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              const CameraLoader(),
              Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: [
                    _captureImage
                        ? Container(
                            color: Colors.black,
                            width: getScreenSize(context: context).width,
                            height: getScreenSize(context: context).height,
                            child: Image.file(
                              File(widget.filePath),
                            ),
                          )
                        : VideoPreview(filePath: widget.filePath),
                    Positioned(
                      bottom: 20,
                      left: -1,
                      right: -1,
                      child: Offstage(
                        offstage: widget.previewOnly ?? false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  splashColor: Colors.red.withOpacity(0.5),
                                  // borderColor: Colors.red,
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 2, color: Colors.red),
                                      color: Colors.transparent,
                                    ),
                                    child: const Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                      size: 36,
                                    ),
                                  ),
                                  onTap: () {
                                    Future.delayed(
                                        const Duration(milliseconds: 150), () {
                                      Navigator.pop(context, false);
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 60),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  splashColor: Colors.green.withOpacity(0.5),
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 2, color: Colors.green),
                                      color: Colors.transparent,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 36,
                                    ),
                                  ),
                                  onTap: () {
                                    Future.delayed(
                                        const Duration(milliseconds: 150), () {
                                      Navigator.pop(context, true);
                                    });
                                  },
                                ),
                              ),
                            ],
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
    );
  }
}
