import 'package:aft/ATESTS/provider/block_list_provider.dart';
import 'package:aft/ATESTS/provider/filter_provider.dart';
import 'package:aft/ATESTS/provider/poll_provider.dart';
import 'package:aft/ATESTS/provider/post_provider.dart';
import 'package:aft/ATESTS/screens/most_liked_screen.dart';
import 'package:aft/ATESTS/services/firebase_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../provider/user_provider.dart';
import '../provider/country_change_provider.dart';
import '../provider/user_report_provider.dart';
import '../screens/add_post.dart';
import '../screens/add_post_daily.dart';
import '../screens/home_screen.dart';
import '../screens/search.dart';
import '../screens/submissions.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import 'my_flutter_app_icons.dart';

import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';
import '../info screens/welcome_screen.dart';
import '../methods/auth_methods.dart';
import '../authentication/login_screen.dart';
import '../info screens/data_privacy.dart';
import '../info screens/terms_conditions.dart';
import 'package:aft/ATESTS/methods/firestore_methods.dart';

// ignore: must_be_immutable
class MobileScreenLayout extends StatefulWidget {
  final int? pageIndex;
  final bool? guest;

  // String s;

  const MobileScreenLayout(
      // this.s,
      {Key? key,
      this.pageIndex,
      this.guest})
      : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  // Timer? timer;
  // int? midnightDuration;

  int _page = 0;
  late PageController pageController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  var durationInDay = 0;
  var oldDurationInDay = 0;
  var initialDurationInDay = 1;
  // DateTime ntpTime = DateTime.now();
  FirebaseDatabase rdb = FirebaseDatabase.instance;

  User? user;

  ///////signup///////
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;
  bool _passwordVisible = false;
  String oneValue = '';
  bool isGuest = false;
  ///////signup///////

  final RateMyApp rateMyApp = RateMyApp(
    minDays: 7,
    minLaunches: 10,
    remindDays: 14,
    remindLaunches: 20,
    // minDays: 0,
    // minLaunches: 1,
    // remindDays: 0,
    // remindLaunches: 2,
    googlePlayIdentifier: 'net.fairtalk.fairtalk',
    appStoreIdentifier: '1665430482',
  );

  @override
  void initState() {
    super.initState();
    // user == null ? goToLogin(context) : null;
    isGuest = widget.guest == true ? true : false;
    setInitialSharedPreferrences();

    Provider.of<FilterProvider>(context, listen: false)
        .setDurationInDay(durationInDay);
    Provider.of<PostProvider>(context, listen: false).startScrollListener();
    Provider.of<PollsProvider>(context, listen: false).startScrollListener();
    Provider.of<BlockListProvider>(context, listen: false);
    isLoading = true;
    // _page = int.parse(widget.s);
    if (widget.pageIndex != null) {
      _page = widget.pageIndex!;
    }

    if (FirebaseNotification.mostLikedNav &&
        FirebaseNotification.mostLikedPageType.isNotEmpty) {
      switch (FirebaseNotification.mostLikedPageType) {
        case 'gm':
          if (navigatorKey.currentContext != null) {
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setOneValue('Most Recent');
            _page = 1;
          }
          break;
        case 'gp':
          if (navigatorKey.currentContext != null) {
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setOneValue('Most Recent');
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setMessage('false');
            _page = 1;
          }
          break;
        case 'np':
          String countryCode = FirebaseNotification.mostLikedCountry;
          if (navigatorKey.currentContext != null) {
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setOneValue('Most Recent');
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setMessage('false');
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setCountryByString(countryCode);
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setGlobal('false');
            _page = 1;
          }
          break;
        case 'nm':
          String countryCode = FirebaseNotification.mostLikedCountry;
          if (navigatorKey.currentContext != null) {
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setOneValue('Most Recent');
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setMessage('true');
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setCountryByString(countryCode);
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setGlobal('false');

            _page = 1;
          }
          break;
        default:
          // debugPrint("error");
          break;
      }
    }

    pageController = PageController(initialPage: _page);
    _getStartTime();

    // getDate();
    // _page = int.parse(widget.s);
    //  _page = int.parse(widget.s);
    // pageController = PageController(initialPage: _page);

    rateMyApp.init().then((_) {
      rateMyApp.conditions.forEach((condition) {
        if (condition is DebuggableCondition) {
          debugPrint(condition.valuesAsString);
        }
      });
      if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(
          context,
          title: 'Feel free to share your experience!',
          message:
              'If you enjoy using Fairtalk, feel free to give us some feedback by either rating our app and/or writing us a review!',
          rateButton: 'GIVE FEEDBACK',
          laterButton: 'MAYBE LATER',
          noButton: "NO THANKS",
          dialogStyle: const DialogStyle(
            titleAlign: TextAlign.center,
            messageAlign: TextAlign.center,
          ),
          onDismissed: () =>
              rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    });
    initialDurationInDay = durationInDay;
    print('initialDurationInDay: $initialDurationInDay');
    //////////////////////////////////////////////////////////////////////
    // midnightTimer();
  }

  // midnightTimer() async {
  //   debugPrint('dateis $dateEST');
  //   // var date = await NTP.now();
  //   debugPrint('what is duration $durationInDay');
  //   // debugPrint(
  //   //     'original duration is ${await DurationProvider.getDurationInDays()}');
  //   var date = DateTime.now();
  //   midnightDuration = DateTime(date.year, date.month, date.day + 1, 0)
  //           .difference(dateEST)
  //           .inSeconds +
  //       2;
  //   debugPrint('duration in midnight $midnightDuration');
  //   timer = Timer.periodic(
  //       const Duration(seconds: 1), (Timer t) => checkDuration());
  // }

  // checkDuration() async {
  //   if (midnightDuration != null) {
  //     midnightDuration = midnightDuration! - 1;
  //     // debugPrint('midnight duration $midnightDuration');
  //     if (midnightDuration! <= 0) {
  //       debugPrint('yes timer executed');
  //       // debugPrint(
  //       //     'duration that come in ${await DurationProvider.getDurationInDays()}');
  //       await getDate();
  //       setState(() {
  //         _getStartTime();
  //         debugPrint('date is $dateEST');

  //         midnightDuration =
  //             DateTime(dateEST.year, dateEST.month, dateEST.day + 1, 0)
  //                     .difference(dateEST)
  //                     .inSeconds +
  //                 2;
  //       });
  //     }
  //   }
  //   // debugPrint('Midnight Duration: $midnightDuration');
  //   // debugPrint('durationInDay: $durationInDay');

  //   /// uncomment this section to check the time effect on all screens
  //   // setState(() {
  //   //   durationInDay++;
  //   // });
  // }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    // timer?.cancel();
    // Provider.of<PostProvider>(context, listen: false).stopListener();
    // Provider.of<PollsProvider>(context, listen: false).stopListener();
  }

  void navigationTapped(int page) async {
    debugPrint("page $page");
    FocusScope.of(context).unfocus();
    pageController.jumpToPage(page);
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final pollProvider = Provider.of<PollsProvider>(context, listen: false);

    filterProvider.setDurationInDay(durationInDay);
    // final leftTimeProvider =
    //     Provider.of<LeftTimeProvider>(context, listen: false);

    if (page == 0) {
      // String? value = await prefs!.getString(twoValue1H);
      // debugPrint("val8e $value");
      // if (value != null) {
      //   filterProvider.setTwoValue(value ?? '');
      // }
      // await Future.delayed(Duration(seconds: 1));
      // String? value = prefs!.getString(twoValue1H);
      // debugPrint("val8e $value");
      // if (value != null) {
      //   filterProvider.setTwoValue(value);
      // }
      // debugPrint("page value $value");
      // debugPrint('page is ${page}');
      //  await filterProvider.loadFilters();
      // debugPrint('messages value outsice ${filterProvider.messages}');
      // if (filterProvider.messages == 'true') {
      //   debugPrint(
      //       'Filter Values at page change two val: ${filterProvider.twoValue}\n global: ${filterProvider.global} \n country ${filterProvider.countryCode}\n duration ${filterProvider.durationInDay}\n one val ${filterProvider.oneValue}');
      //   postProvider.getPosts(
      //       value ?? filterProvider.twoValue,
      //       filterProvider.global,
      //       filterProvider.countryCode,
      //       durationInDay,
      //       filterProvider.oneValue);
      // } else {
      //   // debugPrint('messages value ${filterProvider.messages}');
      //   pollProvider.getPolls(filterProvider.twoValue, filterProvider.global,
      //       filterProvider.countryCode, durationInDay, filterProvider.oneValue);
      // }
    } else if (page == 2) {
      // String? value = prefs!.getString(twoValue1);
      // debugPrint("val8e $value");
      // if (value != null) {
      //   filterProvider.setTwoValue(value ?? '');
      // }

      // filterProvider.setTwoValue("All Days");
    } else if (page == 3) {
      debugPrint("page value ${page}");
      filterProvider.setAllValue();
      // filterProvider.setTwoValue("All Days");
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  /////////////////////signup///////////////////
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Validates username
      String? userNameValid =
          await usernameValidator(username: _usernameController.text);
      if (userNameValid != null) {
        if (!mounted) return;
        showSnackBarError(userNameValid, context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      String res = await AuthMethods().signUpUser(
        username: _usernameController.text.trim(),
        aEmail: _emailController.text.trim(),
        password: _passwordController.text,
        profilePicFile: _image,
        aaCountry: '',
        pending: 'false',
        bio: '',
        gMessageTime: 0,
        nMessageTime: 0,
        gPollTime: 0,
        nPollTime: 0,
      );

      if (res != "success") {
        Future.delayed(const Duration(milliseconds: 1500), () {
          setState(() {
            _isLoading = false;
          });
        });
        if (!mounted) return;
        showSnackBarError(res, context);
      } else {
        // if (!mounted) return;
        // showSnackBar("Welcome ${_usernameController.text.trim()}!", context);
        goToHome(context);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(
                username: _usernameController.text.trim(),
                durationInDay: durationInDay),
          ),
          (route) => false,
        );
        FirestoreMethods().postCounter('user');
      }
    } catch (e) {
      // debugPrint('signup error $e $st');
    }
  }

  void navigateToLogin() {
    Future.delayed(const Duration(milliseconds: 150), () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            durationInDay: durationInDay,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user;
    user = Provider.of<UserProvider>(context).getUser;
    final ThemeData themeData = Theme.of(context);
    return isLoading == true
        ? Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                body: Container(
                  color: Colors.transparent,
                  child: SafeArea(
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 1,
                      child: Center(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width > 600
                                          ? 100
                                          : 32),
                              child: Column(children: [
                                const SizedBox(height: 20),
                                Image.asset(
                                  width: MediaQuery.of(context).size.width * 1 -
                                      80,
                                  'assets/fairtalk_blue_transparent.png',
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 1 -
                                      80,
                                  child: const Text(
                                    'A platform built to unite us all.',
                                    style: TextStyle(
                                        color: darkBlue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9,
                                        fontFamily: 'Capitalis'),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: SizedBox(
                                    height: 60,
                                    child: Theme(
                                      data: themeData.copyWith(
                                          inputDecorationTheme: themeData
                                              .inputDecorationTheme
                                              .copyWith(
                                        prefixIconColor:
                                            MaterialStateColor.resolveWith(
                                                (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.focused)) {
                                            return const Color.fromARGB(
                                                255, 36, 64, 101);
                                          }

                                          return Colors.grey;
                                        }),
                                      )),
                                      child: TextField(
                                        textInputAction: TextInputAction.next,
                                        controller: _usernameController,
                                        maxLength: 16,
                                        decoration: InputDecoration(
                                            counterText: '',
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 36, 64, 101),
                                                  width: 2),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: const BorderSide(
                                                  color: Colors.grey, width: 1),
                                            ),
                                            labelText: 'Username',
                                            labelStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                            hintStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                            fillColor: const Color.fromARGB(
                                                255, 245, 245, 245),
                                            filled: true,
                                            prefixIcon: const Icon(
                                              Icons.person_outlined,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Theme(
                                  data: themeData.copyWith(inputDecorationTheme:
                                      themeData.inputDecorationTheme.copyWith(
                                    prefixIconColor:
                                        MaterialStateColor.resolveWith(
                                            (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.focused)) {
                                        return const Color.fromARGB(
                                            255, 36, 64, 101);
                                      }

                                      return Colors.grey;
                                    }),
                                  )),
                                  child: TextField(
                                    textInputAction: TextInputAction.next,
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 36, 64, 101),
                                              width: 2),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                        labelText: 'Email Address',
                                        labelStyle: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                        hintStyle: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                        fillColor: const Color.fromARGB(
                                            255, 245, 245, 245),
                                        filled: true,
                                        prefixIcon: const Icon(
                                          Icons.email_outlined,
                                        )),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Theme(
                                  data: themeData.copyWith(inputDecorationTheme:
                                      themeData.inputDecorationTheme.copyWith(
                                    prefixIconColor:
                                        MaterialStateColor.resolveWith(
                                            (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.focused)) {
                                        return const Color.fromARGB(
                                            255, 36, 64, 101);
                                      }

                                      return Colors.grey;
                                    }),
                                  )),
                                  child: TextField(
                                    controller: _passwordController,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 36, 64, 101),
                                            width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                            color: Colors.grey, width: 1),
                                      ),
                                      labelText: 'Password',
                                      labelStyle: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      hintStyle: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      fillColor: const Color.fromARGB(
                                          255, 245, 245, 245),
                                      filled: true,
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                      ),
                                      suffixIcon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                PhysicalModel(
                                  color: darkBlue,
                                  elevation: 3,
                                  borderRadius: BorderRadius.circular(50),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(50),
                                      splashColor:
                                          Colors.black.withOpacity(0.3),
                                      child: Container(
                                        width: double.infinity,
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
                                        child: _isLoading
                                            ? const Center(
                                                child: SizedBox(
                                                    height: 18,
                                                    width: 18,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )),
                                              )
                                            : const Text('Sign Up',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5)),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, right: 12, left: 12),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        const TextSpan(
                                            text:
                                                'By signing up, you agree to our ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12)),
                                        TextSpan(
                                            text: 'Terms of Use',
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 12),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const TermsConditions(),
                                                  ),
                                                );
                                              }),
                                        const TextSpan(
                                            text:
                                                ' and confirm that you have read and understood our ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12)),
                                        TextSpan(
                                            text: 'Privacy Policy.',
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 12),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const DataPrivacy(),
                                                  ),
                                                );
                                              }),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        splashColor:
                                            Colors.grey.withOpacity(0.3),
                                        onTap: navigateToLogin,
                                        child: SizedBox(
                                          height: 45,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Text("Already have an account?",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 13)),
                                              Text(
                                                "Log In",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        255, 81, 81, 81),
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Visibility(
                  visible: isLoading,
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )

        // Stack(
        //     children: [
        //       Container(
        //         color: Colors.white,
        //         child: SafeArea(
        //           child: Scaffold(
        //             backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        //             appBar: AppBar(
        //               elevation: 4,
        //               toolbarHeight: 68,
        //               backgroundColor: Colors.white,
        //               actions: [
        //                 Expanded(
        //                   child: SizedBox(
        //                     width: MediaQuery.of(context).size.width * 1,
        //                     child: Column(
        //                       children: [
        //                         Padding(
        //                           padding: const EdgeInsets.only(
        //                               top: 8, right: 8, left: 8),
        //                           child: Row(
        //                             mainAxisAlignment:
        //                                 MainAxisAlignment.spaceBetween,
        //                             children: [
        //                               const SizedBox(
        //                                 width: 36,
        //                                 height: 35,
        //                                 child: Material(
        //                                   shape: CircleBorder(),
        //                                   color: Colors.white,
        //                                   child: Icon(Icons.settings,
        //                                       color: Color.fromARGB(
        //                                           255, 80, 80, 80)),
        //                                 ),
        //                               ),
        //                               Column(
        //                                 children: [
        //                                   Row(
        //                                     children: const [
        //                                       Padding(
        //                                         padding: EdgeInsets.only(
        //                                             bottom: 1.0),
        //                                         child: Text(
        //                                           'GLOBAL',
        //                                           style: TextStyle(
        //                                             color: Color.fromARGB(
        //                                                 255, 55, 55, 55),
        //                                             fontWeight: FontWeight.bold,
        //                                             fontSize: 14,
        //                                           ),
        //                                         ),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                   PhysicalModel(
        //                                     color: Colors.transparent,
        //                                     elevation: 3,
        //                                     borderRadius:
        //                                         BorderRadius.circular(25),
        //                                     child: Container(
        //                                         width: 116,
        //                                         height: 32.5,
        //                                         decoration: BoxDecoration(
        //                                           borderRadius:
        //                                               BorderRadius.circular(25),
        //                                         ),
        //                                         child: Row(
        //                                           children: [
        //                                             ClipRRect(
        //                                               child: Container(
        //                                                 decoration:
        //                                                     const BoxDecoration(
        //                                                         borderRadius:
        //                                                             BorderRadius
        //                                                                 .only(
        //                                                           topLeft: Radius
        //                                                               .circular(
        //                                                                   25),
        //                                                           bottomLeft: Radius
        //                                                               .circular(
        //                                                                   25),
        //                                                         ),
        //                                                         color: Color
        //                                                             .fromARGB(
        //                                                                 255,
        //                                                                 125,
        //                                                                 125,
        //                                                                 125)),
        //                                                 height: 100,
        //                                                 width: 58,
        //                                                 child: const Icon(
        //                                                     MyFlutterApp
        //                                                         .globe_americas,
        //                                                     color: Colors.white,
        //                                                     size: 23),
        //                                               ),
        //                                             ),
        //                                             ClipRRect(
        //                                               child: Container(
        //                                                   decoration:
        //                                                       const BoxDecoration(
        //                                                     borderRadius:
        //                                                         BorderRadius
        //                                                             .only(
        //                                                       topRight: Radius
        //                                                           .circular(25),
        //                                                       bottomRight:
        //                                                           Radius
        //                                                               .circular(
        //                                                                   25),
        //                                                     ),
        //                                                     color:
        //                                                         Color.fromARGB(
        //                                                             255,
        //                                                             228,
        //                                                             228,
        //                                                             228),
        //                                                   ),
        //                                                   height: 100,
        //                                                   width: 58,
        //                                                   child: const Icon(
        //                                                       Icons.flag,
        //                                                       color:
        //                                                           Colors.white,
        //                                                       size: 17)),
        //                                             )
        //                                           ],
        //                                         )),
        //                                   ),
        //                                 ],
        //                               ),
        //                               Column(
        //                                 children: [
        //                                   const Padding(
        //                                     padding:
        //                                         EdgeInsets.only(bottom: 1.0),
        //                                     child: Text(
        //                                       'MESSAGES',
        //                                       style: TextStyle(
        //                                         color: Color.fromARGB(
        //                                             255, 55, 55, 55),
        //                                         fontWeight: FontWeight.bold,
        //                                         fontSize: 14,
        //                                       ),
        //                                     ),
        //                                   ),
        //                                   PhysicalModel(
        //                                     color: Colors.transparent,
        //                                     elevation: 3,
        //                                     borderRadius:
        //                                         BorderRadius.circular(25),
        //                                     child: Container(
        //                                       width: 116,
        //                                       height: 32.5,
        //                                       decoration: BoxDecoration(
        //                                         borderRadius:
        //                                             BorderRadius.circular(25),
        //                                       ),
        //                                       child: Row(
        //                                         children: [
        //                                           ClipRRect(
        //                                             child: Container(
        //                                               decoration:
        //                                                   const BoxDecoration(
        //                                                       borderRadius:
        //                                                           BorderRadius
        //                                                               .only(
        //                                                         topLeft: Radius
        //                                                             .circular(
        //                                                                 25),
        //                                                         bottomLeft: Radius
        //                                                             .circular(
        //                                                                 25),
        //                                                       ),
        //                                                       color: Color
        //                                                           .fromARGB(
        //                                                               255,
        //                                                               125,
        //                                                               125,
        //                                                               125)),
        //                                               height: 100,
        //                                               width: 58,
        //                                               child: const Icon(
        //                                                   Icons.message,
        //                                                   color: Colors.white,
        //                                                   size: 23),
        //                                             ),
        //                                           ),
        //                                           ClipRRect(
        //                                             child: Container(
        //                                                 decoration:
        //                                                     const BoxDecoration(
        //                                                   borderRadius:
        //                                                       BorderRadius.only(
        //                                                     topRight:
        //                                                         Radius.circular(
        //                                                             25),
        //                                                     bottomRight:
        //                                                         Radius.circular(
        //                                                             25),
        //                                                   ),
        //                                                   color: Color.fromARGB(
        //                                                       255,
        //                                                       228,
        //                                                       228,
        //                                                       228),
        //                                                 ),
        //                                                 height: 100,
        //                                                 width: 58,
        //                                                 child: const RotatedBox(
        //                                                   quarterTurns: 1,
        //                                                   child: Icon(
        //                                                       Icons.poll,
        //                                                       color:
        //                                                           Colors.white,
        //                                                       size: 17),
        //                                                 )),
        //                                           )
        //                                         ],
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 ],
        //                               ),
        //                               const SizedBox(
        //                                 width: 36,
        //                                 height: 35,
        //                                 child: Icon(Icons.filter_list,
        //                                     color: Color.fromARGB(
        //                                         255, 80, 80, 80)),
        //                               ),
        //                             ],
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             bottomNavigationBar: CupertinoTabBar(
        //                 inactiveColor: Colors.grey,
        //                 activeColor: Colors.black,
        //                 height: 50,
        //                 backgroundColor: Colors.white,
        //                 items: [
        //                   const BottomNavigationBarItem(
        //                     icon: Padding(
        //                         padding: EdgeInsets.only(top: 3.0, right: 0),
        //                         child: Icon(
        //                           Icons.home,
        //                         )),
        //                     label: 'Home',
        //                   ),
        //                   const BottomNavigationBarItem(
        //                     icon: Padding(
        //                       padding: EdgeInsets.only(top: 4.0),
        //                       child: Icon(MyFlutterApp.university, size: 25),
        //                     ),
        //                     label: 'Archives',
        //                   ),
        //                   const BottomNavigationBarItem(
        //                     icon: Padding(
        //                       padding: EdgeInsets.only(top: 3.0),
        //                       child: Icon(
        //                         Icons.search,
        //                       ),
        //                     ),
        //                     label: 'Search',
        //                   ),
        //                   BottomNavigationBarItem(
        //                     icon: Stack(
        //                       children: const [
        //                         Padding(
        //                           padding: EdgeInsets.only(top: 3.0),
        //                           child: Icon(
        //                             Icons.create,
        //                           ),
        //                         ),
        //                         Positioned(
        //                           top: 15,
        //                           left: 13,
        //                           child: Padding(
        //                             padding: EdgeInsets.only(top: 3.0),
        //                             child: Icon(
        //                               Icons.add,
        //                               size: 14,
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                     label: 'Create',
        //                   ),
        //                   const BottomNavigationBarItem(
        //                     icon: Padding(
        //                       padding: EdgeInsets.only(top: 3.0),
        //                       child: Icon(
        //                         Icons.phone_iphone,
        //                       ),
        //                     ),
        //                     label: 'Submissions',
        //                   ),
        //                 ],
        //                 currentIndex: _page,
        //                 onTap: navigationTapped),
        //           ),
        //         ),
        //       ),
        //       Positioned.fill(
        //         child: Visibility(
        //           visible: isLoading,
        //           child: Container(
        //             color: Colors.black.withOpacity(0.3),
        //             child: const Center(
        //               child: CircularProgressIndicator(
        //                 color: Colors.white,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   )
        // : user == null && isGuest == false
        //     ? Scaffold(
        //         backgroundColor: Colors.white,
        //         body: Container(
        //           color: Colors.transparent,
        //           child: SafeArea(
        //             child: Container(
        //               color: Colors.white,
        //               width: double.infinity,
        //               height: MediaQuery.of(context).size.height * 1,
        //               child: Center(
        //                 child: ListView(
        //                   shrinkWrap: true,
        //                   // reverse: true,
        //                   children: [
        //                     Container(
        //                       padding: EdgeInsets.symmetric(
        //                           horizontal:
        //                               MediaQuery.of(context).size.width > 600
        //                                   ? 100
        //                                   : 32),
        //                       child: Column(children: [
        //                         const SizedBox(height: 20),
        //                         Image.asset(
        //                           width: MediaQuery.of(context).size.width * 1 -
        //                               80,
        //                           'assets/fairtalk_blue_transparent.png',
        //                         ),
        //                         const SizedBox(height: 5),
        //                         SizedBox(
        //                           width: MediaQuery.of(context).size.width * 1 -
        //                               80,
        //                           child: const Text(
        //                             'A platform built to unite us all.',
        //                             style: TextStyle(
        //                                 color: darkBlue,
        //                                 fontWeight: FontWeight.bold,
        //                                 fontSize: 9,
        //                                 fontFamily: 'Capitalis'),
        //                             textAlign: TextAlign.center,
        //                           ),
        //                         ),
        //                         const SizedBox(height: 24),
        //                         Padding(
        //                           padding: const EdgeInsets.only(top: 0.0),
        //                           child: SizedBox(
        //                             height: 60,
        //                             child: Theme(
        //                               data: themeData.copyWith(
        //                                   inputDecorationTheme: themeData
        //                                       .inputDecorationTheme
        //                                       .copyWith(
        //                                 prefixIconColor:
        //                                     MaterialStateColor.resolveWith(
        //                                         (Set<MaterialState> states) {
        //                                   if (states.contains(
        //                                       MaterialState.focused)) {
        //                                     return const Color.fromARGB(
        //                                         255, 36, 64, 101);
        //                                   }

        //                                   return Colors.grey;
        //                                 }),
        //                               )),
        //                               child: TextField(
        //                                 textInputAction: TextInputAction.next,
        //                                 controller: _usernameController,
        //                                 maxLength: 16,
        //                                 decoration: InputDecoration(
        //                                     counterText: '',
        //                                     focusedBorder: OutlineInputBorder(
        //                                       borderRadius:
        //                                           BorderRadius.circular(25),
        //                                       borderSide: const BorderSide(
        //                                           color: Color.fromARGB(
        //                                               255, 36, 64, 101),
        //                                           width: 2),
        //                                     ),
        //                                     enabledBorder: OutlineInputBorder(
        //                                       borderRadius:
        //                                           BorderRadius.circular(25),
        //                                       borderSide: const BorderSide(
        //                                           color: Colors.grey, width: 1),
        //                                     ),
        //                                     labelText: 'Username',
        //                                     labelStyle: const TextStyle(
        //                                         fontSize: 14,
        //                                         color: Colors.grey),
        //                                     hintStyle: const TextStyle(
        //                                         fontSize: 14,
        //                                         color: Colors.grey),
        //                                     fillColor: const Color.fromARGB(
        //                                         255, 245, 245, 245),
        //                                     filled: true,
        //                                     prefixIcon: const Icon(
        //                                       Icons.person_outlined,
        //                                     )),
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                         const SizedBox(height: 24),
        //                         Theme(
        //                           data: themeData.copyWith(inputDecorationTheme:
        //                               themeData.inputDecorationTheme.copyWith(
        //                             prefixIconColor:
        //                                 MaterialStateColor.resolveWith(
        //                                     (Set<MaterialState> states) {
        //                               if (states
        //                                   .contains(MaterialState.focused)) {
        //                                 return const Color.fromARGB(
        //                                     255, 36, 64, 101);
        //                               }

        //                               return Colors.grey;
        //                             }),
        //                           )),
        //                           child: TextField(
        //                             textInputAction: TextInputAction.next,
        //                             controller: _emailController,
        //                             onChanged: (val) {
        //                               setState(() {
        //                                 // emptyPollQuestion = false;
        //                               });
        //                             },
        //                             decoration: InputDecoration(
        //                                 focusedBorder: OutlineInputBorder(
        //                                   borderRadius:
        //                                       BorderRadius.circular(25),
        //                                   borderSide: const BorderSide(
        //                                       color: Color.fromARGB(
        //                                           255, 36, 64, 101),
        //                                       width: 2),
        //                                 ),
        //                                 enabledBorder: OutlineInputBorder(
        //                                   borderRadius:
        //                                       BorderRadius.circular(25),
        //                                   borderSide: const BorderSide(
        //                                       color: Colors.grey, width: 1),
        //                                 ),
        //                                 labelText: 'Email Address',
        //                                 labelStyle: const TextStyle(
        //                                     fontSize: 14, color: Colors.grey),
        //                                 hintStyle: const TextStyle(
        //                                     fontSize: 14, color: Colors.grey),
        //                                 fillColor: const Color.fromARGB(
        //                                     255, 245, 245, 245),
        //                                 filled: true,
        //                                 prefixIcon: const Icon(
        //                                   Icons.email_outlined,
        //                                 )),
        //                           ),
        //                         ),
        //                         const SizedBox(height: 24),
        //                         Theme(
        //                           data: themeData.copyWith(inputDecorationTheme:
        //                               themeData.inputDecorationTheme.copyWith(
        //                             prefixIconColor:
        //                                 MaterialStateColor.resolveWith(
        //                                     (Set<MaterialState> states) {
        //                               if (states
        //                                   .contains(MaterialState.focused)) {
        //                                 return const Color.fromARGB(
        //                                     255, 36, 64, 101);
        //                               }

        //                               return Colors.grey;
        //                             }),
        //                           )),
        //                           child: TextField(
        //                             controller: _passwordController,
        //                             textInputAction: TextInputAction.done,
        //                             decoration: InputDecoration(
        //                               focusedBorder: OutlineInputBorder(
        //                                 borderRadius: BorderRadius.circular(25),
        //                                 borderSide: const BorderSide(
        //                                     color: Color.fromARGB(
        //                                         255, 36, 64, 101),
        //                                     width: 2),
        //                               ),
        //                               enabledBorder: OutlineInputBorder(
        //                                 borderRadius: BorderRadius.circular(25),
        //                                 borderSide: const BorderSide(
        //                                     color: Colors.grey, width: 1),
        //                               ),
        //                               labelText: 'Password',
        //                               labelStyle: const TextStyle(
        //                                   fontSize: 14, color: Colors.grey),
        //                               hintStyle: const TextStyle(
        //                                   fontSize: 14, color: Colors.grey),
        //                               fillColor: const Color.fromARGB(
        //                                   255, 245, 245, 245),
        //                               filled: true,
        //                               prefixIcon: const Icon(
        //                                 Icons.lock_outline,
        //                               ),
        //                               suffixIcon: InkWell(
        //                                 onTap: () {
        //                                   setState(() {
        //                                     _passwordVisible =
        //                                         !_passwordVisible;
        //                                   });
        //                                 },
        //                                 child: Icon(
        //                                   _passwordVisible
        //                                       ? Icons.visibility
        //                                       : Icons.visibility_off,
        //                                   color: Colors.grey,
        //                                   size: 22,
        //                                 ),
        //                               ),
        //                             ),
        //                             obscureText: !_passwordVisible,
        //                           ),
        //                         ),
        //                         const SizedBox(height: 24),
        //                         PhysicalModel(
        //                           color: const darkBlue,
        //                           elevation: 3,
        //                           borderRadius: BorderRadius.circular(50),
        //                           child: Material(
        //                             color: Colors.transparent,
        //                             borderRadius: BorderRadius.circular(25),
        //                             child: InkWell(
        //                               borderRadius: BorderRadius.circular(50),
        //                               splashColor:
        //                                   Colors.black.withOpacity(0.3),
        //                               onTap: signUpUser,
        //                               child: Container(
        //                                 width: double.infinity,
        //                                 alignment: Alignment.center,
        //                                 padding: const EdgeInsets.symmetric(
        //                                     vertical: 12),
        //                                 decoration: const ShapeDecoration(
        //                                   shape: RoundedRectangleBorder(
        //                                     borderRadius: BorderRadius.all(
        //                                       Radius.circular(25),
        //                                     ),
        //                                   ),
        //                                   color: Colors.transparent,
        //                                 ),
        //                                 child: _isLoading
        //                                     ? const Center(
        //                                         child: SizedBox(
        //                                             height: 18,
        //                                             width: 18,
        //                                             child:
        //                                                 CircularProgressIndicator(
        //                                               color: Colors.white,
        //                                             )),
        //                                       )
        //                                     : const Text('Sign Up',
        //                                         style: TextStyle(
        //                                             fontSize: 16,
        //                                             color: Colors.white,
        //                                             fontWeight: FontWeight.w500,
        //                                             letterSpacing: 0.5)),
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                         Padding(
        //                           padding: const EdgeInsets.only(
        //                               top: 8.0, right: 12, left: 12),
        //                           child: RichText(
        //                             text: TextSpan(
        //                               children: <TextSpan>[
        //                                 const TextSpan(
        //                                     text:
        //                                         'By signing up, you agree to our ',
        //                                     style: TextStyle(
        //                                         color: Colors.black,
        //                                         fontSize: 12)),
        //                                 TextSpan(
        //                                     text: 'Terms of Use',
        //                                     style: const TextStyle(
        //                                         color: Colors.blue,
        //                                         fontSize: 12),
        //                                     recognizer: TapGestureRecognizer()
        //                                       ..onTap = () {
        //                                         Navigator.of(context).push(
        //                                           MaterialPageRoute(
        //                                             builder: (context) =>
        //                                                 const TermsConditions(),
        //                                           ),
        //                                         );
        //                                       }),
        //                                 const TextSpan(
        //                                     text:
        //                                         ' and confirm that you have read and understood our ',
        //                                     style: TextStyle(
        //                                         color: Colors.black,
        //                                         fontSize: 12)),
        //                                 TextSpan(
        //                                     text: 'Privacy Policy.',
        //                                     style: const TextStyle(
        //                                         color: Colors.blue,
        //                                         fontSize: 12),
        //                                     recognizer: TapGestureRecognizer()
        //                                       ..onTap = () {
        //                                         Navigator.of(context).push(
        //                                           MaterialPageRoute(
        //                                             builder: (context) =>
        //                                                 const DataPrivacy(),
        //                                           ),
        //                                         );
        //                                       }),
        //                               ],
        //                             ),
        //                           ),
        //                         ),
        //                         const SizedBox(height: 12),
        //                         Column(
        //                           mainAxisAlignment: MainAxisAlignment.end,
        //                           children: [
        //                             Material(
        //                               color: Colors.transparent,
        //                               child: InkWell(
        //                                 borderRadius: BorderRadius.circular(25),
        //                                 splashColor:
        //                                     Colors.grey.withOpacity(0.3),
        //                                 onTap: navigateToLogin,
        //                                 child: SizedBox(
        //                                   height: 45,
        //                                   child: Column(
        //                                     mainAxisAlignment:
        //                                         MainAxisAlignment.center,
        //                                     children: const [
        //                                       Text("Already have an account?",
        //                                           style: TextStyle(
        //                                               color: Colors.grey,
        //                                               fontSize: 13)),
        //                                       Text(
        //                                         "Log In",
        //                                         style: TextStyle(
        //                                             fontWeight: FontWeight.w500,
        //                                             color: Color.fromARGB(
        //                                                 255, 81, 81, 81),
        //                                             fontSize: 14),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                         const SizedBox(height: 20),
        //                       ]),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       )
        : ChangeNotifierProvider<ChangeCountryProvider>(
            create: (context) => ChangeCountryProvider(),
            lazy: false,
            child: ChangeNotifierProvider<UserReportProvider>(
              create: (context) => UserReportProvider(),
              lazy: false,
              child: Container(
                color: Colors.white,
                child: SafeArea(
                  child: Scaffold(
                    body: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: pageController,
                        onPageChanged: onPageChanged,
                        children: [
                          FeedScreen(
                            durationInDay: durationInDay,
                          ),
                          MostLikedScreen(durationInDay: durationInDay),
                          AddPost(
                            durationInDay: durationInDay,
                          ),
                          Search(
                            durationInDay: durationInDay,
                          ),
                          Submissions(
                            durationInDay: durationInDay,
                          ),
                        ]),
                    bottomNavigationBar: CupertinoTabBar(
                        inactiveColor: Colors.white.withOpacity(0.6),
                        activeColor: Colors.white,
                        height: 50,
                        backgroundColor: darkBlue,
                        items: [
                          const BottomNavigationBarItem(
                            icon: Padding(
                                padding: EdgeInsets.only(top: 3.0, right: 0),
                                child: Icon(
                                  Icons.home,
                                )),
                            label: 'Home',
                          ),
                          const BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(top: 3.0),
                              child: Icon(MyFlutterApp.university, size: 23),
                            ),
                            label: 'Archives',
                          ),

                          BottomNavigationBarItem(
                            icon: Stack(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 3.0),
                                  child: Icon(
                                    Icons.create,
                                  ),
                                ),
                                Positioned(
                                  top: 15,
                                  left: 13,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 3.0),
                                    child: Icon(
                                      Icons.add,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            label: 'Create',
                          ),
                          const BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(top: 3.0),
                              child: Icon(
                                Icons.search,
                              ),
                            ),
                            label: 'Search',
                          ),
                          const BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(top: 6.0),
                              child: Icon(
                                MyFlutterApp.users,
                                size: 24,
                              ),
                            ),
                            label: 'Democracy',
                          ),
                          // BottomNavigationBarItem(
                          //   icon: Padding(
                          //     padding: const EdgeInsets.only(top: 3.0),
                          //     child: Icon(
                          //       Icons.notifications,
                          //     ),
                          //   ),
                          //   label: 'Notifications',
                          // ),
                        ],
                        currentIndex: _page,
                        onTap: navigationTapped),
                  ),
                ),
              ),
            ),
          );
  }

  _getStartTime() {
    final durationRef = rdb.ref('duration/period');
    durationRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;

      debugPrint('duration from real time db ${data}');
      if (mounted) {
        setState(() {
          oldDurationInDay = data['time'];
          durationInDay = data['time'];
          Provider.of<FilterProvider>(context, listen: false)
              .setDurationInDay(durationInDay);
          isLoading = false;
        });
      }
    });
    // var timeStr = doc["time"];
    // var timeStr = "15/09/2022 01:00:000Z";
    // // var timeStr = "14/09/2022 11:32:000Z";
    // // var timeStr = "09/09/2022 01:00:000Z";
    // var dateTime = DateFormat('dd/MM/yy HH:mm:ss').parse(timeStr);
    // var dateNow = dateEST;
    // // debugPrint('est date is $dateNow');
    // // var dateNow = ntpTime.toUtc();
    // var duration = dateNow.difference(dateTime);
    // var _dd = duration.inDays;
    // //set old duration

    // durationInDay = _dd;
    // if (_dd < 60) {
    //   setState(() {
    //     // durationForMinutes = _dd;
    //     isLoading = false;
    //   });
    // } else {
    //   // var _fd = _dd % 60;
    //   var _hd = _dd / 60;
    //   var _hhd = _hd.toInt();

    //   // check hours cycle getter 24
    //   if (_hhd < 24) {
    //     setState(() {
    //       // durationForMinutes = _fd;
    //       // durationForHours = _hhd;
    //       isLoading = false;
    //     });
    //   } else {
    //     var _hhhd = _hhd % 24;

    //     setState(() {
    //       // durationForMinutes = _fd;
    //       // durationForHours = _hhhd;
    //       isLoading = false;
    //     });
    //   }
    // }
    // oldDurationInDay = durationInDay;

    // setState(() {
    //   isLoading = false;
    // });

    // Provider.of<FilterProvider>(context, listen: false)
    //     .setDurationInDay(durationInDay);
  }

  void setInitialSharedPreferrences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('selected_radio', 'Highest Score');
    // prefs.setString('selected_radio1', '≤ 7 Days');
    prefs.setString('selected_radio3', 'true');
    prefs.setString('selected_radio4', 'true');
    prefs.setInt('countryRadio', 188);
  }
}
