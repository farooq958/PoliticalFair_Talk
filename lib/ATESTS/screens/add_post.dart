import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as ytplayer;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../camera/camera_screen.dart';
import '../info screens/add_info.dart';
import '../info screens/add_post_rules.dart';
import '../methods/auth_methods.dart';
import '../methods/firestore_methods.dart';
import '../methods/storage_methods.dart';
import '../models/user.dart';
import '../provider/create_provider.dart';
import '../provider/user_provider.dart';
import '../responsive/my_flutter_app_icons.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import 'full_image_add.dart';
import 'my_drawer_list.dart';

class AddPost extends StatefulWidget {
  const AddPost({
    Key? key,
    this.durationInDay,
  }) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final durationInDay;

  @override
  State<AddPost> createState() => _AddPostState();
}

class Customer {
  String tagName;
  int tagValue;

  Customer(this.tagName, this.tagValue);

  @override
  String toString() {
    return '{ $tagName, $tagValue }';
  }
}

class _AddPostState extends State<AddPost> {
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
  var messages = 'true';
  var global = 'true';
  var snap;
  Uint8List? _file;
  var selected = 0;
  String? videoUrl = '';

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
  User? user;
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
  StreamSubscription<bool>? keyboardSubscription;

  String _hoursDate = '';
  int _hoursTimer = 0;

  String _minutesDate = '';
  int _minutesTimer = 0;

  // /***/
  // /***/
  InterstitialAd? interstitialAd;

  final String interstitialAdUnitIdIOS =
      'ca-app-pub-1591305463797264/4735037493';
  final String interstitialAdUnitIdAndroid =
      'ca-app-pub-1591305463797264/9016556769';
  // /***/
  // /***/

  @override
  void initState() {
    super.initState();
    // getValueG();
    // getValueM();
    // DateTime startDate = NTP.now();
    // init();
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
    _loadInterstitialAd();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void clearVideoUrl() {
    setState(() {
      _videoUrlController.clear();
    });
  }

  // init() async {
  //   Future.delayed(Duration.zero);
  //   DateTime startDate = await NTP.now();
  //   _hoursDate = DateFormat.H().format(startDate);
  //   _hoursTimer = 23 - int.parse(_hoursDate);
  //   _minutesDate = DateFormat.m().format(startDate);
  //   _minutesTimer = 59 - int.parse(_minutesDate);
  //   // hours = startDate.hour;
  //   // _minutes = endDate.difference(startDate).inMinutes.remainder(60).toString();
  //   setState(() {});
  // }

  void _loadInterstitialAd() {
    if (Platform.isIOS) {
      InterstitialAd.load(
        adUnitId: interstitialAdUnitIdIOS,

        request: const AdRequest(),
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;

          _setFullScreenContentCallback(ad);
        }, onAdFailedToLoad: (LoadAdError loadAdError) {
          debugPrint('$loadAdError');
        }),
        // orientation: AppOpenAd.orientationPortrait,
      );
    } else if (Platform.isAndroid) {
      InterstitialAd.load(
        adUnitId: interstitialAdUnitIdAndroid,
        request: const AdRequest(),
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;

          _setFullScreenContentCallback(ad);
        }, onAdFailedToLoad: (LoadAdError loadAdError) {
          debugPrint('$loadAdError');
        }),
        // orientation: AppOpenAd.orientationPortrait,
      );
    }
  }

  void _setFullScreenContentCallback(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => print('$ad'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('$ad');
        showSnackBar(
          messages == 'true'
              ? 'Message successfully created.'
              : 'Poll successfully created.',
          context,
        );
        ad.dispose();
        interstitialAd = null;
        _loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('$ad - error: $error');
        ad.dispose();
        interstitialAd = null;
        _loadInterstitialAd();
      },
      onAdImpression: (InterstitialAd ad) =>
          debugPrint('$ad Impression occurred'),
    );
  }

  void _showInterstitialAd() {
    interstitialAd?.show();
  }

  //  void showAd() {
  //   if (openAd == null) {
  //     loadAd();
  //     return;
  //   }

  //   openAd!.fullScreenContentCallback =
  //       FullScreenContentCallback(onAdShowedFullScreenContent: (ad) {
  //     print('onAdShowedFullScreenContent');
  //   }, onAdFailedToShowFullScreenContent: (ad, error) {
  //     ad.dispose();
  //     print('failed to load error $error');
  //     openAd = null;
  //     loadAd();
  //   }, onAdDismissedFullScreenContent: (ad) {
  //     ad.dispose();
  //     print('dismissed');
  //     openAd = null;
  //     loadAd();
  //   });

  //   openAd!.show();
  // }

  void waitTimer({required int time, required String type}) async {
    try {
      String res = await AuthMethods().waitTimer(time: time, type: type);
    } catch (e) {
      //
    }
  }

  final CollectionReference firestoreInstance =
      FirebaseFirestore.instance.collection('postCounter');

  Future<String> _loadMessageCounter() async {
    String res1 = "Some error occurred.";
    try {
      await firestoreInstance.doc('messageCounter').get().then((event) {
        setState(() {
          getCounterPost = event['counter'];
        });
      });
      res1 = "success";
    } catch (e) {
      //
    }
    return res1;
  }

  Future<String> _loadPollCounter() async {
    String res1 = "Some error occurred.";
    try {
      await firestoreInstance.doc('pollCounter').get().then((event) {
        setState(() {
          getCounterPoll = event['counter'];
        });
      });
      res1 = "success";
    } catch (e) {
      //
    }
    return res1;
  }

  // void getPostCounter({required String type}) async {
  //   try {
  //     var collection = FirebaseFirestore.instance.collection('postCounter');
  //     var docSnapshot = await collection
  //         .doc(type == 'post'
  //             ? 'messageCounter'
  //             : type == 'poll'
  //                 ? 'pollCounter'
  //                 : type == 'comment'
  //                     ? 'commentCounter'
  //                     : 'replyCounter')
  //         .get();
  //     if (docSnapshot.exists) {
  //       Map<String, dynamic>? data = docSnapshot.data();
  //       int counter = data?['counter'];

  //       setState(() {
  //         getCounter = counter;
  //       });
  //     }
  //   } catch (e) {
  //     // print(
  //   }
  // }

  //
  //MESSAGE
  //
  void postImage(
    String uid,
    String username,
    String profImage,
    String mCountry,
  ) async {
    try {
      if (selected == 3) {
        if (_videoUrlController.text.isEmpty) {
          setState(() {
            selected = 0;
          });
        }
      }
      // emptyTittle = _titleController.text.trim().isEmpty;
      // setState(() {});
      // if () {
      setState(() {
        _isLoading = true;
      });
      String photoUrl = "";
      if (_file == null) {
        photoUrl = "";
      } else {
        photoUrl =
            await StorageMethods().uploadImageToStorage('posts', _file!, true);
      }

      // String videoUrl = "";
      // if (_videoFile == null) {
      //   videoUrl = "";
      // } else {
      //   videoUrl = await StorageMethods()
      //       .uploadImageToStorage('posts', _file!, true);
      // }

      // if (country == '') {
      //   country = user!.aaCountry;
      // } else {}

      String res1 = await _loadMessageCounter();

      String res = await FirestoreMethods().uploadPost(
        uid,
        username,
        profImage,
        mCountry,
        global,
        _titleController.text,
        _bodyController.text,
        videoUrl!,
        photoUrl,
        // selected,
        getCounterPost,
        widget.durationInDay,
        'none',
        myTagsLowerCase,
      );

      if (res1 == "success" && res == "success") {
        Future.delayed(const Duration(milliseconds: 1500), () {
          _showInterstitialAd();
          FocusScope.of(context).unfocus();
          _titleController.clear();
          _bodyController.clear();

          clearImage();
          clearVideoUrl();
          setState(() {
            _isLoading = false;
            selected = 0;
          });

          global == 'true'
              ? waitTimer(time: widget.durationInDay, type: 'gMessage')
              : waitTimer(time: widget.durationInDay, type: 'nMessage');
        });
      } else {
        showSnackBar(res, context);
      }
      // }
    } catch (e) {
      showSnackBarError(e.toString(), context);
    }
  }

//
//POLL
//

  void postImagePoll(
      String uid, String username, String profImage, String mCountry) async {
    try {
      // Validates poll question text field

      // Validates Poll Option 1 and 2 text fields
      // emptyOptionOne = _cont![0].text.trim().isEmpty;
      // emptyOptionTwo = _cont![1].text.trim().isEmpty;

      // setState(() {});
      // emptyOptionOne = _optionOne.text.trim().isEmpty;
      // emptyOptionTwo = _optionTwo.text.trim().isEmpty;
      //  emptyPollQuestion = _pollController.text.trim().isEmpty;

      // If Poll question and Poll option 1 and 2 are not empty the post poll
      // if (!emptyPollQuestion && !emptyOptionOne && !emptyOptionTwo) {
      // if (country == '') {
      //   country = user!.aaCountry;
      setState(() {
        _isLoading = true;
      });
      // }
      String res1 = await _loadPollCounter();

      // getPostCounter(type: 'poll');

      String res = await FirestoreMethods().uploadPoll(
          uid,
          username,
          profImage,
          mCountry,
          global,
          _pollController.text.trim(),
          _optionOne.text.trim(),
          _optionTwo.text.trim(),
          _optionThree.text.trim(),
          _optionFour.text.trim(),
          _optionFive.text.trim(),
          _optionSix.text.trim(),
          _optionSeven.text.trim(),
          _optionEight.text.trim(),
          _optionNine.text.trim(),
          _optionTen.text.trim(),
          widget.durationInDay,
          getCounterPoll,
          myTagsPollLowerCase);
      if (res1 == "success" && res == "success") {
        Future.delayed(const Duration(milliseconds: 1500), () {
          _showInterstitialAd();

          setState(() {
            _isLoading = false;
            _pollController.clear();
            _optionOne.clear();
            _optionTwo.clear();
            _optionThree.clear();
            _optionFour.clear();
            _optionFive.clear();
            _optionSix.clear();
            _optionSeven.clear();
            _optionEight.clear();
            _optionNine.clear();
            _optionTen.clear();
            FocusScope.of(context).unfocus();
          });

          global == 'true'
              ? waitTimer(time: widget.durationInDay, type: 'gPoll')
              : waitTimer(time: widget.durationInDay, type: 'nPoll');
        });
      } else {
        showSnackBar(res, context);
      }
      // }
    } catch (e) {
      showSnackBarError(e.toString(), context);
    }
  }

  // ignore: non_constant_identifier_names
  var AllList = [];
  var fetchedList = [];
  List trendingKey = [];
  List trendingkeyvalue = [];
  List list = [];

  Future<void> getData() async {
    // Get docas from collection reference

    await (global == "true"
            ? FirebaseFirestore.instance.collection('posts')
            : FirebaseFirestore.instance
                .collection('posts')
                .where("country", isEqualTo: user?.aaCountry))
        .where("global", isEqualTo: global)
        .orderBy("tagsLowerCase")
        .get()
        .then((QuerySnapshot querySnapshot) {
      AllList.clear();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        fetchedList = querySnapshot.docs[i]["tagsLowerCase"];
        // print("fetchedlist");
        // print(fetchedList);
        var result = fetchedList.toSet().toList();

        AllList.addAll(result);
      }

      final myMap = {};

      for (var element in AllList) {
        if (!myMap.containsKey(element)) {
          myMap[element] = 1;
        } else {
          myMap[element] += 1;
        }
      }
      list.clear();
      myMap.forEach((k, v) => list.add(Customer(k, v)));
      list.sort((b, a) => a.tagValue.compareTo(b.tagValue));
      return AllList;
    });
  }

  // ignore: non_constant_identifier_names
  var AllListPoll = [];
  var fetchedListPoll = [];
  List trendingKeyPoll = [];
  List trendingkeyvaluePoll = [];
  List listPoll = [];

  Future<void> getDataPoll() async {
    // Get docas from collection reference

    await (global == "true"
            ? FirebaseFirestore.instance.collection('polls')
            : FirebaseFirestore.instance
                .collection('polls')
                .where("country", isEqualTo: user?.aaCountry))
        .where("global", isEqualTo: global)
        .orderBy("tagsLowerCase")
        .get()
        .then((QuerySnapshot querySnapshot) {
      AllListPoll.clear();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        fetchedListPoll = querySnapshot.docs[i]["tagsLowerCase"];
        var result = fetchedListPoll.toSet().toList();
        AllListPoll.addAll(result);
      }

      final myMap = {};

      for (var element in AllListPoll) {
        if (!myMap.containsKey(element)) {
          myMap[element] = 1;
        } else {
          myMap[element] += 1;
        }
      }
      listPoll.clear();
      myMap.forEach((k, v) => listPoll.add(Customer(k, v)));
      listPoll.sort((b, a) => a.tagValue.compareTo(b.tagValue));
      return AllListPoll;
    });
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    controller!.close();
    _titleController.dispose;
    _bodyController.dispose;
    _videoUrlController.dispose;
    keywordMessageController.dispose;
    _pollController.dispose;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('duration in day in add post ${widget.durationInDay}');
    // durationInDay = await DurationProvider.getDurationInDays();

    // if (_userProfile?.gMessageTime == widget.durationInDay &&
    //     global == "true") {
    //   buttonColor = Colors.grey.withOpacity(0.7);
    //   disableButton = true;
    // }

    const player = YoutubePlayerIFrame();
    user = Provider.of<UserProvider>(context).getUser;

    // return InkWell(
    //   onTap: () async {
    //     print("HELLO TAPPED");
    //
    //
    //     QuerySnapshot<Map<String, dynamic>> mostLikedByCountryQuerySnapshot =
    //     await FirebaseFirestore.instance
    //         .collection('mostLikedByCountry')
    //         .doc(user?.aaCountry)
    //         .collection('mostLiked')
    //         .where('UID', isEqualTo: user?.UID)
    //         .get();
    //     for (var element in mostLikedByCountryQuerySnapshot.docs) {
    //       print("element: ${element.data()}");
    //       // await element.reference.delete();
    //     }
    //   },
    //   child: Container(
    //     height: 100,
    //     width: 100,
    //     color: Colors.cyanAccent,
    //     child: Text('HELLO'),
    //   ),
    // );

    return user == null
        ? buildAdd(context)
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.UID ?? '')
                .snapshots(),
            builder: (content,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.data?.data() != null) {
                snap = snapshot.data != null
                    ? User.fromSnap(snapshot.data!)
                    : snap;

                return buildAdd(context, snapshot);
              } else {
                return buildAdd(context);
              }
            });
  }

  Widget _icon(int index, {required IconData icon}) {
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
                  radius: 43.5,
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

  // _selectVideo(BuildContext context) async {
  //   return showDialog(
  //     context: context,
  //     builder: (_) => Dialog(
  //       backgroundColor: Colors.transparent,
  //       insetPadding: EdgeInsets.zero,
  //       child: Stack(
  //         clipBehavior: Clip.none,
  //         alignment: Alignment.center,
  //         children: <Widget>[
  //           Container(
  //             width: 295,
  //             // height: MediaQuery.of(context).size.height * 0.43,
  //             height: 290,
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(15), color: Colors.white),
  //             padding: EdgeInsets.fromLTRB(10, 45, 10, 0),
  //             child: Column(
  //               children: [
  //                 SimpleDialogOption(
  //                   padding: const EdgeInsets.only(
  //                       top: 20, left: 20, right: 20, bottom: 5),
  //                   child: Text("Upload Video",
  //                       style: TextStyle(
  //                         fontSize: 20,
  //                         color: Colors.transparent,
  //                         // letterSpacing: 0.5,
  //                         fontWeight: FontWeight.w500,
  //                         shadows: [
  //                           Shadow(offset: Offset(0, -5), color: Colors.black)
  //                         ],
  //                         decoration: TextDecoration.underline,
  //                         decorationColor: Colors.black,
  //                       )),
  //                   onPressed: () {},
  //                 ),
  //                 Container(
  //                   color: Colors.white,
  //                   width: MediaQuery.of(context).size.width * 0.75,
  //                   height: 60,
  //                   child: Material(
  //                     color: Colors.white,
  //                     child: InkWell(
  //                       onTap: () async {
  //                         var file = await openCamera(
  //                           context: context,
  //                           cameraFileType: CameraFileType.video,
  //                           add: add,
  //                         );
  //                         print(file);
  //                         if (file != null) {
  //                           setState(() {
  //                             _file = (file as File).readAsBytesSync();
  //                             _videoFile = (file as File);
  //                             _isVideoFile = true;
  //                           });
  //                         }
  //                         Future.delayed(const Duration(milliseconds: 150), () {
  //                           Navigator.of(context).pop();
  //                         });
  //                       },
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Icon(
  //                               Icons.camera_alt,
  //                               color: Color.fromARGB(255, 139, 139, 139),
  //                             ),
  //                             Container(width: 8),
  //                             Text('Open camera',
  //                                 style: TextStyle(
  //                                     letterSpacing: 0.2, fontSize: 15)),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Container(
  //                   color: Colors.white,
  //                   width: MediaQuery.of(context).size.width * 0.75,
  //                   height: 60,
  //                   child: Material(
  //                     color: Colors.white,
  //                     child: InkWell(
  //                       onTap: () async {
  //                         File file = await pickVideo(
  //                           ImageSource.gallery,
  //                         );
  //                         setState(() {
  //                           _file = (file as File).readAsBytesSync();
  //                           _videoFile = (file as File);
  //                           _isVideoFile = true;
  //                         });
  //                         Future.delayed(const Duration(milliseconds: 150), () {
  //                           Navigator.of(context).pop();
  //                         });
  //                       },
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Icon(
  //                               Icons.video_library,
  //                               color: Color.fromARGB(255, 139, 139, 139),
  //                             ),
  //                             Container(width: 8),
  //                             Text('Choose from gallery',
  //                                 style: TextStyle(
  //                                     letterSpacing: 0.2, fontSize: 15)),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Container(
  //                   color: Colors.white,
  //                   width: MediaQuery.of(context).size.width * 0.75,
  //                   height: 60,
  //                   child: Material(
  //                     color: Colors.white,
  //                     child: InkWell(
  //                       onTap: () {
  //                         _file == null
  //                             ? setState(() {
  //                                 selected = 0;
  //                               })
  //                             : null;

  //                         Future.delayed(const Duration(milliseconds: 150), () {
  //                           Navigator.of(context).pop();
  //                         });
  //                       },
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Icon(
  //                               Icons.cancel,
  //                               color: Color.fromARGB(255, 139, 139, 139),
  //                             ),
  //                             Container(width: 8),
  //                             Text('Cancel',
  //                                 style: TextStyle(
  //                                     letterSpacing: 0.2, fontSize: 15)),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Positioned(
  //             top: -50,
  //             child: CircleAvatar(
  //               radius: 50,
  //               backgroundColor: Colors.white,
  //               child: CircleAvatar(
  //                 backgroundColor: Color.fromARGB(255, 139, 139, 139),
  //                 radius: 43.5,
  //                 child: FittedBox(
  //                   child: Icon(
  //                     Icons.video_library,
  //                     size: 50,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   ).then((value) => _file == null
  //       ? setState(() {
  //           selected = 0;
  //         })
  //       : print('not null'));
  // }

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
                  radius: 43.5,
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

  Widget buildAdd(BuildContext context,
      [AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>? snapshot]) {
    const player = YoutubePlayerIFrame();
    User? user;
    user = Provider.of<UserProvider>(context).getUser;

    return YoutubePlayerControllerProvider(
      controller: controller!,
      child: Stack(
        children: [
          Scaffold(
            key: _key,
            backgroundColor: testing,
            drawer: Drawer(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SettingsScreen(
                      durationInDay: widget.durationInDay,
                      onLoading: (isLoading) {
                        setState(() {
                          _logoutLoading = isLoading;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 4,
              toolbarHeight: 68,
              backgroundColor: darkBlue,
              actions: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 36,
                                height: 35,
                                child: Material(
                                  shape: const CircleBorder(),
                                  color: Colors.transparent,
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    splashColor: Colors.grey.withOpacity(0.5),
                                    onTap: () {
                                      Future.delayed(
                                          const Duration(milliseconds: 50), () {
                                        _key.currentState?.openDrawer();
                                      });
                                    },
                                    child: const Icon(Icons.settings,
                                        color: whiteDialog),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 1.0),
                                        child: Text(
                                          global == "true"
                                              ? 'GLOBAL'
                                              : 'NATIONAL',
                                          style: const TextStyle(
                                            color: whiteDialog,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: global == "true" ? 0 : 4),
                                      global == 'true' || user == null
                                          ? Row()
                                          : snap?.aaCountry != ""
                                              ? SizedBox(
                                                  width: 24,
                                                  height: 16,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 2.0),
                                                      child: Image.asset(
                                                        'icons/flags/png/${snap?.aaCountry}.png',
                                                        package:
                                                            'country_icons',
                                                      )),
                                                )
                                              : Row(),
                                    ],
                                  ),
                                  PhysicalModel(
                                    color: Colors.transparent,
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(25),
                                    child: Container(
                                        width: 120,
                                        height: 32.5,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              child: InkWell(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(25),
                                                  bottomLeft:
                                                      Radius.circular(25),
                                                ),
                                                onTap: () {
                                                  final createProvider = Provider
                                                      .of<CreatePageProvider>(
                                                          context,
                                                          listen: false);
                                                  global == "true"
                                                      ? null
                                                      : setState(() {
                                                          global = "true";
                                                          // init();
                                                          if (createProvider
                                                                      .showTrendingMessage ==
                                                                  true &&
                                                              messages ==
                                                                  "true") {
                                                            createProvider
                                                                .getkeywordList(
                                                              global,
                                                              user!.aaCountry,
                                                              widget
                                                                  .durationInDay,
                                                            );
                                                          }
                                                          if (createProvider
                                                                      .showTrendingPoll ==
                                                                  true &&
                                                              messages !=
                                                                  "true") {
                                                            createProvider
                                                                .getpollKeywordList(
                                                                    global,
                                                                    user!
                                                                        .aaCountry,
                                                                    widget
                                                                        .durationInDay);
                                                          }
                                                        });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(25),
                                                      bottomLeft:
                                                          Radius.circular(25),
                                                    ),
                                                    color: global == "true"
                                                        ? whiteDialog
                                                        : darkBlue,
                                                  ),
                                                  height: 100,
                                                  width: 58,
                                                  child: Icon(
                                                    MyFlutterApp.globe_americas,
                                                    color: global == "true"
                                                        ? darkBlue
                                                        : whiteDialog,
                                                    size: global == "true"
                                                        ? 23
                                                        : 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ClipRRect(
                                              child: InkWell(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topRight: Radius.circular(25),
                                                  bottomRight:
                                                      Radius.circular(25),
                                                ),
                                                onTap: () {
                                                  final createProvider = Provider
                                                      .of<CreatePageProvider>(
                                                          context,
                                                          listen: false);
                                                  global != "true"
                                                      ? null
                                                      : setState(() {
                                                          global = "false";
                                                          // init();
                                                          // createProvider
                                                          //     .getkeywordList(
                                                          //         global,
                                                          //         user!.aaCountry,
                                                          //         widget
                                                          //             .durationInDay);
                                                          if (createProvider
                                                                      .showTrendingMessage ==
                                                                  true &&
                                                              messages ==
                                                                  "true") {
                                                            createProvider
                                                                .getkeywordList(
                                                                    global,
                                                                    user!
                                                                        .aaCountry,
                                                                    widget
                                                                        .durationInDay);
                                                          }
                                                          if (createProvider
                                                                      .showTrendingPoll ==
                                                                  true &&
                                                              messages !=
                                                                  "true") {
                                                            createProvider
                                                                .getpollKeywordList(
                                                                    global,
                                                                    user!
                                                                        .aaCountry,
                                                                    widget
                                                                        .durationInDay);
                                                          }
                                                        });
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topRight:
                                                            Radius.circular(25),
                                                        bottomRight:
                                                            Radius.circular(25),
                                                      ),
                                                      color: global != "true"
                                                          ? whiteDialog
                                                          : darkBlue,
                                                    ),
                                                    height: 100,
                                                    width: 58,
                                                    child: Icon(Icons.flag,
                                                        color: global != "true"
                                                            ? darkBlue
                                                            : whiteDialog,
                                                        size: global != "true"
                                                            ? 23
                                                            : 15)),
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 1.0),
                                    child: Text(
                                      messages == "true" ? 'MESSAGES' : 'POLLS',
                                      style: const TextStyle(
                                        color: whiteDialog,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  PhysicalModel(
                                    color: Colors.transparent,
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(25),
                                    child: Container(
                                      width: 120,
                                      height: 32.5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            child: InkWell(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                bottomLeft: Radius.circular(25),
                                              ),
                                              onTap: () {
                                                final createProvider = Provider
                                                    .of<CreatePageProvider>(
                                                        context,
                                                        listen: false);
                                                messages == "true"
                                                    ? null
                                                    : setState(() {
                                                        messages = "true";
                                                        user == null
                                                            ? null
                                                            : createProvider
                                                                .getkeywordList(
                                                                    global,
                                                                    user!
                                                                        .aaCountry,
                                                                    widget
                                                                        .durationInDay);
                                                      });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(25),
                                                    bottomLeft:
                                                        Radius.circular(25),
                                                  ),
                                                  color: messages == "true"
                                                      ? whiteDialog
                                                      : darkBlue,
                                                ),
                                                height: 100,
                                                width: 58,
                                                child: Icon(Icons.message,
                                                    color: messages == "true"
                                                        ? darkBlue
                                                        : whiteDialog,
                                                    size: messages == "true"
                                                        ? 23
                                                        : 15),
                                              ),
                                            ),
                                          ),
                                          ClipRRect(
                                            child: InkWell(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(25),
                                                bottomRight:
                                                    Radius.circular(25),
                                              ),
                                              onTap: () {
                                                // performLoggedUserAction(
                                                //     context: context,
                                                //     action: () {
                                                final createProvider = Provider
                                                    .of<CreatePageProvider>(
                                                        context,
                                                        listen: false);
                                                messages != "true"
                                                    ? null
                                                    : setState(() {
                                                        messages = "false";

                                                        user == null
                                                            ? null
                                                            : createProvider
                                                                .getpollKeywordList(
                                                                    global,
                                                                    user!
                                                                        .aaCountry,
                                                                    widget
                                                                        .durationInDay);
                                                      });
                                                // });
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(25),
                                                      bottomRight:
                                                          Radius.circular(25),
                                                    ),
                                                    color: messages != "true"
                                                        ? whiteDialog
                                                        : darkBlue,
                                                  ),
                                                  height: 100,
                                                  width: 58,
                                                  child: RotatedBox(
                                                    quarterTurns: 1,
                                                    child: Icon(Icons.poll,
                                                        color:
                                                            messages != "true"
                                                                ? darkBlue
                                                                : whiteDialog,
                                                        size: messages != "true"
                                                            ? 23
                                                            : 15),
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 36,
                                height: 36,
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
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AddInfo()),
                                          );
                                        });
                                      },
                                      child: const Icon(Icons.info_outline,
                                          color: whiteDialog)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        _isLoading
                            ? const LinearProgressIndicator(color: Colors.white)
                            : const Padding(padding: EdgeInsets.only(top: 0)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: messages == 'true'
                ? SingleChildScrollView(
                    reverse: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // _isLoading
                          //     ? const LinearProgressIndicator()
                          //     : const Padding(padding: EdgeInsets.only(top: 0)),
                          // const Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          PhysicalModel(
                            elevation: 3,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              // width: MediaQuery.of(context).size.width - 20,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      child: WillPopScope(
                                        onWillPop: () async {
                                          return false;
                                        },
                                        child: Stack(
                                          children: [
                                            TextField(
                                              maxLength:
                                                  _messageTitleTextfieldMaxLength,
                                              onChanged: (val) {
                                                setState(() {});
                                                // setState(() {
                                                //   emptyTittle = false;
                                                //   // emptyPollQuestion = false;
                                                // });
                                              },
                                              controller: _titleController,
                                              onTap: () {},
                                              decoration: const InputDecoration(
                                                hintText: "Create a message",
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blue,
                                                      width: 2),
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 0,
                                                    left: 4,
                                                    right: 45,
                                                    bottom: 8),
                                                isDense: true,
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                                labelStyle: TextStyle(
                                                    color: Colors.black),
                                                counterText: '',
                                              ),
                                              maxLines: null,
                                            ),
                                            Positioned(
                                              bottom: 5,
                                              right: 0,
                                              child: Text(
                                                '${_titleController.text.length}/$_messageTitleTextfieldMaxLength',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: _titleController
                                                              .text.length ==
                                                          _messageTitleTextfieldMaxLength
                                                      ? const Color.fromARGB(
                                                          255, 220, 105, 96)
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(height: 30),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      child: WillPopScope(
                                        onWillPop: () async {
                                          return false;
                                        },
                                        child: Stack(
                                          children: [
                                            TextField(
                                              onChanged: (val) {
                                                setState(() {
                                                  // emptyPollQuestion = false;
                                                });
                                              },
                                              controller: _bodyController,
                                              onTap: () {},
                                              decoration: const InputDecoration(
                                                hintText:
                                                    "Additional text (optional)",
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blue,
                                                      width: 2),
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 0,
                                                    left: 4,
                                                    right: 45,
                                                    bottom: 8),
                                                isDense: true,
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                                labelStyle: TextStyle(
                                                    color: Colors.black),
                                                counterText: '',
                                              ),
                                              maxLines: null,
                                            ),
                                            const Positioned(
                                              bottom: 5,
                                              right: 0,
                                              child: Text(
                                                'unlimited',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
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
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            border: Border.all(
                                                color: Colors.grey, width: 1),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              _icon(0,
                                                  icon: Icons.do_not_disturb),
                                              _icon(1, icon: Icons.collections),
                                              // _icon(2, icon: Icons.video_library),
                                              _icon(3,
                                                  icon: MyFlutterApp.youtube),
                                            ],
                                          ),
                                        ),
                                        Container(height: 20),
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
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                // _isVideoFile &&
                                                                //         _videoFile !=
                                                                //             null
                                                                //     ? PreviewPictureScreen(
                                                                //         previewOnly:
                                                                //             true,
                                                                //         filePath:
                                                                //             _videoFile!
                                                                //                 .path,
                                                                //         cameraFileType:
                                                                //             CameraFileType
                                                                //                 .video,
                                                                //         add: add,
                                                                //       )
                                                                // :
                                                                FullImageScreenAdd(
                                                                  file: MemoryImage(
                                                                      _file!),
                                                                )),
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 248, 248, 248),
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 0.5),
                                                      ),
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.36,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.72,

                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child:
                                                            // _isVideoFile &&
                                                            //         _videoFile != null
                                                            //     ? FutureBuilder(
                                                            //         future:
                                                            //             _getVideoThumbnail(
                                                            //           file: _videoFile!,
                                                            //         ),
                                                            //         builder: (BuildContext
                                                            //                 context,
                                                            //             AsyncSnapshot<File>
                                                            //                 snapshot) {
                                                            //           switch (snapshot
                                                            //               .connectionState) {
                                                            //             case ConnectionState
                                                            //                 .none:
                                                            //               print(
                                                            //                   'ConnectionState.none');
                                                            //               break;
                                                            //             case ConnectionState
                                                            //                 .waiting:
                                                            //               return const Center(
                                                            //                 child:
                                                            //                     CircularProgressIndicator(),
                                                            //               );
                                                            //               break;
                                                            //             case ConnectionState
                                                            //                 .active:
                                                            //               print(
                                                            //                   'ConnectionState.active');
                                                            //               break;
                                                            //             case ConnectionState
                                                            //                 .done:
                                                            //               print(
                                                            //                   'ConnectionState.done');
                                                            //               break;
                                                            //           }

                                                            //           return snapshot
                                                            //                       .data !=
                                                            //                   null
                                                            //               ? Stack(
                                                            //                   alignment:
                                                            //                       Alignment
                                                            //                           .center,
                                                            //                   children: [
                                                            //                     Image.file(
                                                            //                         snapshot
                                                            //                             .data!),
                                                            //                     const Center(
                                                            //                       child:
                                                            //                           Icon(
                                                            //                         Icons
                                                            //                             .play_circle_outline,
                                                            //                         color: Colors
                                                            //                             .white,
                                                            //                       ),
                                                            //                     ),
                                                            //                   ],
                                                            //                 )
                                                            //               : const Center(
                                                            //                   child:
                                                            //                       CircularProgressIndicator(),
                                                            //                 );
                                                            //         },
                                                            //       )
                                                            // :
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  MemoryImage(
                                                                      _file!),
                                                              fit: BoxFit
                                                                  .contain,
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
                                                        width: 40,
                                                        height: 40,
                                                        child: Material(
                                                          shape:
                                                              const CircleBorder(),
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            customBorder:
                                                                const CircleBorder(),
                                                            splashColor: Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.3),
                                                            onTap: () {
                                                              Future.delayed(
                                                                  const Duration(
                                                                      milliseconds:
                                                                          50),
                                                                  () {
                                                                // _isVideoFile
                                                                //     ? _selectVideo(
                                                                //         context)
                                                                // :
                                                                _selectImage(
                                                                    context);
                                                              });
                                                            },
                                                            child: const Icon(
                                                                Icons
                                                                    .change_circle,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                        height: 40,
                                                        child: Material(
                                                          shape:
                                                              const CircleBorder(),
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            customBorder:
                                                                const CircleBorder(),
                                                            splashColor: Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.3),
                                                            onTap: () {
                                                              Future.delayed(
                                                                  const Duration(
                                                                      milliseconds:
                                                                          50),
                                                                  () {
                                                                clearImage();
                                                                selected = 0;
                                                              });
                                                            },
                                                            child: const Icon(
                                                                Icons.delete,
                                                                color: Colors
                                                                    .grey),
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
                                        : _videoUrlController.text.isEmpty
                                            ? Container()
                                            : LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  // if (kIsWeb &&
                                                  //     constraints.maxWidth > 800) {
                                                  //   return Row(
                                                  //     crossAxisAlignment:
                                                  //         CrossAxisAlignment.start,
                                                  //     children: const [
                                                  //       Expanded(child: player),
                                                  //       SizedBox(
                                                  //         width: 500,
                                                  //       ),
                                                  //     ],
                                                  //   );
                                                  // }
                                                  return SizedBox(
                                                    // width: MediaQuery.of(context)
                                                    //         .size
                                                    //         .width *
                                                    //     0.9,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              100,
                                                          child: Stack(
                                                            children: [
                                                              player,
                                                              Positioned.fill(
                                                                child:
                                                                    YoutubeValueBuilder(
                                                                  controller:
                                                                      controller,
                                                                  builder:
                                                                      (context,
                                                                          value) {
                                                                    return AnimatedCrossFade(
                                                                      crossFadeState: value.isReady
                                                                          ? CrossFadeState
                                                                              .showSecond
                                                                          : CrossFadeState
                                                                              .showFirst,
                                                                      duration: const Duration(
                                                                          milliseconds:
                                                                              300),
                                                                      secondChild:
                                                                          const SizedBox
                                                                              .shrink(),
                                                                      firstChild:
                                                                          Material(
                                                                        child:
                                                                            DecoratedBox(
                                                                          // ignore: sort_child_properties_last
                                                                          child:
                                                                              const Center(
                                                                            child:
                                                                                CircularProgressIndicator(),
                                                                          ),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            image:
                                                                                DecorationImage(
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
                                                                color: Colors
                                                                    .transparent,
                                                                shape:
                                                                    const CircleBorder(),
                                                                child: InkWell(
                                                                  customBorder:
                                                                      const CircleBorder(),
                                                                  splashColor: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.3),
                                                                  onTap: () {
                                                                    Future.delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                50),
                                                                        () {
                                                                      _selectYoutube(
                                                                          context);
                                                                    });
                                                                  },
                                                                  child: const Icon(
                                                                      Icons
                                                                          .change_circle,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 40,
                                                              height: 40,
                                                              child: Material(
                                                                color: Colors
                                                                    .transparent,
                                                                shape:
                                                                    const CircleBorder(),
                                                                child: InkWell(
                                                                  customBorder:
                                                                      const CircleBorder(),
                                                                  splashColor: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.3),
                                                                  onTap: () {
                                                                    Future.delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                50),
                                                                        () {
                                                                      clearVideoUrl();
                                                                      setState(
                                                                          () {
                                                                        selected =
                                                                            0;
                                                                      });
                                                                    });
                                                                  },
                                                                  child: const Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: Colors
                                                                          .grey),
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
                                                    .text.isNotEmpty ||
                                                _file != null
                                            ? 20
                                            : 0)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          PhysicalModel(
                            elevation: 3,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                // border: Border.all(
                                //     color: const Color.fromARGB(255, 210, 210, 210),
                                //     width: 1.5),
                              ),
                              child: Consumer<CreatePageProvider>(
                                  builder: (context, createProvider, child) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Autocomplete<String>(
                                      optionsViewBuilder:
                                          (context, onSelected, options) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 4.0),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Material(
                                              elevation: 4.0,
                                              child: ConstrainedBox(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxHeight: 200),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: options.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final dynamic option =
                                                        options
                                                            .elementAt(index);
                                                    return TextButton(
                                                      onPressed: () {
                                                        onSelected(option);
                                                      },
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      15.0),
                                                          child: Text(
                                                            '$option',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style:
                                                                const TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      74,
                                                                      137,
                                                                      92),
                                                            ),
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
                                          (TextEditingValue textEditingValue) {
                                        if (textEditingValue.text == '') {
                                          return const Iterable<String>.empty();
                                        }
                                        return _pickLanguage
                                            .where((String option) {
                                          return option.contains(
                                              textEditingValue.text
                                                  .toLowerCase());
                                        });
                                      },
                                      onSelected: (String selectedTag) {
                                        keywordMessageController.addTag =
                                            selectedTag;
                                      },
                                      fieldViewBuilder: (context, ttec, tfn,
                                          onFieldSubmitted) {
                                        return Stack(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14.0),
                                              child: Container(
                                                height: 46,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(5.0),
                                                  ),
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1),
                                                ),
                                                child: TextFieldTags(
                                                  textEditingController: ttec,
                                                  focusNode: tfn,
                                                  // textfieldTagsController:
                                                  //     keywordMessageController,
                                                  initialTags: const [],
                                                  textSeparators: const [
                                                    ' ',
                                                    ',',
                                                  ],
                                                  letterCase: LetterCase.normal,
                                                  inputfieldBuilder: (context,
                                                      tec,
                                                      fn,
                                                      error,
                                                      onChanged,
                                                      onSubmitted) {
                                                    return ((context, sc, tags,
                                                        onTagDelete) {
                                                      myTags = tags;
                                                      List<String> tagsLower =
                                                          tags;
                                                      tagsLower = tagsLower
                                                          .map((tagLower) =>
                                                              tagLower
                                                                  .toLowerCase())
                                                          .toList();
                                                      myTagsLowerCase =
                                                          tagsLower;
                                                      return Row(
                                                        children: [
                                                          Container(
                                                            constraints: BoxConstraints(
                                                                maxWidth: tags
                                                                            .length <
                                                                        3
                                                                    ? MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2
                                                                    : MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        1.4),
                                                            child:
                                                                SingleChildScrollView(
                                                              controller: sc,
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: tags
                                                                      .map((String
                                                                          tag) {
                                                                    return Container(
                                                                      height:
                                                                          28,
                                                                      decoration: const BoxDecoration(
                                                                          borderRadius: BorderRadius.all(
                                                                            Radius.circular(20.0),
                                                                          ),
                                                                          color: Colors.grey),
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              3,
                                                                          right:
                                                                              3),
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10.0,
                                                                          vertical:
                                                                              4.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          InkWell(
                                                                            child:
                                                                                Text(
                                                                              tag,
                                                                              style: const TextStyle(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 4.0),
                                                                          InkWell(
                                                                            child:
                                                                                const Icon(
                                                                              Icons.cancel,
                                                                              size: 17.0,
                                                                              color: Colors.white,
                                                                            ),
                                                                            onTap:
                                                                                () {
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
                                                              enabled:
                                                                  tags.length <
                                                                      3,
                                                              onTap: () {},
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10.0,
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            10),
                                                                hintText: tags
                                                                        .isNotEmpty
                                                                    ? ''
                                                                    : "Add up to 3 keywords (optional)",
                                                                hintStyle: const TextStyle(
                                                                    // fontStyle:
                                                                    //     FontStyle
                                                                    //         .italic,
                                                                    color: Colors.grey,
                                                                    fontSize: 15),
                                                                errorText:
                                                                    error,
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                              ),
                                                              onChanged:
                                                                  onChanged,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5,
                                                                    right: 5),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                const Icon(
                                                                    Icons.key,
                                                                    color: Colors
                                                                        .grey),
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
                                                                        style:
                                                                            const TextStyle(
                                                                          // fontStyle: FontStyle.italic,
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.grey,
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
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                    Container(height: 3.5),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 30,
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              splashColor:
                                                  Colors.grey.withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              onTap: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 100),
                                                    () async {
                                                  // setState(() {
                                                  //   showTrendingMessage =
                                                  //       !showTrendingMessage;
                                                  // });
                                                  await createProvider
                                                      .setShowTrendingMessage(
                                                          !createProvider
                                                              .showTrendingMessage);
                                                  if (createProvider
                                                          .showTrendingMessage ==
                                                      true) {
                                                    createProvider
                                                        .getkeywordList(
                                                      global,
                                                      user?.aaCountry ?? "",
                                                      widget.durationInDay,
                                                    );
                                                  }
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(width: 10),
                                                  const Text(
                                                      'View trending keywords',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 13)),
                                                  Icon(
                                                    createProvider
                                                            .showTrendingMessage
                                                        ? Icons.arrow_drop_up
                                                        : Icons.arrow_drop_down,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 0),
                                            child: Material(
                                              color: Colors.white,
                                              shape: const CircleBorder(),
                                              child: InkWell(
                                                customBorder:
                                                    const CircleBorder(),
                                                splashColor: Colors.grey
                                                    .withOpacity(0.5),
                                                onTap: () {
                                                  Future.delayed(
                                                    const Duration(
                                                        milliseconds: 50),
                                                    () {
                                                      keywordsDialog(
                                                          context: context);
                                                    },
                                                  );
                                                },
                                                child: const SizedBox(
                                                  height: 32,
                                                  width: 38,
                                                  child: Icon(
                                                      Icons.help_outline,
                                                      size: 20,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // SizedBox(
                                    //     height: createProvider.showTrendingMessage
                                    //         ? 0
                                    //         : 3.5),
                                    createProvider.showTrendingMessage
                                        ? createProvider.Loading == true
                                            ? const SizedBox(
                                                height: 223,
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: SizedBox(
                                                  height: createProvider
                                                              .postKeywordListCount ==
                                                          1
                                                      ? 200
                                                      : 223,
                                                  child: FutureBuilder(
                                                    builder:
                                                        (BuildContext context,
                                                            snapshot) {
                                                      return createProvider
                                                              .list.isNotEmpty
                                                          ? SingleChildScrollView(
                                                              child: Column(
                                                                children: [
                                                                  createProvider
                                                                              .postKeywordListCount >
                                                                          1
                                                                      ? Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Material(
                                                                              color: Colors.transparent,
                                                                              child: InkWell(
                                                                                  borderRadius: BorderRadius.circular(25),
                                                                                  splashColor: Colors.blue.withOpacity(0.2),
                                                                                  onTap: () {
                                                                                    Future.delayed(const Duration(milliseconds: 100), () {
                                                                                      createProvider.getkeywordList(global, user!.aaCountry, widget.durationInDay, getNextList1: false);
                                                                                    });
                                                                                  },
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.symmetric(
                                                                                      vertical: 4,
                                                                                      horizontal: 8,
                                                                                    ),
                                                                                    child: Text('View ${((createProvider.postKeywordListCount - 2) * 10) + 1} - ${(createProvider.postKeywordListCount - 1) * 10}',
                                                                                        style: const TextStyle(
                                                                                          color: Colors.blue,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: 13,
                                                                                          letterSpacing: 0,
                                                                                        )),
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : const SizedBox(),
                                                                  const SizedBox(
                                                                      height:
                                                                          4),
                                                                  ListView
                                                                      .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                    itemCount:
                                                                        createProvider
                                                                            .list
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                                index) =>
                                                                            Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              1),
                                                                      child: NoRadioListTile<
                                                                              String>(
                                                                          start: ((((createProvider.postKeywordListCount - 1) * 10) + 1) + index)
                                                                              .toString(),
                                                                          center: createProvider
                                                                              .list[
                                                                                  index]
                                                                              .keyName
                                                                          //     ??
                                                                          // ""
                                                                          ,
                                                                          end: createProvider
                                                                              .list[index]
                                                                              .length
                                                                              .toString()),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          4),
                                                                  createProvider
                                                                              .postKeywordLast ==
                                                                          false
                                                                      ? Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Material(
                                                                              color: Colors.transparent,
                                                                              child: InkWell(
                                                                                  borderRadius: BorderRadius.circular(25),
                                                                                  splashColor: Colors.blue.withOpacity(0.2),
                                                                                  onTap: () {
                                                                                    Future.delayed(const Duration(milliseconds: 100), () {
                                                                                      createProvider.getkeywordList(global, user!.aaCountry, widget.durationInDay, getNextList1: true);
                                                                                    });
                                                                                  },
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.symmetric(
                                                                                      vertical: 4,
                                                                                      horizontal: 8,
                                                                                    ),
                                                                                    child: Text("View ${(createProvider.postKeywordListCount * 10) + 1} - ${(createProvider.postKeywordListCount + 1) * 10}",
                                                                                        style: const TextStyle(
                                                                                          color: Colors.blue,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: 13,
                                                                                          letterSpacing: 0,
                                                                                        )),
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : Container(),
                                                                  const SizedBox(
                                                                    height: 6,
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : const Center(
                                                              child: Text(
                                                                'No trending keywords yet.',
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            183,
                                                                            183,
                                                                            183),
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            );
                                                    },
                                                  ),
                                                ),
                                              )
                                        : Row(),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),

                          // StreamBuilder(
                          //     stream: FirebaseFirestore.instance
                          //         .collection('users')
                          //         .doc(user?.UID)
                          //         .snapshots(),
                          //     builder: (content, snapshot) {
                          //       snap = snapshot.data != null
                          //           ? User.fromSnap(snapshot.data!)
                          //           : snap;

                          //       return
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: user == null
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      PhysicalModel(
                                        elevation: 3,
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(50),
                                        child: Material(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: InkWell(
                                            onTap: () {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 150), () {
                                                performLoggedUserAction(
                                                    context: context,
                                                    action: () {});
                                              });
                                            },
                                            child: SizedBox(
                                              height: 42,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  // border: Border.all(
                                                  //     color: Colors.white,
                                                  //     width: 4),
                                                ),
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.only(
                                                    left: 20, right: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.send,
                                                        color: whiteDialog,
                                                        size: 19),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      global == 'true'
                                                          ? 'Send Message Globally'
                                                          : 'Send Message Nationally',
                                                      style: const TextStyle(
                                                          color: whiteDialog,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          letterSpacing: 0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : user != null && snapshot?.data != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          PhysicalModel(
                                            elevation: 3,
                                            color: whiteDialog,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Material(
                                              color: user == null
                                                  ? Colors.blue
                                                  : snap?.pending == "true" &&
                                                              global ==
                                                                  'false' ||
                                                          snap?.aaCountry ==
                                                                  "" &&
                                                              global ==
                                                                  "false" ||
                                                          snap?.gMessageTime ==
                                                                  widget
                                                                      .durationInDay &&
                                                              global ==
                                                                  'true' ||
                                                          snap?.nMessageTime ==
                                                                  widget
                                                                      .durationInDay &&
                                                              global == 'false'
                                                      ? whiteDialog
                                                      : Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                splashColor: Colors.black
                                                    .withOpacity(0.3),
                                                onTap: () {
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 150),
                                                      () {
                                                    performLoggedUserAction(
                                                        context: context,
                                                        action: () {
                                                          snap?.pending ==
                                                                      "true" &&
                                                                  global ==
                                                                      "false"
                                                              ? voteIfPending(
                                                                  context:
                                                                      context)
                                                              : snap?.aaCountry ==
                                                                          "" &&
                                                                      global ==
                                                                          "false"
                                                                  ? nationalityUnknown(
                                                                      context:
                                                                          context)
                                                                  : snap?.gMessageTime == widget.durationInDay &&
                                                                              global ==
                                                                                  'true' ||
                                                                          snap?.nMessageTime == widget.durationInDay &&
                                                                              global ==
                                                                                  'false'
                                                                      ? sendTimerDialog(
                                                                          context:
                                                                              context,
                                                                          type:
                                                                              'message',
                                                                          type2: global == 'true'
                                                                              ? 'global'
                                                                              : 'national',
                                                                        )
                                                                      : _titleController
                                                                              .text
                                                                              .trim()
                                                                              .isEmpty
                                                                          ? showSnackBarError(
                                                                              'Message field cannot be empty.',
                                                                              context)
                                                                          : postImage(
                                                                              user?.UID ?? '',
                                                                              user?.username ?? '',
                                                                              user?.photoUrl ?? '',
                                                                              global == 'true' ? '' : snap?.aaCountry ?? '',
                                                                            );
                                                        });
                                                  });
                                                },
                                                child: SizedBox(
                                                  height: 42,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      // border: Border.all(
                                                      //   color: darkBlue,
                                                      //   width: 0,
                                                      // ),
                                                    ),
                                                    alignment: Alignment.center,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                            snap?.pending ==
                                                                            "true" &&
                                                                        global ==
                                                                            'false' ||
                                                                    snap?.gMessageTime ==
                                                                            widget
                                                                                .durationInDay &&
                                                                        global ==
                                                                            'true' ||
                                                                    snap?.nMessageTime ==
                                                                            widget
                                                                                .durationInDay &&
                                                                        global ==
                                                                            'false'
                                                                ? Icons.timer
                                                                : Icons.send,
                                                            color: snap?.pending ==
                                                                            "true" &&
                                                                        global ==
                                                                            'false' ||
                                                                    snap?.aaCountry ==
                                                                            "" &&
                                                                        global ==
                                                                            "false" ||
                                                                    snap?.gMessageTime ==
                                                                            widget
                                                                                .durationInDay &&
                                                                        global ==
                                                                            'true' ||
                                                                    snap?.nMessageTime ==
                                                                            widget
                                                                                .durationInDay &&
                                                                        global ==
                                                                            'false'
                                                                ? darkBlue
                                                                : whiteDialog,
                                                            size: 18),
                                                        const SizedBox(
                                                            width: 10),
                                                        snap?.gMessageTime ==
                                                                        widget
                                                                            .durationInDay &&
                                                                    global ==
                                                                        'true' ||
                                                                snap?.nMessageTime ==
                                                                        widget
                                                                            .durationInDay &&
                                                                    global ==
                                                                        'false'
                                                            ? Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: const [
                                                                  Text(
                                                                    'Waiting Time',
                                                                    style: TextStyle(
                                                                        color:
                                                                            darkBlue,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            16,
                                                                        letterSpacing:
                                                                            0),
                                                                  ),
                                                                  // Text(
                                                                  //   'Timer refreshes at 12:01AM EST',
                                                                  //   style: TextStyle(
                                                                  //       color: Colors
                                                                  //           .white,
                                                                  //       fontWeight:
                                                                  //           FontWeight
                                                                  //               .bold,
                                                                  //       fontSize:
                                                                  //           9,
                                                                  //       letterSpacing:
                                                                  //           0.2),
                                                                  // ),
                                                                ],
                                                              )
                                                            : Text(
                                                                snap?.pending ==
                                                                            "true" &&
                                                                        global ==
                                                                            'false'
                                                                    ? 'Verification Pending'
                                                                    : snap?.aaCountry ==
                                                                                "" &&
                                                                            global ==
                                                                                "false"
                                                                        ? 'Nationality Unknown'
                                                                        : global ==
                                                                                'true'
                                                                            ? 'Send Message Globally'
                                                                            : 'Send Message Nationally',
                                                                style: TextStyle(
                                                                    color: snap?.pending == "true" && global == 'false' ||
                                                                            snap?.aaCountry == "" &&
                                                                                global ==
                                                                                    "false"
                                                                        ? darkBlue
                                                                        : whiteDialog,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                    letterSpacing:
                                                                        0),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                          )
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Column(
                        children: [
                          // _isLoading
                          //     ? const LinearProgressIndicator()
                          //     : const Padding(padding: EdgeInsets.only(top: 0)),
                          // const Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PhysicalModel(
                                  elevation: 3,
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.transparent,
                                  child: Container(
                                    // width: MediaQuery.of(context).size.width - 20,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        // emptyPollQuestion == true
                                        //     ? Column(
                                        //         children: [
                                        //           Container(height: 6),
                                        //           Row(
                                        //             mainAxisAlignment:
                                        //                 MainAxisAlignment.center,
                                        //             children: [
                                        //               const Icon(Icons.error,
                                        //                   size: 16,
                                        //                   color: Color.fromARGB(
                                        //                       255, 220, 105, 96)),
                                        //               Container(width: 4),
                                        //               const Text(
                                        //                 'Poll question cannot be blank.',
                                        //                 style: TextStyle(
                                        //                   color: Color.fromARGB(
                                        //                       255, 220, 105, 96),
                                        //                 ),
                                        //               ),
                                        //             ],
                                        //           ),
                                        //         ],
                                        //       )
                                        //     : Container(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 20.0, top: 20),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: WillPopScope(
                                              onWillPop: () async {
                                                return false;
                                              },
                                              child: Stack(
                                                children: [
                                                  TextField(
                                                    maxLength:
                                                        _pollQuestionTextfieldMaxLength,
                                                    onChanged: (val) {
                                                      setState(() {});
                                                    },
                                                    controller: _pollController,
                                                    onTap: () {},
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: "Create a poll",
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.blue,
                                                            width: 2),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 0,
                                                              left: 4,
                                                              right: 45,
                                                              bottom: 8),
                                                      isDense: true,
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                      ),
                                                      labelStyle: TextStyle(
                                                          color: Colors.black),
                                                      counterText: '',
                                                    ),
                                                    maxLines: null,
                                                  ),
                                                  Positioned(
                                                    bottom: 5,
                                                    right: 0,
                                                    child: Text(
                                                      '${_pollController.text.length}/$_pollQuestionTextfieldMaxLength',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: _pollController
                                                                    .text
                                                                    .length ==
                                                                _pollQuestionTextfieldMaxLength
                                                            ? const Color
                                                                    .fromARGB(
                                                                255,
                                                                220,
                                                                105,
                                                                96)
                                                            : Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              // emptyOptionOne || emptyOptionTwo
                                              //     ? Padding(
                                              //         padding: const EdgeInsets.only(
                                              //             bottom: 4.0),
                                              //         child: Row(
                                              //           mainAxisAlignment:
                                              //               MainAxisAlignment.center,
                                              //           children: [
                                              //             const Icon(Icons.error,
                                              //                 size: 16,
                                              //                 color: Color.fromARGB(
                                              //                     255, 220, 105, 96)),
                                              //             Container(width: 6),
                                              //             const Text(
                                              //                 'First two poll options cannot be blank.',
                                              //                 style: TextStyle(
                                              //                     color: Color.fromARGB(
                                              //                         255,
                                              //                         220,
                                              //                         105,
                                              //                         96))),
                                              //           ],
                                              //         ),
                                              //       )
                                              //     : Container(),
                                              Stack(
                                                children: [
                                                  TextField(
                                                    maxLength:
                                                        _optionTextfieldMaxLength,
                                                    onChanged: (val) {
                                                      setState(() {});
                                                    },
                                                    controller: _optionOne,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      counter: Container(),
                                                      labelText: "Option #1",
                                                      labelStyle:
                                                          const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                      ),
                                                      // hintText: "Option #$ic",
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    Colors.blue,
                                                                width: 2.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      border: InputBorder.none,
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                  Positioned(
                                                    bottom: 12,
                                                    right: 6,
                                                    child: Text(
                                                      '${_optionOne.text.length}/$_optionTextfieldMaxLength',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: _optionOne.text
                                                                    .length ==
                                                                _optionTextfieldMaxLength
                                                            ? const Color
                                                                    .fromARGB(
                                                                255,
                                                                220,
                                                                105,
                                                                96)
                                                            : Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Stack(
                                                children: [
                                                  TextField(
                                                    maxLength:
                                                        _optionTextfieldMaxLength,
                                                    onChanged: (val) {
                                                      setState(() {});
                                                    },
                                                    controller: _optionTwo,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      counter: Container(),
                                                      labelText: "Option #2",
                                                      labelStyle:
                                                          const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                      ),
                                                      // hintText: "Option #$ic",
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    Colors.blue,
                                                                width: 2.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      border: InputBorder.none,
                                                      // fillColor: Colors.white,
                                                      // filled: true,
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                  Positioned(
                                                    bottom: 12,
                                                    right: 6,
                                                    child: Text(
                                                      '${_optionTwo.text.length}/$_optionTextfieldMaxLength',
                                                      style: TextStyle(
                                                        // fontStyle: FontStyle.italic,
                                                        fontSize: 12,
                                                        color: _optionTwo.text
                                                                    .length ==
                                                                _optionTextfieldMaxLength
                                                            ? const Color
                                                                    .fromARGB(
                                                                255,
                                                                220,
                                                                105,
                                                                96)
                                                            : Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Visibility(
                                                visible: visiblityThree,
                                                child: Stack(
                                                  children: [
                                                    TextField(
                                                      maxLength:
                                                          _optionTextfieldMaxLength,
                                                      onChanged: (val) {
                                                        setState(() {});
                                                      },
                                                      controller: _optionThree,
                                                      decoration:
                                                          InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors
                                                                  .white,
                                                              counter:
                                                                  Container(),
                                                              labelText:
                                                                  "Option #3 (optional)",
                                                              labelStyle:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              // hintText: "Option #$ic",
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              suffixIcon:
                                                                  IconButton(
                                                                icon:
                                                                    const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              10.0,
                                                                          left:
                                                                              6),
                                                                  child: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 22,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if (visibleOptions ==
                                                                        3) {
                                                                      visiblityThree =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionThree
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        4) {
                                                                      visiblityFour =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionFour
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        5) {
                                                                      visiblityFive =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionFive
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        6) {
                                                                      visiblitySix =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionSix
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        7) {
                                                                      visiblitySeven =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionSeven
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        8) {
                                                                      visiblityEight =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionEight
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        9) {
                                                                      visiblityNine =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionNine
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        10) {
                                                                      visiblityTen =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionTen
                                                                          .clear();
                                                                    } else {}
                                                                  });
                                                                },
                                                              )),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                    Positioned(
                                                      bottom: 12,
                                                      right: 6,
                                                      child: Text(
                                                        '${_optionThree.text.length}/$_optionTextfieldMaxLength',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: _optionThree
                                                                      .text
                                                                      .length ==
                                                                  _optionTextfieldMaxLength
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  220,
                                                                  105,
                                                                  96)
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: visiblityFour,
                                                child: Stack(
                                                  children: [
                                                    TextField(
                                                      maxLength:
                                                          _optionTextfieldMaxLength,
                                                      onChanged: (val) {
                                                        setState(() {});
                                                      },
                                                      controller: _optionFour,
                                                      decoration:
                                                          InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors
                                                                  .white,
                                                              counter:
                                                                  Container(),
                                                              labelText:
                                                                  "Option #4 (optional)",
                                                              labelStyle:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              suffixIcon:
                                                                  IconButton(
                                                                icon:
                                                                    const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              10.0,
                                                                          left:
                                                                              6),
                                                                  child: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 22,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if (visibleOptions ==
                                                                        3) {
                                                                      visiblityThree =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionThree
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        4) {
                                                                      visiblityFour =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionFour
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        5) {
                                                                      visiblityFive =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionFive
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        6) {
                                                                      visiblitySix =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionSix
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        7) {
                                                                      visiblitySeven =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionSeven
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        8) {
                                                                      visiblityEight =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionEight
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        9) {
                                                                      visiblityNine =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionNine
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        10) {
                                                                      visiblityTen =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionTen
                                                                          .clear();
                                                                    } else {}
                                                                  });
                                                                },
                                                              )),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                    Positioned(
                                                      bottom: 12,
                                                      right: 6,
                                                      child: Text(
                                                        '${_optionFour.text.length}/$_optionTextfieldMaxLength',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: _optionFour
                                                                      .text
                                                                      .length ==
                                                                  _optionTextfieldMaxLength
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  220,
                                                                  105,
                                                                  96)
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: visiblityFive,
                                                child: Stack(
                                                  children: [
                                                    TextField(
                                                      maxLength:
                                                          _optionTextfieldMaxLength,
                                                      onChanged: (val) {
                                                        setState(() {});
                                                      },
                                                      controller: _optionFive,
                                                      decoration:
                                                          InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors
                                                                  .white,
                                                              counter:
                                                                  Container(),
                                                              labelText:
                                                                  "Option #5 (optional)",
                                                              labelStyle:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              // hintText: "Option #$ic",
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              suffixIcon:
                                                                  IconButton(
                                                                icon:
                                                                    const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              6,
                                                                          bottom:
                                                                              10.0),
                                                                  child: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 22,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if (visibleOptions ==
                                                                        3) {
                                                                      visiblityThree =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionThree
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        4) {
                                                                      visiblityFour =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionFour
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        5) {
                                                                      visiblityFive =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionFive
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        6) {
                                                                      visiblitySix =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionSix
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        7) {
                                                                      visiblitySeven =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionSeven
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        8) {
                                                                      visiblityEight =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionEight
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        9) {
                                                                      visiblityNine =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionNine
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        10) {
                                                                      visiblityTen =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionTen
                                                                          .clear();
                                                                    } else {}
                                                                  });
                                                                },
                                                              )),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                    Positioned(
                                                      bottom: 12,
                                                      right: 6,
                                                      child: Text(
                                                        '${_optionFive.text.length}/$_optionTextfieldMaxLength',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: _optionFive
                                                                      .text
                                                                      .length ==
                                                                  _optionTextfieldMaxLength
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  220,
                                                                  105,
                                                                  96)
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: visiblitySix,
                                                child: Stack(
                                                  children: [
                                                    TextField(
                                                      maxLength:
                                                          _optionTextfieldMaxLength,
                                                      onChanged: (val) {
                                                        setState(() {});
                                                      },
                                                      controller: _optionSix,
                                                      decoration:
                                                          InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors
                                                                  .white,
                                                              counter:
                                                                  Container(),
                                                              labelText:
                                                                  "Option #6 (optional)",
                                                              labelStyle:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              // hintText: "Option #$ic",
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              suffixIcon:
                                                                  IconButton(
                                                                icon:
                                                                    const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              10,
                                                                          left:
                                                                              6),
                                                                  child: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 22,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if (visibleOptions ==
                                                                        3) {
                                                                      visiblityThree =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionThree
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        4) {
                                                                      visiblityFour =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionFour
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        5) {
                                                                      visiblityFive =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionFive
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        6) {
                                                                      visiblitySix =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionSix
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        7) {
                                                                      visiblitySeven =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionSeven
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        8) {
                                                                      visiblityEight =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionEight
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        9) {
                                                                      visiblityNine =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionNine
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        10) {
                                                                      visiblityTen =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionTen
                                                                          .clear();
                                                                    } else {}
                                                                  });
                                                                },
                                                              )),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                    Positioned(
                                                      bottom: 12,
                                                      right: 6,
                                                      child: Text(
                                                        '${_optionSix.text.length}/$_optionTextfieldMaxLength',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: _optionSix.text
                                                                      .length ==
                                                                  _optionTextfieldMaxLength
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  220,
                                                                  105,
                                                                  96)
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: visiblitySeven,
                                                child: Stack(
                                                  children: [
                                                    TextField(
                                                      maxLength:
                                                          _optionTextfieldMaxLength,
                                                      onChanged: (val) {
                                                        setState(() {});
                                                      },
                                                      controller: _optionSeven,
                                                      decoration:
                                                          InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors
                                                                  .white,
                                                              counter:
                                                                  Container(),
                                                              labelText:
                                                                  "Option #7 (optional)",
                                                              labelStyle:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              // hintText: "Option #$ic",
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              suffixIcon:
                                                                  IconButton(
                                                                icon:
                                                                    const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              6,
                                                                          bottom:
                                                                              10),
                                                                  child: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 22,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if (visibleOptions ==
                                                                        3) {
                                                                      visiblityThree =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionThree
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        4) {
                                                                      visiblityFour =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionFour
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        5) {
                                                                      visiblityFive =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionFive
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        6) {
                                                                      visiblitySix =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionSix
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        7) {
                                                                      visiblitySeven =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionSeven
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        8) {
                                                                      visiblityEight =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionEight
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        9) {
                                                                      visiblityNine =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionNine
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        10) {
                                                                      visiblityTen =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionTen
                                                                          .clear();
                                                                    } else {}
                                                                  });
                                                                },
                                                              )),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                    Positioned(
                                                      bottom: 12,
                                                      right: 6,
                                                      child: Text(
                                                        '${_optionSeven.text.length}/$_optionTextfieldMaxLength',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: _optionSeven
                                                                      .text
                                                                      .length ==
                                                                  _optionTextfieldMaxLength
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  220,
                                                                  105,
                                                                  96)
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: visiblityEight,
                                                child: Stack(
                                                  children: [
                                                    TextField(
                                                      maxLength:
                                                          _optionTextfieldMaxLength,
                                                      onChanged: (val) {
                                                        setState(() {});
                                                      },
                                                      controller: _optionEight,
                                                      decoration:
                                                          InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors
                                                                  .white,
                                                              counter:
                                                                  Container(),
                                                              labelText:
                                                                  "Option #8 (optional)",
                                                              labelStyle:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              // hintText: "Option #$ic",
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              suffixIcon:
                                                                  IconButton(
                                                                icon:
                                                                    const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              6.0,
                                                                          bottom:
                                                                              10),
                                                                  child: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 22,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if (visibleOptions ==
                                                                        3) {
                                                                      visiblityThree =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionThree
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        4) {
                                                                      visiblityFour =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionFour
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        5) {
                                                                      visiblityFive =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionFive
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        6) {
                                                                      visiblitySix =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionSix
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        7) {
                                                                      visiblitySeven =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionSeven
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        8) {
                                                                      visiblityEight =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionEight
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        9) {
                                                                      visiblityNine =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionNine
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        10) {
                                                                      visiblityTen =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionTen
                                                                          .clear();
                                                                    } else {}
                                                                  });
                                                                },
                                                              )),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                    Positioned(
                                                      bottom: 12,
                                                      right: 6,
                                                      child: Text(
                                                        '${_optionEight.text.length}/$_optionTextfieldMaxLength',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: _optionEight
                                                                      .text
                                                                      .length ==
                                                                  _optionTextfieldMaxLength
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  220,
                                                                  105,
                                                                  96)
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: visiblityNine,
                                                child: Stack(
                                                  children: [
                                                    TextField(
                                                      maxLength:
                                                          _optionTextfieldMaxLength,
                                                      onChanged: (val) {
                                                        setState(() {});
                                                      },
                                                      controller: _optionNine,
                                                      decoration:
                                                          InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors
                                                                  .white,
                                                              counter:
                                                                  Container(),
                                                              labelText:
                                                                  "Option #9 (optional)",
                                                              labelStyle:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              // hintText: "Option #$ic",
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              suffixIcon:
                                                                  IconButton(
                                                                icon:
                                                                    const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              6,
                                                                          bottom:
                                                                              10),
                                                                  child: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 22,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if (visibleOptions ==
                                                                        3) {
                                                                      visiblityThree =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionThree
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        4) {
                                                                      visiblityFour =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionFour
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        5) {
                                                                      visiblityFive =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionFive
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        6) {
                                                                      visiblitySix =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionSix
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        7) {
                                                                      visiblitySeven =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionSeven
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        8) {
                                                                      visiblityEight =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionEight
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        9) {
                                                                      visiblityNine =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionNine
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        10) {
                                                                      visiblityTen =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionTen
                                                                          .clear();
                                                                    } else {}
                                                                  });
                                                                },
                                                              )),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                    Positioned(
                                                      bottom: 12,
                                                      right: 6,
                                                      child: Text(
                                                        '${_optionNine.text.length}/$_optionTextfieldMaxLength',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: _optionNine
                                                                      .text
                                                                      .length ==
                                                                  _optionTextfieldMaxLength
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  220,
                                                                  105,
                                                                  96)
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: visiblityTen,
                                                child: Stack(
                                                  children: [
                                                    TextField(
                                                      maxLength:
                                                          _optionTextfieldMaxLength,
                                                      onChanged: (val) {
                                                        setState(() {});
                                                      },
                                                      controller: _optionTen,
                                                      decoration:
                                                          InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors
                                                                  .white,
                                                              counter:
                                                                  Container(),
                                                              labelText:
                                                                  "Option #10 (optional)",
                                                              labelStyle:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              // hintText: "Option #$ic",
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              suffixIcon:
                                                                  IconButton(
                                                                icon:
                                                                    const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              6,
                                                                          bottom:
                                                                              10),
                                                                  child: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 22,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if (visibleOptions ==
                                                                        3) {
                                                                      visiblityThree =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionThree
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        4) {
                                                                      visiblityFour =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionFour
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        5) {
                                                                      visiblityFive =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionFive
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        6) {
                                                                      visiblitySix =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionSix
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        7) {
                                                                      visiblitySeven =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionSeven
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        8) {
                                                                      visiblityEight =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionEight
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        9) {
                                                                      visiblityNine =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionNine
                                                                          .clear();
                                                                    } else if (visibleOptions ==
                                                                        10) {
                                                                      visiblityTen =
                                                                          false;
                                                                      visibleOptions =
                                                                          visibleOptions -
                                                                              1;
                                                                      _optionTen
                                                                          .clear();
                                                                    } else {}
                                                                  });
                                                                },
                                                              )),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                    Positioned(
                                                      bottom: 12,
                                                      right: 6,
                                                      child: Text(
                                                        '${_optionTen.text.length}/$_optionTextfieldMaxLength',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: _optionTen.text
                                                                      .length ==
                                                                  _optionTextfieldMaxLength
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  220,
                                                                  105,
                                                                  96)
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: i,
                                                  itemBuilder:
                                                      (context, index) {
                                                    _cont!.add(
                                                        TextEditingController());
                                                    int ic = index + 3;
                                                    return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          // right: 10,
                                                          // left: 10,
                                                          top: 6,
                                                        ),
                                                        child: Stack(
                                                          children: [
                                                            TextField(
                                                              maxLength:
                                                                  _optionTextfieldMaxLength,
                                                              onChanged: (val) {
                                                                setState(() {});
                                                                // setState(() {
                                                                //   emptyOptionOne ==
                                                                //           true
                                                                //       ? emptyOptionOne =
                                                                //           false
                                                                //       : null;
                                                                //   emptyOptionTwo ==
                                                                //           true
                                                                //       ? emptyOptionTwo =
                                                                //           false
                                                                //       : null;
                                                                // });
                                                              },
                                                              controller:
                                                                  _cont![index],
                                                              onTap: () {},
                                                              decoration:
                                                                  InputDecoration(
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                counter:
                                                                    Container(),
                                                                labelText: index ==
                                                                            0 ||
                                                                        index ==
                                                                            1
                                                                    // ? "Option #${ic} (optional)"
                                                                    // : "Option #${ic} (optional)",
                                                                    ? "Option #$ic"
                                                                    : "Option #$ic (optional)",
                                                                labelStyle:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                suffixIcon: i ==
                                                                        0
                                                                    ? const Icon(
                                                                        Icons
                                                                            .cancel,
                                                                        color: Colors
                                                                            .transparent)
                                                                    : InkWell(
                                                                        onTap:
                                                                            () {
                                                                          if (i >=
                                                                              1) {
                                                                            setState(() {
                                                                              i = i - 1;

                                                                              _cont![index].clear();
                                                                            });

                                                                            if (index !=
                                                                                i) {
                                                                              if (_cont![i - 1].text.isEmpty) {
                                                                                _cont![i - 1].text = _cont![i].text;
                                                                              }
                                                                            }
                                                                          }
                                                                        },
                                                                        child:
                                                                            const Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left: 8.0,
                                                                              bottom: 14),
                                                                          child:
                                                                              Icon(
                                                                            Icons.delete,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .blue,
                                                                      width:
                                                                          2.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                              ),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                              maxLines: 1,
                                                            ),
                                                            Positioned(
                                                              bottom: 12,
                                                              right: 6,
                                                              child: Text(
                                                                '${_cont![index].text.length}/$_optionTextfieldMaxLength',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: _cont![index]
                                                                              .text
                                                                              .length ==
                                                                          _optionTextfieldMaxLength
                                                                      ? const Color
                                                                              .fromARGB(
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
                                                        ));
                                                  }),
                                            ],
                                          ),
                                        ),
                                        visibleOptions == 10
                                            ? const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 15, bottom: 19),
                                                child: Text(
                                                    'MAXIMUM OPTIONS REACHED',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 85, 85, 85),
                                                        fontSize: 13)),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0, bottom: 6),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        splashColor: Colors
                                                            .blueAccent
                                                            .withOpacity(0.3),
                                                        onTap: () {
                                                          Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      150), () {
                                                            setState(() {
                                                              if (visibleOptions ==
                                                                  2) {
                                                                visiblityThree =
                                                                    true;
                                                                visibleOptions =
                                                                    visibleOptions +
                                                                        1;
                                                              } else if (visibleOptions ==
                                                                  3) {
                                                                visiblityFour =
                                                                    true;
                                                                visibleOptions =
                                                                    visibleOptions +
                                                                        1;
                                                              } else if (visibleOptions ==
                                                                  4) {
                                                                visiblityFive =
                                                                    true;
                                                                visibleOptions =
                                                                    visibleOptions +
                                                                        1;
                                                              } else if (visibleOptions ==
                                                                  5) {
                                                                visiblitySix =
                                                                    true;
                                                                visibleOptions =
                                                                    visibleOptions +
                                                                        1;
                                                              } else if (visibleOptions ==
                                                                  6) {
                                                                visiblitySeven =
                                                                    true;
                                                                visibleOptions =
                                                                    visibleOptions +
                                                                        1;
                                                              } else if (visibleOptions ==
                                                                  7) {
                                                                visiblityEight =
                                                                    true;
                                                                visibleOptions =
                                                                    visibleOptions +
                                                                        1;
                                                              } else if (visibleOptions ==
                                                                  8) {
                                                                visiblityNine =
                                                                    true;
                                                                visibleOptions =
                                                                    visibleOptions +
                                                                        1;
                                                              } else if (visibleOptions ==
                                                                  9) {
                                                                visiblityTen =
                                                                    true;
                                                                visibleOptions =
                                                                    visibleOptions +
                                                                        1;
                                                              } else {}
                                                            });
                                                          });
                                                        },
                                                        child: SizedBox(
                                                          height: 45,
                                                          child: Row(
                                                            children: const [
                                                              Icon(
                                                                Icons
                                                                    .add_circle_outline,
                                                                color:
                                                                    Colors.blue,
                                                                size: 27,
                                                              ),
                                                              SizedBox(
                                                                  width: 5),
                                                              Text('ADD OPTION',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  )),
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
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: PhysicalModel(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    elevation: 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Consumer<CreatePageProvider>(
                                          builder:
                                              (context, createProvider, child) {
                                        return Column(
                                          children: [
                                            const SizedBox(height: 20),
                                            Autocomplete<String>(
                                              optionsViewBuilder: (context,
                                                  onSelected, options) {
                                                return Container(
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 4.0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Material(
                                                      elevation: 4.0,
                                                      child: ConstrainedBox(
                                                        constraints:
                                                            const BoxConstraints(
                                                                maxHeight: 200),
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              options.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            final dynamic
                                                                option = options
                                                                    .elementAt(
                                                                        index);
                                                            return TextButton(
                                                              onPressed: () {
                                                                onSelected(
                                                                    option);
                                                              },
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          15.0),
                                                                  child: Text(
                                                                    '$option',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
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
                                              optionsBuilder: (TextEditingValue
                                                  textEditingValue) {
                                                if (textEditingValue.text ==
                                                    '') {
                                                  return const Iterable<
                                                      String>.empty();
                                                }
                                                return _pickLanguage
                                                    .where((String option) {
                                                  return option.contains(
                                                      textEditingValue.text
                                                          .toLowerCase());
                                                });
                                              },
                                              onSelected: (String selectedTag) {
                                                keywordMessageController
                                                    .addTag = selectedTag;
                                              },
                                              fieldViewBuilder: (context, ttec,
                                                  tfn, onFieldSubmitted) {
                                                return Stack(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 14),
                                                      child: Container(
                                                        height: 46,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(
                                                                5.0),
                                                          ),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 1),
                                                        ),
                                                        child: TextFieldTags(
                                                          textEditingController:
                                                              ttec,
                                                          focusNode: tfn,
                                                          // textfieldTagsController:
                                                          //     keywordMessageController,
                                                          initialTags: const [],
                                                          textSeparators: const [
                                                            ' ',
                                                            ','
                                                          ],
                                                          letterCase:
                                                              LetterCase.normal,
                                                          inputfieldBuilder:
                                                              (context,
                                                                  tec,
                                                                  fn,
                                                                  error,
                                                                  onChanged,
                                                                  onSubmitted) {
                                                            return ((context,
                                                                sc,
                                                                tags,
                                                                onTagDelete) {
                                                              myTagsPoll = tags;
                                                              List<String>
                                                                  tagsLower =
                                                                  tags;
                                                              tagsLower = tagsLower
                                                                  .map((tagLower) =>
                                                                      tagLower
                                                                          .toLowerCase())
                                                                  .toList();
                                                              myTagsPollLowerCase =
                                                                  tagsLower;
                                                              return Row(
                                                                children: [
                                                                  Container(
                                                                    constraints: BoxConstraints(
                                                                        maxWidth: tags.length < 3
                                                                            ? MediaQuery.of(context).size.width /
                                                                                2
                                                                            : MediaQuery.of(context).size.width /
                                                                                1.4),
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      controller:
                                                                          sc,
                                                                      scrollDirection:
                                                                          Axis.horizontal,
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
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          tec,
                                                                      focusNode:
                                                                          fn,
                                                                      enabled:
                                                                          tags.length <
                                                                              3,
                                                                      onTap:
                                                                          () {},
                                                                      decoration:
                                                                          InputDecoration(
                                                                        contentPadding: const EdgeInsets.only(
                                                                            top:
                                                                                10.0,
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                0,
                                                                            bottom:
                                                                                10),
                                                                        hintText: tags.isNotEmpty
                                                                            ? ''
                                                                            : "Add up to 3 keywords (optional)",
                                                                        hintStyle: const TextStyle(
                                                                            // fontStyle:
                                                                            //     FontStyle
                                                                            //         .italic,
                                                                            color: Colors.grey,
                                                                            fontSize: 15),
                                                                        errorText:
                                                                            error,
                                                                        border:
                                                                            InputBorder.none,
                                                                      ),
                                                                      onChanged:
                                                                          onChanged,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left: 5,
                                                                        right:
                                                                            5),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        const Icon(
                                                                            Icons
                                                                                .key,
                                                                            color:
                                                                                Colors.grey),
                                                                        tags.length ==
                                                                                3
                                                                            ? Text(
                                                                                '${tags.length}/3',
                                                                                style: const TextStyle(
                                                                                  fontSize: 12,
                                                                                  color: Colors.red,
                                                                                ),
                                                                              )
                                                                            : Text(
                                                                                '${tags.length}/3',
                                                                                style: const TextStyle(
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
                                                      ),
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                            Container(height: 3.5),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(width: 30),
                                                  Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      splashColor: Colors.grey
                                                          .withOpacity(0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      onTap: () {
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    100),
                                                            () async {
                                                          await createProvider
                                                              .setShowTrendingPoll(
                                                            !createProvider
                                                                .showTrendingPoll,
                                                          );
                                                          if (createProvider
                                                                  .showTrendingPoll ==
                                                              true) {
                                                            await createProvider
                                                                .getpollKeywordList(
                                                                    global,
                                                                    user!
                                                                        .aaCountry,
                                                                    widget
                                                                        .durationInDay);
                                                          }
                                                        });
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const SizedBox(
                                                              width: 10),
                                                          const Text(
                                                              'View trending keywords',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      13)),
                                                          Icon(
                                                            showTrendingPoll
                                                                ? Icons
                                                                    .arrow_drop_up
                                                                : Icons
                                                                    .arrow_drop_down,
                                                            color: Colors.grey,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 0),
                                                    child: Material(
                                                      color: Colors.white,
                                                      shape:
                                                          const CircleBorder(),
                                                      child: InkWell(
                                                        customBorder:
                                                            const CircleBorder(),
                                                        splashColor: Colors.grey
                                                            .withOpacity(0.5),
                                                        onTap: () {
                                                          Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    50),
                                                            () {
                                                              keywordsDialog(
                                                                  context:
                                                                      context);
                                                            },
                                                          );
                                                        },
                                                        child: const SizedBox(
                                                          height: 32,
                                                          width: 38,
                                                          child: Icon(
                                                              Icons
                                                                  .help_outline,
                                                              size: 20,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            createProvider.showTrendingPoll
                                                ? createProvider.Loading == true
                                                    ? const SizedBox(
                                                        height: 223,
                                                        child: Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        child: SizedBox(
                                                          height: createProvider
                                                                      .pollKeywordListCount ==
                                                                  1
                                                              ? 200
                                                              : 223,
                                                          child: FutureBuilder(
                                                            builder:
                                                                (BuildContext
                                                                        context,
                                                                    snapshot) {
                                                              return createProvider
                                                                      .listPoll
                                                                      .isNotEmpty
                                                                  ? SingleChildScrollView(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          createProvider.pollKeywordListCount > 1
                                                                              ? Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Material(
                                                                                      color: Colors.transparent,
                                                                                      child: InkWell(
                                                                                          borderRadius: BorderRadius.circular(25),
                                                                                          splashColor: Colors.blue.withOpacity(0.2),
                                                                                          onTap: () {
                                                                                            Future.delayed(const Duration(milliseconds: 100), () {
                                                                                              createProvider.getpollKeywordList(global, user!.aaCountry, widget.durationInDay, getNextListPoll: false);
                                                                                            });
                                                                                          },
                                                                                          child: Container(
                                                                                            padding: const EdgeInsets.symmetric(
                                                                                              vertical: 4,
                                                                                              horizontal: 8,
                                                                                            ),
                                                                                            child: Text('View ${((createProvider.pollKeywordListCount - 2) * 10) + 1} - ${(createProvider.pollKeywordListCount - 1) * 10}',
                                                                                                style: const TextStyle(
                                                                                                  color: Colors.blue,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  fontSize: 13,
                                                                                                  letterSpacing: 0,
                                                                                                )),
                                                                                          )),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              : const SizedBox(),
                                                                          const SizedBox(
                                                                              height: 4),
                                                                          ListView
                                                                              .builder(
                                                                            shrinkWrap:
                                                                                true,
                                                                            physics:
                                                                                const NeverScrollableScrollPhysics(),
                                                                            itemCount:
                                                                                createProvider.listPoll.length,
                                                                            itemBuilder: (context, index) =>
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 1),
                                                                              child: NoRadioListTile<String>(
                                                                                  start: ((((createProvider.pollKeywordListCount - 1) * 10) + 1) + index).toString(),
                                                                                  center: createProvider.listPoll[index].keyName
                                                                                  // ?? ""
                                                                                  ,
                                                                                  end: createProvider.listPoll[index].length.toString()),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 4),
                                                                          createProvider.pollKeywordLast == false
                                                                              ? Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Material(
                                                                                      color: Colors.transparent,
                                                                                      child: InkWell(
                                                                                          borderRadius: BorderRadius.circular(25),
                                                                                          splashColor: Colors.blue.withOpacity(0.2),
                                                                                          onTap: () {
                                                                                            Future.delayed(const Duration(milliseconds: 100), () {
                                                                                              createProvider.getpollKeywordList(global, user!.aaCountry, widget.durationInDay, getNextListPoll: true);
                                                                                            });
                                                                                          },
                                                                                          child: Container(
                                                                                            padding: const EdgeInsets.symmetric(
                                                                                              vertical: 4,
                                                                                              horizontal: 8,
                                                                                            ),
                                                                                            child: Text("View ${(createProvider.pollKeywordListCount * 10) + 1} - ${(createProvider.pollKeywordListCount + 1) * 10}",
                                                                                                style: const TextStyle(
                                                                                                  color: Colors.blue,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  fontSize: 13,
                                                                                                  letterSpacing: 0,
                                                                                                )),
                                                                                          )),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              : Container(),
                                                                          const SizedBox(
                                                                            height:
                                                                                6,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : const Center(
                                                                      child:
                                                                          Text(
                                                                        'No trending keywords yet.',
                                                                        style:
                                                                            TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              183,
                                                                              183,
                                                                              183),
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    );
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                : const SizedBox(),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                PhysicalModel(
                                  elevation: 3,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  child: Material(
                                    color: user == null
                                        ? Colors.blue
                                        : snap?.pending == "true" &&
                                                    global == 'false' ||
                                                snap?.aaCountry == "" &&
                                                    global == "false" ||
                                                snap?.gPollTime ==
                                                        widget.durationInDay &&
                                                    global == 'true' ||
                                                snap?.nPollTime ==
                                                        widget.durationInDay &&
                                                    global == 'false'
                                            ? whiteDialog
                                            : Colors.blue,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(50),
                                      splashColor:
                                          Colors.black.withOpacity(0.3),
                                      onTap: () {
                                        Future.delayed(
                                            const Duration(milliseconds: 150),
                                            () {
                                          performLoggedUserAction(
                                              context: context,
                                              action: () {
                                                snap?.pending == "true" &&
                                                        global == "false"
                                                    ? voteIfPending(
                                                        context: context)
                                                    : snap?.aaCountry == "" &&
                                                            global == "false"
                                                        ? nationalityUnknown(
                                                            context: context)
                                                        : snap?.gPollTime ==
                                                                        widget
                                                                            .durationInDay &&
                                                                    global ==
                                                                        'true' ||
                                                                snap?.nPollTime ==
                                                                        widget
                                                                            .durationInDay &&
                                                                    global ==
                                                                        'false'
                                                            ? sendTimerDialog(
                                                                context:
                                                                    context,
                                                                type: 'poll',
                                                                type2: global ==
                                                                        'true'
                                                                    ? 'global'
                                                                    : 'national',
                                                              )
                                                            : _pollController
                                                                    .text
                                                                    .trim()
                                                                    .isEmpty
                                                                ? showSnackBarError(
                                                                    'Poll field cannot be empty.',
                                                                    context)
                                                                : _optionOne
                                                                        .text
                                                                        .trim()
                                                                        .isEmpty
                                                                    ? showSnackBarError(
                                                                        'Poll option #1 cannot be empty.',
                                                                        context)
                                                                    : _optionTwo
                                                                            .text
                                                                            .trim()
                                                                            .isEmpty
                                                                        ? showSnackBarError(
                                                                            'Poll option #2 cannot be empty.',
                                                                            context)
                                                                        : postImagePoll(
                                                                            user?.UID ??
                                                                                '',
                                                                            user?.username ??
                                                                                '',
                                                                            user?.photoUrl ??
                                                                                '',
                                                                            global == 'true'
                                                                                ? ''
                                                                                : snap?.aaCountry ?? '',
                                                                          );
                                              });
                                        });
                                      },
                                      child: SizedBox(
                                        height: 42,
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Row(
                                            children: [
                                              Icon(
                                                snap?.pending == "true" &&
                                                            global == 'false' ||
                                                        snap?.gPollTime ==
                                                                widget
                                                                    .durationInDay &&
                                                            global == 'true' ||
                                                        snap?.nPollTime ==
                                                                widget
                                                                    .durationInDay &&
                                                            global == 'false'
                                                    ? Icons.timer
                                                    : Icons.send,
                                                color: snap?.pending ==
                                                                "true" &&
                                                            global == 'false' ||
                                                        snap?.aaCountry == "" &&
                                                            global == "false" ||
                                                        snap?.gPollTime ==
                                                                widget
                                                                    .durationInDay &&
                                                            global == 'true' ||
                                                        snap?.nPollTime ==
                                                                widget
                                                                    .durationInDay &&
                                                            global == 'false'
                                                    ? darkBlue
                                                    : whiteDialog,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 10),
                                              snap?.gPollTime ==
                                                              widget
                                                                  .durationInDay &&
                                                          global == 'true' ||
                                                      snap?.nPollTime ==
                                                              widget
                                                                  .durationInDay &&
                                                          global == 'false'
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Text(
                                                          'Waiting Time',
                                                          style: TextStyle(
                                                              color: darkBlue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              letterSpacing: 0),
                                                        ),
                                                        // Text(
                                                        //   'Timer refreshes at 12:01AM EST',
                                                        //   style: TextStyle(
                                                        //       color:
                                                        //           Colors.white,
                                                        //       fontWeight:
                                                        //           FontWeight
                                                        //               .bold,
                                                        //       fontSize: 9,
                                                        //       letterSpacing:
                                                        //           0.2),
                                                        // ),
                                                      ],
                                                    )
                                                  : Text(
                                                      snap?.pending == "true" &&
                                                              global == "false"
                                                          ? 'Verification Pending'
                                                          : snap?.aaCountry ==
                                                                      "" &&
                                                                  global ==
                                                                      "false"
                                                              ? 'Nationality Unknown'
                                                              : global == 'true'
                                                                  ? 'Send Poll Globally'
                                                                  : 'Send Poll Nationally',
                                                      style: TextStyle(
                                                          color: snap?.pending ==
                                                                          "true" &&
                                                                      global ==
                                                                          'false' ||
                                                                  snap?.aaCountry ==
                                                                          "" &&
                                                                      global ==
                                                                          "false"
                                                              ? darkBlue
                                                              : whiteDialog,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          letterSpacing: 0),
                                                    )
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
                        ],
                      ),
                    ),
                  ),
          ),
          Visibility(
            visible: _logoutLoading,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.2),
              child: const Center(
                child: SizedBox(
                  height: 19,
                  width: 19,
                  child: CircularProgressIndicator(
                    // color: Color.fromARGB(255, 231, 104, 104),
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

class NoRadioListTile<T> extends StatefulWidget {
  final String start;
  final String center;
  final String end;

  const NoRadioListTile({
    super.key,
    required this.start,
    required this.center,
    required this.end,
  });

  @override
  State<NoRadioListTile<T>> createState() => _NoRadioListTileState<T>();
}

class _NoRadioListTileState<T> extends State<NoRadioListTile<T>> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 14,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.start}.',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Center(
                child: Text(
                  widget.center,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 81, 81, 81),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.5,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '(${widget.end})',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
