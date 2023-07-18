import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as ytplayer;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../camera/camera_screen.dart';
import '../models/user.dart';
import '../provider/automate_provider.dart';
import '../provider/create_provider.dart';
import '../provider/user_provider.dart';
import '../responsive/my_flutter_app_icons.dart';
import '../utils/utils.dart';
import 'full_image_add.dart';

class Automate extends StatefulWidget {
  final User user;

  const Automate({Key? key, required this.user}) : super(key: key);

  @override
  State<Automate> createState() => _AutomateState();
}

class _AutomateState extends State<Automate> {
  bool messages = true;
  bool polls = false;
  bool global = true;
  bool us = false;
  bool ca = false;
  bool fresh = false;
  bool recycle = false;
  bool one = true;
  bool two = false;
  bool three = false;
  bool four = false;
  bool five = false;
  bool six = false;
  bool seven = false;
  bool is1Fresh = false;
  bool is1Recycle = false;

  final TextEditingController initialScoreController = TextEditingController();

  //

  YoutubePlayerController? controller;
  final TextEditingController _pollController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();
  late TextfieldTagsController keywordMessageController;

  final List<TextEditingController>? _cont = [];
  final TextEditingController _optionOne = TextEditingController();
  final TextEditingController _optionTwo = TextEditingController();
  final TextEditingController _optionThree = TextEditingController();
  final TextEditingController _optionFour = TextEditingController();
  final TextEditingController _optionFive = TextEditingController();
  final TextEditingController _optionSix = TextEditingController();
  final TextEditingController _optionSeven = TextEditingController();
  final TextEditingController _optionEight = TextEditingController();
  final TextEditingController _optionNine = TextEditingController();
  final TextEditingController _optionTen = TextEditingController();

  // final AuthMethods _authMethods = AuthMethods();
  int visibleOptions = 2;
  bool disableButton = false;
  static const List<String> _pickLanguage = <String>[];

  final int _optionTextfieldMaxLength = 25;
  final int _pollQuestionTextfieldMaxLength = 300;
  final int _messageTitleTextfieldMaxLength = 999;

  bool _isVideoFile = false;
  bool done = false;

  // File? _videoFile;
  bool _isLoading = false;
  var snap;
  Uint8List? _file;
  var selected = 0;
  String? videoUrl = '';
  Color buttonColor = Colors.blue;
  int i = 0;
  String proxyurl = 'abc';
  bool emptyTittle = false;
  bool emptyOptionOne = false;
  bool emptyOptionTwo = false;
  bool emptyPollQuestion = false;
  bool showTrendingMessage = false;
  bool showTrendingPoll = false;
  bool visiblityThree = false;
  bool visiblityFour = false;
  bool visiblityFive = false;
  bool visiblitySix = false;
  bool visiblitySeven = false;
  bool visiblityEight = false;
  bool visiblityNine = false;
  bool visiblityTen = false;
  String country = '';
  String oneValue = '';
  dynamic test;
  var durationInDay;
  bool _logoutLoading = false;

  int getCounterPost = 0;
  int getCounterPoll = 0;

  var add = "true";
  var countryImage = '';
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<String> myTagsLowerCase = [];
  List<String> myTagsPollLowerCase = [];

  // DateTime ntpTime = DateTime.now();
  List<String> myTags = [];
  List<String> myTagsPoll = [];

  String _hoursDate = '';
  int _hoursTimer = 0;

  String _minutesDate = '';
  int _minutesTimer = 0;

  @override
  void initState() {
    super.initState();

    Provider.of<AutomateProvider>(context, listen: false)
        .addAdminUserToDb(widget.user);
    Provider.of<AutomateProvider>(context, listen: false).setValues(
        global: global,
        messages: messages,
        ca: ca,
        us: us,
        one: one,
        two: two,
        three: three,
        four: four,
        five: five,
        six: six,
        seven: seven);

    keywordMessageController = TextfieldTagsController();

    controller = YoutubePlayerController(
      initialVideoId: '$videoUrl',
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        privacyEnhanced: true,
        useHybridComposition: true,
      ),
    );
    controller!.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      log('Entered Fullscreen');
    };
    controller!.onExitFullscreen = () {
      log('Exited Fullscreen');
    };
    // setState(() {});
  }

  Widget _icon(int index, {required IconData icon}) {
    final automateProvider =
        Provider.of<AutomateProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Material(
          shape: const CircleBorder(),
          color: Colors.transparent,
          child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: Colors.grey.withOpacity(0.3),
              child: Icon(
                icon,
                color: selected == index ? Colors.blue : Colors.grey,
              ),
              onTap: () {
                setState(
                  () {
                    selected = index;
                    index == 1 ? _selectImage(context) : null;
                    // index == 2 ? _selectVideo(context) : null;
                    index == 3 ? _selectYoutube(context) : null;

                    index == 0 || index == 2 || index == 3
                        ? clearImage()
                        : null;
                    // index == 0 || index == 1 || index == 2
                    //     ? clearVideoUrl()
                    //     : null;
                  },
                );
              }),
        ),
      ),
    );
  }

  // Future<File> _getVideoThumbnail({required File file}) async {
  //   Directory tempDir = await getTemporaryDirectory();
  //   String tempPath = tempDir.path;
  //   var filePath = '$tempPath/${DateTime.now().millisecondsSinceEpoch}.png';

  //   final thumbnail = await VideoThumbnail.thumbnailData(
  //     video: file.path,
  //     imageFormat: ImageFormat.PNG,
  //     quality: 100,
  //   );
  //   return File(filePath).writeAsBytes(thumbnail!);
  // }

  void clearVideoUrl() {
    setState(() {
      _videoUrlController.clear();
    });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  _selectYoutube(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        // insetPadding: EdgeInsets.zero,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              // width: 295,
              // height: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              padding: const EdgeInsets.fromLTRB(10, 45, 10, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SimpleDialogOption(
                      padding: const EdgeInsets.only(
                          top: 20, left: 5, right: 5, bottom: 2),
                      child: const Text("Upload YouTube Video",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.transparent,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(offset: Offset(0, -5), color: Colors.black)
                            ],
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                          )),
                      onPressed: () {},
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, left: 8, top: 12, bottom: 6),
                      child: PhysicalModel(
                        color: const Color.fromARGB(255, 245, 245, 245),
                        elevation: 2,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        child: TextField(
                          onChanged: (t) {
                            videoUrl = ytplayer.YoutubePlayer.convertUrlToId(
                                _videoUrlController.text);

                            setState(() {
                              videoUrl;
                            });

                            if (videoUrl != null) {
                              setState(() {
                                controller = YoutubePlayerController(
                                  initialVideoId: '$videoUrl',
                                  params: const YoutubePlayerParams(
                                    showControls: true,
                                    showFullscreenButton: true,
                                    desktopMode: false,
                                    privacyEnhanced: true,
                                    useHybridComposition: true,
                                  ),
                                );
                              });
                            }
                          },
                          onSubmitted: (t) {
                            if (_videoUrlController.text.isEmpty) {
                              setState(() {
                                selected = 0;
                              });
                            } else {}
                          },
                          controller: _videoUrlController,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            hintText: "Paste YouTube URL",
                            prefixIcon: Icon(MyFlutterApp.link,
                                size: 15, color: Colors.grey),
                            prefixIconColor: Color.fromARGB(255, 136, 136, 136),
                            contentPadding: EdgeInsets.only(left: 16, top: 15),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 60,
                      child: Container(
                        color: Colors.white,
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.format_clear,
                                    color: Color.fromARGB(255, 139, 139, 139),
                                  ),
                                  Container(width: 8),
                                  const Text('Clear URL',
                                      style: TextStyle(
                                          letterSpacing: 0.2, fontSize: 15)),
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                clearVideoUrl();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 60,
                      child: Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            _videoUrlController.text.isEmpty
                                ? setState(() {
                                    selected = 0;
                                    clearVideoUrl();
                                  })
                                : null;
                            Future.delayed(const Duration(milliseconds: 150),
                                () {
                              Navigator.of(context).pop();
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Color.fromARGB(255, 139, 139, 139),
                                ),
                                Container(width: 8),
                                const Text('Done',
                                    style: TextStyle(
                                        letterSpacing: 0.2, fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            const Positioned(
              top: -50,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 139, 139, 139),
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      MyFlutterApp.youtube,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ).then((value) => _videoUrlController.text.isEmpty || videoUrl == null
        ? setState(() {
            selected = 0;
          })
        : null);
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        // insetPadding: EdgeInsets.zero,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              padding: const EdgeInsets.fromLTRB(10, 45, 10, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SimpleDialogOption(
                      padding: const EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 5),
                      child: const Text("Upload Image",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.transparent,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(offset: Offset(0, -5), color: Colors.black)
                            ],
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                          )),
                      onPressed: () {},
                    ),
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 60,
                      child: Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () async {
                            Uint8List? file = await openCamera(
                              context: context,
                              cameraFileType: CameraFileType.image,
                              add: add,
                            );
                            // Uint8List file = await pickImage(
                            //   ImageSource.camera,
                            // );
                            // setState(() {
                            //   _file = file;
                            // });
                            // Uint8List? file = await openCamera(context: context);
                            // Uint8List file = await pickImage(
                            //   ImageSource.camera,
                            // );

                            if (file != null) {
                              setState(() {
                                _file = file;
                                _isVideoFile = false;
                              });
                            }
                            Future.delayed(const Duration(milliseconds: 150),
                                () {
                              Navigator.of(context).pop();
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.camera_alt,
                                  color: Color.fromARGB(255, 139, 139, 139),
                                ),
                                Container(width: 8),
                                const Text('Open camera',
                                    style: TextStyle(
                                        letterSpacing: 0.2, fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 60,
                      child: Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () async {
                            Uint8List file = await pickImage(
                              ImageSource.gallery,
                            );
                            setState(() {
                              _file = file;
                              _isVideoFile = false;
                            });
                            Future.delayed(const Duration(milliseconds: 150),
                                () {
                              Navigator.of(context).pop();
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.collections,
                                  color: Color.fromARGB(255, 139, 139, 139),
                                ),
                                Container(width: 8),
                                const Text('Choose from gallery',
                                    style: TextStyle(
                                        letterSpacing: 0.2, fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 60,
                      child: Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            _file == null
                                ? setState(() {
                                    selected = 0;
                                  })
                                : null;

                            Future.delayed(const Duration(milliseconds: 150),
                                () {
                              Navigator.of(context).pop();
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.cancel,
                                  color: Color.fromARGB(255, 139, 139, 139),
                                ),
                                Container(width: 8),
                                const Text('Cancel',
                                    style: TextStyle(
                                        letterSpacing: 0.2, fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
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
                child: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 139, 139, 139),
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      Icons.collections,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ).then((value) => _file == null
        ? setState(() {
            selected = 0;
          })
        : null);
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    final automateProvider =
        Provider.of<AutomateProvider>(context, listen: false);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 245, 245, 245),
          appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 4,
              toolbarHeight: 56,
              backgroundColor: Colors.white,
              actions: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Material(
                            shape: const CircleBorder(),
                            color: Colors.transparent,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              splashColor: Colors.grey.withOpacity(0.5),
                              onTap: () {
                                Future.delayed(
                                  const Duration(milliseconds: 50),
                                  () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              child: const Icon(Icons.arrow_back,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text('Automate',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            global = !global;
                            us ? us = !us : null;
                            ca ? ca = !ca : null;
                            automateProvider.setValues(
                                global: global,
                                messages: messages,
                                ca: ca,
                                us: us,
                                one: one,
                                two: two,
                                three: three,
                                four: four,
                                five: five,
                                six: six,
                                seven: seven);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(
                                  color: global ? Colors.blue : Colors.white,
                                  width: global ? 2 : 0)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 26, vertical: 8),
                            child: Icon(
                              MyFlutterApp.globe_americas,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            us = !us;
                            global ? global = !global : null;
                            ca ? ca = !ca : null;
                          });
                          automateProvider.setValues(
                              global: global,
                              messages: messages,
                              ca: ca,
                              us: us,
                              one: one,
                              two: two,
                              three: three,
                              four: four,
                              five: five,
                              six: six,
                              seven: seven);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(
                                  color: us ? Colors.blue : Colors.white,
                                  width: us ? 2 : 0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: SizedBox(
                              width: 46,
                              // height: 16,
                              child: Image.asset(
                                'icons/flags/png/us.png',
                                package: 'country_icons',
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            ca = !ca;
                            global ? global = !global : null;
                            us ? us = !us : null;
                          });
                          automateProvider.setValues(
                              global: global,
                              messages: messages,
                              ca: ca,
                              us: us,
                              one: one,
                              two: two,
                              three: three,
                              four: four,
                              five: five,
                              six: six,
                              seven: seven);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(
                                  color: ca ? Colors.blue : Colors.white,
                                  width: ca ? 2 : 0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: SizedBox(
                              width: 46,
                              child: Image.asset(
                                'icons/flags/png/ca.png',
                                package: 'country_icons',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            messages = !messages;
                            polls = !polls;
                          });
                          automateProvider.setValues(
                              global: global,
                              messages: messages,
                              ca: ca,
                              us: us,
                              one: one,
                              two: two,
                              three: three,
                              four: four,
                              five: five,
                              six: six,
                              seven: seven);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(
                                  color: messages ? Colors.blue : Colors.white,
                                  width: messages ? 2 : 0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.message,
                                ),
                                SizedBox(width: 6),
                                Text('Messages'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            messages = !messages;
                            polls = !polls;
                          });
                          automateProvider.setValues(
                              global: global,
                              messages: messages,
                              ca: ca,
                              us: us,
                              one: one,
                              two: two,
                              three: three,
                              four: four,
                              five: five,
                              six: six,
                              seven: seven);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(
                                  color: polls ? Colors.blue : Colors.white,
                                  width: polls ? 2 : 0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Row(
                              children: const [
                                RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(
                                    Icons.poll,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text('Polls'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text('M'),
                          InkWell(
                            onTap: () {
                              setState(() {
                                one = !one;
                                two ? two = !two : null;
                                three ? three = !three : null;
                                four ? four = !four : null;
                                five ? five = !five : null;
                                six ? six = !six : null;
                                seven ? seven = !seven : null;
                              });
                              automateProvider.setValues(
                                  global: global,
                                  messages: messages,
                                  ca: ca,
                                  us: us,
                                  one: one,
                                  two: two,
                                  three: three,
                                  four: four,
                                  five: five,
                                  six: six,
                                  seven: seven);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: one ? Colors.blue : Colors.white,
                                      width: one ? 2 : 0)),
                              child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  child: Text('1')),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('T'),
                          InkWell(
                            onTap: () {
                              setState(() {
                                two = !two;
                                one ? one = !one : null;
                                three ? three = !three : null;
                                four ? four = !four : null;
                                five ? five = !five : null;
                                six ? six = !six : null;
                                seven ? seven = !seven : null;
                              });
                              automateProvider.setValues(
                                  global: global,
                                  messages: messages,
                                  ca: ca,
                                  us: us,
                                  one: one,
                                  two: two,
                                  three: three,
                                  four: four,
                                  five: five,
                                  six: six,
                                  seven: seven);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: two ? Colors.blue : Colors.white,
                                      width: two ? 2 : 0)),
                              child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  child: Text('2')),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('W'),
                          InkWell(
                            onTap: () {
                              setState(() {
                                three = !three;
                                two ? two = !two : null;
                                one ? one = !one : null;
                                four ? four = !four : null;
                                five ? five = !five : null;
                                six ? six = !six : null;
                                seven ? seven = !seven : null;
                              });
                              automateProvider.setValues(
                                  global: global,
                                  messages: messages,
                                  ca: ca,
                                  us: us,
                                  one: one,
                                  two: two,
                                  three: three,
                                  four: four,
                                  five: five,
                                  six: six,
                                  seven: seven);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: three ? Colors.blue : Colors.white,
                                      width: three ? 2 : 0)),
                              child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  child: Text('3')),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('T'),
                          InkWell(
                            onTap: () {
                              setState(() {
                                four = !four;
                                two ? two = !two : null;
                                three ? three = !three : null;
                                one ? one = !one : null;
                                five ? five = !five : null;
                                six ? six = !six : null;
                                seven ? seven = !seven : null;
                              });
                              automateProvider.setValues(
                                  global: global,
                                  messages: messages,
                                  ca: ca,
                                  us: us,
                                  one: one,
                                  two: two,
                                  three: three,
                                  four: four,
                                  five: five,
                                  six: six,
                                  seven: seven);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: four ? Colors.blue : Colors.white,
                                      width: four ? 2 : 0)),
                              child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  child: Text('4')),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('F'),
                          InkWell(
                            onTap: () {
                              setState(() {
                                five = !five;
                                two ? two = !two : null;
                                three ? three = !three : null;
                                four ? four = !four : null;
                                one ? one = !one : null;
                                six ? six = !six : null;
                                seven ? seven = !seven : null;
                              });
                              automateProvider.setValues(
                                  global: global,
                                  messages: messages,
                                  ca: ca,
                                  us: us,
                                  one: one,
                                  two: two,
                                  three: three,
                                  four: four,
                                  five: five,
                                  six: six,
                                  seven: seven);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: five ? Colors.blue : Colors.white,
                                      width: five ? 2 : 0)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Text('5'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('S'),
                          InkWell(
                            onTap: () {
                              setState(() {
                                six = !six;
                                two ? two = !two : null;
                                three ? three = !three : null;
                                four ? four = !four : null;
                                five ? five = !five : null;
                                one ? one = !one : null;
                                seven ? seven = !seven : null;
                              });
                              automateProvider.setValues(
                                  global: global,
                                  messages: messages,
                                  ca: ca,
                                  us: us,
                                  one: one,
                                  two: two,
                                  three: three,
                                  four: four,
                                  five: five,
                                  six: six,
                                  seven: seven);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: six ? Colors.blue : Colors.white,
                                      width: six ? 2 : 0)),
                              child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  child: Text('6')),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('S'),
                          InkWell(
                            onTap: () {
                              setState(() {
                                seven = !seven;
                                two ? two = !two : null;
                                three ? three = !three : null;
                                four ? four = !four : null;
                                five ? five = !five : null;
                                one ? one = !one : null;
                                six ? six = !six : null;
                              });
                              automateProvider.setValues(
                                  global: global,
                                  messages: messages,
                                  ca: ca,
                                  us: us,
                                  one: one,
                                  two: two,
                                  three: three,
                                  four: four,
                                  five: five,
                                  six: six,
                                  seven: seven);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: seven ? Colors.blue : Colors.white,
                                      width: seven ? 2 : 0)),
                              child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  child: Text('7')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Consumer<AutomateProvider>(
                    builder: (context, automateProvider, child) {
                      return Column(
                        children: [
                          Text('G: ${automateProvider.global}'),
                          Text('Day :${automateProvider.day}'),
                          Text('Type: ${automateProvider.postType}')
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        fresh = !fresh;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            fresh
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.grey),
                        SizedBox(width: 6),
                        Text('View Fresh',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 22,
                            )),
                      ],
                    ),
                  ),
                  fresh
                      ? Column(children: [
                           Align(
                              alignment: Alignment.topLeft,
                              child: Consumer<AutomateProvider>(
                                builder: (context, automateProvider, child) {
                                  if(automateProvider.initialScoreLoading) {
                                    return const CircularProgressIndicator();
                                  }
                                  return Text(
                                    'Initial Score: ${automateProvider.initialScore}',
                                    textAlign: TextAlign.left,
                                  );
                                }
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8),
                                    child: PhysicalModel(
                                      elevation: 3,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          // border: Border.all(
                                          //   width: 1,
                                          //   color: Colors.grey,
                                          // ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                        width: 160,
                                        height: 45,
                                        child: TextField(
                                          onEditingComplete: () {},
                                          onTap: () {},
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          controller: initialScoreController,
                                          decoration: const InputDecoration(
                                            hintText: "Score",
                                            labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontStyle: FontStyle.normal,
                                            ),
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(
                                              top: 0,
                                              left: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () {
                                      automateProvider.saveInitialScore(
                                          initialScoreController.text);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 12),
                                        child: Text(
                                          'Save',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Icon(Icons.add_circle_outline,
                                      color: Colors.blue),
                                  SizedBox(width: 4),
                                  Text('Add',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                      ))
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          PhysicalModel(
                            color: Colors.white,
                            elevation: 3,
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 246, 246, 246),
                              ),
                              child: Padding(
                                padding:
                                    EdgeInsets.only(bottom: is1Fresh ? 8 : 0),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          is1Fresh = !is1Fresh;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                    is1Fresh
                                                        ? Icons
                                                            .keyboard_arrow_up
                                                        : Icons
                                                            .keyboard_arrow_down,
                                                    color: Colors.grey,
                                                    size: 28),
                                                const SizedBox(width: 4),
                                                const Text(
                                                  "#1",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    letterSpacing: 0.5,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Icon(Icons.delete_outline,
                                                color: Colors.red, size: 25),
                                          ],
                                        ),
                                      ),
                                    ),
                                    is1Fresh
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              PhysicalModel(
                                                elevation: 3,
                                                color: Color.fromARGB(
                                                    255, 234, 234, 234),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 6),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      20,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5.0),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                            height: 20),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      2),
                                                          child: WillPopScope(
                                                            onWillPop:
                                                                () async {
                                                              return false;
                                                            },
                                                            child: Stack(
                                                              children: [
                                                                TextField(
                                                                  maxLength:
                                                                      _messageTitleTextfieldMaxLength,
                                                                  onChanged:
                                                                      (val) {
                                                                    setState(
                                                                        () {});
                                                                    // setState(() {
                                                                    //   emptyTittle = false;
                                                                    //   // emptyPollQuestion = false;
                                                                    // });
                                                                  },
                                                                  controller:
                                                                      _titleController,
                                                                  onTap: () {},
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        "Create a message",
                                                                    focusedBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: Colors
                                                                              .blue,
                                                                          width:
                                                                              2),
                                                                    ),
                                                                    contentPadding: EdgeInsets.only(
                                                                        top: 0,
                                                                        left: 4,
                                                                        right:
                                                                            45,
                                                                        bottom:
                                                                            8),
                                                                    isDense:
                                                                        true,
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                    labelStyle:
                                                                        TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  maxLines:
                                                                      null,
                                                                ),
                                                                Positioned(
                                                                  bottom: 5,
                                                                  right: 0,
                                                                  child: Text(
                                                                    '${_titleController.text.length}/$_messageTitleTextfieldMaxLength',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: _titleController.text.length ==
                                                                              _messageTitleTextfieldMaxLength
                                                                          ? const Color.fromARGB(
                                                                              255,
                                                                              220,
                                                                              105,
                                                                              96)
                                                                          : Colors
                                                                              .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(height: 30),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      2),
                                                          child: WillPopScope(
                                                            onWillPop:
                                                                () async {
                                                              return false;
                                                            },
                                                            child: Stack(
                                                              children: [
                                                                TextField(
                                                                  onChanged:
                                                                      (val) {
                                                                    setState(
                                                                        () {
                                                                      // emptyPollQuestion = false;
                                                                    });
                                                                  },
                                                                  controller:
                                                                      _bodyController,
                                                                  onTap: () {},
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        "Additional text (optional)",
                                                                    focusedBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: Colors
                                                                              .blue,
                                                                          width:
                                                                              2),
                                                                    ),
                                                                    contentPadding: EdgeInsets.only(
                                                                        top: 0,
                                                                        left: 4,
                                                                        right:
                                                                            45,
                                                                        bottom:
                                                                            8),
                                                                    isDense:
                                                                        true,
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                    labelStyle:
                                                                        TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  maxLines:
                                                                      null,
                                                                ),
                                                                const Positioned(
                                                                  bottom: 5,
                                                                  right: 0,
                                                                  child: Text(
                                                                    'unlimited',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(height: 27),
                                                        Column(
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          5.0),
                                                                ),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  _icon(0,
                                                                      icon: Icons
                                                                          .do_not_disturb),
                                                                  _icon(1,
                                                                      icon: Icons
                                                                          .collections),
                                                                  // _icon(2, icon: Icons.video_library),
                                                                  _icon(3,
                                                                      icon: MyFlutterApp
                                                                          .youtube),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                                height: 20),
                                                          ],
                                                        ),
                                                        _file != null
                                                            ? Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => FullImageScreenAdd(
                                                                                      file: MemoryImage(_file!),
                                                                                    )),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                248,
                                                                                248,
                                                                                248),
                                                                            border:
                                                                                Border.all(color: Colors.grey, width: 0.5),
                                                                          ),
                                                                          height:
                                                                              MediaQuery.of(context).size.width * 0.36,
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.72,

                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(3.0),
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                image: DecorationImage(
                                                                                  image: MemoryImage(_file!),
                                                                                  fit: BoxFit.contain,
                                                                                  // alignment: FractionalOffset.topCenter,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          // ),
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                40,
                                                                            height:
                                                                                40,
                                                                            child:
                                                                                Material(
                                                                              shape: const CircleBorder(),
                                                                              color: Colors.transparent,
                                                                              child: InkWell(
                                                                                customBorder: const CircleBorder(),
                                                                                splashColor: Colors.grey.withOpacity(0.3),
                                                                                onTap: () {
                                                                                  Future.delayed(const Duration(milliseconds: 50), () {
                                                                                    // _isVideoFile
                                                                                    //     ? _selectVideo(
                                                                                    //         context)
                                                                                    // :
                                                                                    _selectImage(context);
                                                                                  });
                                                                                },
                                                                                child: const Icon(Icons.change_circle, color: Colors.grey),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                40,
                                                                            height:
                                                                                40,
                                                                            child:
                                                                                Material(
                                                                              shape: const CircleBorder(),
                                                                              color: Colors.transparent,
                                                                              child: InkWell(
                                                                                customBorder: const CircleBorder(),
                                                                                splashColor: Colors.grey.withOpacity(0.3),
                                                                                onTap: () {
                                                                                  Future.delayed(const Duration(milliseconds: 50), () {
                                                                                    clearImage();
                                                                                    selected = 0;
                                                                                  });
                                                                                },
                                                                                child: const Icon(Icons.delete, color: Colors.grey),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  // Container(height: 20),
                                                                ],
                                                              )
                                                            : _videoUrlController
                                                                    .text
                                                                    .isEmpty
                                                                ? Container()
                                                                : LayoutBuilder(
                                                                    builder:
                                                                        (context,
                                                                            constraints) {
                                                                      return SizedBox(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width - 100,
                                                                              child: Stack(
                                                                                children: [
                                                                                  player,
                                                                                  Positioned.fill(
                                                                                    child: YoutubeValueBuilder(
                                                                                      controller: controller,
                                                                                      builder: (context, value) {
                                                                                        return AnimatedCrossFade(
                                                                                          crossFadeState: value.isReady ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                                                                          duration: const Duration(milliseconds: 300),
                                                                                          secondChild: const SizedBox.shrink(),
                                                                                          firstChild: Material(
                                                                                            child: DecoratedBox(
                                                                                              // ignore: sort_child_properties_last
                                                                                              child: const Center(
                                                                                                child: CircularProgressIndicator(),
                                                                                              ),
                                                                                              decoration: BoxDecoration(
                                                                                                image: DecorationImage(
                                                                                                  image: NetworkImage(
                                                                                                    YoutubePlayerController.getThumbnail(
                                                                                                      videoId: controller!.initialVideoId,
                                                                                                      quality: ThumbnailQuality.medium,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Column(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 40,
                                                                                  width: 40,
                                                                                  child: Material(
                                                                                    color: Colors.transparent,
                                                                                    shape: const CircleBorder(),
                                                                                    child: InkWell(
                                                                                      customBorder: const CircleBorder(),
                                                                                      splashColor: Colors.grey.withOpacity(0.3),
                                                                                      onTap: () {
                                                                                        Future.delayed(const Duration(milliseconds: 50), () {
                                                                                          _selectYoutube(context);
                                                                                        });
                                                                                      },
                                                                                      child: const Icon(Icons.change_circle, color: Colors.grey),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 40,
                                                                                  height: 40,
                                                                                  child: Material(
                                                                                    color: Colors.transparent,
                                                                                    shape: const CircleBorder(),
                                                                                    child: InkWell(
                                                                                      customBorder: const CircleBorder(),
                                                                                      splashColor: Colors.grey.withOpacity(0.3),
                                                                                      onTap: () {
                                                                                        Future.delayed(const Duration(milliseconds: 50), () {
                                                                                          clearVideoUrl();
                                                                                          setState(() {
                                                                                            selected = 0;
                                                                                          });
                                                                                        });
                                                                                      },
                                                                                      child: const Icon(Icons.delete, color: Colors.grey),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                        SizedBox(
                                                            height: _videoUrlController
                                                                        .text
                                                                        .isNotEmpty ||
                                                                    _file !=
                                                                        null
                                                                ? 20
                                                                : 0),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1),
                                                          ),
                                                          child: Consumer<
                                                                  CreatePageProvider>(
                                                              builder: (context,
                                                                  createProvider,
                                                                  child) {
                                                            return Column(
                                                              children: [
                                                                Autocomplete<
                                                                    String>(
                                                                  optionsViewBuilder:
                                                                      (context,
                                                                          onSelected,
                                                                          options) {
                                                                    return Container(
                                                                      margin: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              0.0,
                                                                          vertical:
                                                                              4.0),
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.topCenter,
                                                                        child:
                                                                            Material(
                                                                          elevation:
                                                                              4.0,
                                                                          child:
                                                                              ConstrainedBox(
                                                                            constraints:
                                                                                const BoxConstraints(maxHeight: 200),
                                                                            child:
                                                                                ListView.builder(
                                                                              shrinkWrap: true,
                                                                              itemCount: options.length,
                                                                              itemBuilder: (BuildContext context, int index) {
                                                                                final dynamic option = options.elementAt(index);
                                                                                return TextButton(
                                                                                  onPressed: () {
                                                                                    onSelected(option);
                                                                                  },
                                                                                  child: Align(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                                                                                      child: Text(
                                                                                        '$option',
                                                                                        textAlign: TextAlign.left,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  optionsBuilder:
                                                                      (TextEditingValue
                                                                          textEditingValue) {
                                                                    if (textEditingValue
                                                                            .text ==
                                                                        '') {
                                                                      return const Iterable<
                                                                          String>.empty();
                                                                    }
                                                                    return _pickLanguage
                                                                        .where((String
                                                                            option) {
                                                                      return option.contains(textEditingValue
                                                                          .text
                                                                          .toLowerCase());
                                                                    });
                                                                  },
                                                                  onSelected:
                                                                      (String
                                                                          selectedTag) {
                                                                    keywordMessageController
                                                                            .addTag =
                                                                        selectedTag;
                                                                  },
                                                                  fieldViewBuilder:
                                                                      (context,
                                                                          ttec,
                                                                          tfn,
                                                                          onFieldSubmitted) {
                                                                    return Stack(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              43,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                const BorderRadius.all(
                                                                              Radius.circular(5.0),
                                                                            ),
                                                                            // border: Border.all(color: Colors.grey, width: 1),
                                                                          ),
                                                                          child:
                                                                              TextFieldTags(
                                                                            textEditingController:
                                                                                ttec,
                                                                            focusNode:
                                                                                tfn,
                                                                            // textfieldTagsController:
                                                                            //     keywordMessageController,
                                                                            initialTags: const [],
                                                                            textSeparators: const [
                                                                              ' ',
                                                                              ',',
                                                                            ],
                                                                            letterCase:
                                                                                LetterCase.normal,
                                                                            inputfieldBuilder: (context,
                                                                                tec,
                                                                                fn,
                                                                                error,
                                                                                onChanged,
                                                                                onSubmitted) {
                                                                              return ((context, sc, tags, onTagDelete) {
                                                                                myTags = tags;
                                                                                List<String> tagsLower = tags;
                                                                                tagsLower = tagsLower.map((tagLower) => tagLower.toLowerCase()).toList();
                                                                                myTagsLowerCase = tagsLower;
                                                                                return Row(
                                                                                  children: [
                                                                                    Container(
                                                                                      constraints: BoxConstraints(maxWidth: tags.length < 3 ? MediaQuery.of(context).size.width / 2 : MediaQuery.of(context).size.width / 1.4),
                                                                                      child: SingleChildScrollView(
                                                                                        controller: sc,
                                                                                        scrollDirection: Axis.horizontal,
                                                                                        child: Row(
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: tags.map((String tag) {
                                                                                              return Container(
                                                                                                height: 28,
                                                                                                decoration: const BoxDecoration(
                                                                                                    borderRadius: BorderRadius.all(
                                                                                                      Radius.circular(20.0),
                                                                                                    ),
                                                                                                    color: Colors.grey),
                                                                                                margin: const EdgeInsets.only(left: 3, right: 3),
                                                                                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    InkWell(
                                                                                                      child: Text(
                                                                                                        tag,
                                                                                                        style: const TextStyle(color: Colors.white),
                                                                                                      ),
                                                                                                    ),
                                                                                                    const SizedBox(width: 4.0),
                                                                                                    InkWell(
                                                                                                      child: const Icon(
                                                                                                        Icons.cancel,
                                                                                                        size: 17.0,
                                                                                                        color: Colors.white,
                                                                                                      ),
                                                                                                      onTap: () {
                                                                                                        onTagDelete(tag);
                                                                                                      },
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              );
                                                                                            }).toList()),
                                                                                      ),
                                                                                    ),
                                                                                    Flexible(
                                                                                      child: TextField(
                                                                                        controller: tec,
                                                                                        focusNode: fn,
                                                                                        enabled: tags.length < 3,
                                                                                        onTap: () {},
                                                                                        decoration: InputDecoration(
                                                                                          contentPadding: const EdgeInsets.only(top: 10.0, left: 10, right: 0, bottom: 10),
                                                                                          hintText: tags.isNotEmpty ? '' : "Add up to 3 keywords (optional)",
                                                                                          hintStyle: const TextStyle(
                                                                                              // fontStyle:
                                                                                              //     FontStyle
                                                                                              //         .italic,
                                                                                              color: Colors.grey,
                                                                                              fontSize: 15),
                                                                                          errorText: error,
                                                                                          border: InputBorder.none,
                                                                                        ),
                                                                                        onChanged: onChanged,
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: 5, right: 5),
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          const Icon(Icons.key, color: Colors.grey),
                                                                                          tags.length == 3
                                                                                              ? Text(
                                                                                                  '${tags.length}/3',
                                                                                                  style: const TextStyle(
                                                                                                      // fontStyle: FontStyle.italic,
                                                                                                      fontSize: 12,
                                                                                                      color: Color.fromARGB(255, 220, 105, 96)),
                                                                                                )
                                                                                              : Text(
                                                                                                  '${tags.length}/3',
                                                                                                  style: const TextStyle(
                                                                                                    // fontStyle: FontStyle.italic,
                                                                                                    fontSize: 12,
                                                                                                    color: Colors.grey,
                                                                                                  ),
                                                                                                )
                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                );
                                                                              });
                                                                            },
                                                                          ),
                                                                        )
                                                                      ],
                                                                    );
                                                                  },
                                                                ),
                                                                // const SizedBox(
                                                                //   height: 4,
                                                                // ),
                                                              ],
                                                            );
                                                          }),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ])
                      : const SizedBox(),
                  const SizedBox(height: 8),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      setState(() {
                        recycle = !recycle;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            recycle
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.grey),
                        SizedBox(width: 6),
                        Text('View Recycle',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 22,
                            )),
                      ],
                    ),
                  ),
                  recycle
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.add_circle_outline,
                                        color: Colors.blue),
                                    SizedBox(width: 4),
                                    Text('Add',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ))
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            PhysicalModel(
                              color: Colors.white,
                              elevation: 3,
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      const Color.fromARGB(255, 246, 246, 246),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: is1Recycle ? 8 : 0),
                                  child: Column(children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          is1Recycle = !is1Recycle;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                    is1Recycle
                                                        ? Icons
                                                            .keyboard_arrow_up
                                                        : Icons
                                                            .keyboard_arrow_down,
                                                    color: Colors.grey,
                                                    size: 28),
                                                const SizedBox(width: 4),
                                                const Text(
                                                  "#1",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    letterSpacing: 0.5,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Icon(Icons.delete_outline,
                                                color: Colors.red, size: 25),
                                          ],
                                        ),
                                      ),
                                    ),
                                    is1Recycle ? Text('1') : const SizedBox(),
                                  ]),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(height: 8),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
