import 'dart:async';
import 'package:aft/ATESTS/responsive/my_flutter_app_icons.dart';
import 'package:aft/ATESTS/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../utils/global_variables.dart';

class Notifications extends StatefulWidget {
  const Notifications({
    Key? key,
  }) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool isGlobalMessage = false;
  bool isNationalMessage = false;
  bool isGlobalPoll = false;
  bool isNationalPoll = false;

  var snap;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setNotificationOn(userProvider.getUser?.fcmTopic ?? '');
    // debugPrint('user fcm topic preset ${userProvider.getUser?.fcmTopic}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  setNotificationOn(String on) {
    if (on.startsWith('gm')) {
      setState(() {
        isGlobalMessage = true;
        isNationalMessage = false;
        isGlobalPoll = false;
        isNationalPoll = false;
      });
    } else if (on.startsWith('nm')) {
      setState(() {
        isNationalMessage = true;
        isGlobalPoll = false;
        isNationalPoll = false;
        isGlobalMessage = false;
      });
    } else if (on.startsWith('gp')) {
      isGlobalPoll = true;
      isNationalMessage = false;
      isGlobalMessage = false;
      isNationalPoll = false;
    } else if (on.startsWith('np')) {
      isNationalPoll = true;
      isNationalMessage = false;
      isGlobalMessage = false;
      isGlobalPoll = false;
    } else {
      isNationalPoll = false;
      isNationalMessage = false;
      isGlobalMessage = false;
      isGlobalPoll = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.UID)
            .snapshots(),
        builder: (content,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          /// Condition for checking both snapshot is not null and neither its data
          snap = snapshot.data != null && snapshot.data!.data() != null
              ? User.fromMap(snapshot.data!.data()!)
              : snap;
          if (!snapshot.hasData || snapshot.data == null) {
            return Row();
          } else {
            return buildNotificationPreferences(context);
          }
        });
  }

  Widget buildNotificationPreferences(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return Container(
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: testing,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 4,
                  toolbarHeight: 56,
                  backgroundColor: darkBlue,
                  actions: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                  child: const Icon(
                                    Icons.keyboard_arrow_left,
                                    color: whiteDialog,
                                  ),
                                ),
                              ),
                            ),
                            Container(width: 16),
                            const Text(
                              'Notification Preferences',
                              style: TextStyle(
                                  color: whiteDialog,
                                  fontSize: 20,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      PhysicalModel(
                        color: Colors.white,
                        elevation: 2,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Global Messages',
                                    style: TextStyle(
                                      letterSpacing: 0.2,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Switch(
                                    value: isGlobalMessage,
                                    activeColor: Colors.black,
                                    onChanged: (bool value) async {
                                      if (userProvider.getUser != null) {
                                        if (value) {
                                          await userProvider.subscribeTopic(
                                              'gm', userProvider.getUser!);
                                        } else {
                                          await userProvider.subscribeTopic(
                                              '', userProvider.getUser!);
                                        }
                                        setState(() {
                                          if (value) {
                                            isGlobalMessage = true;
                                          } else {
                                            isGlobalMessage = false;
                                          }

                                          setNotificationOn(
                                              userProvider.getUser!.fcmTopic ??
                                                  '');
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'National Messages',
                                        style: TextStyle(
                                          letterSpacing: 0.2,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      userProvider.getUser == null ||
                                              snap?.aaCountry == ''
                                          ? const SizedBox()
                                          : SizedBox(
                                              width: 25,
                                              height: 12.5,
                                              child: Image.asset(
                                                  'icons/flags/png/${snap?.aaCountry}.png',
                                                  package: 'country_icons'),
                                            ),
                                    ],
                                  ),
                                  Switch(
                                    value: isNationalMessage,
                                    activeColor: Colors.black,
                                    onChanged: (bool value) async {
                                      if (snap?.aaCountry == "") {
                                        nationalityUnknown(context: context);
                                      } else if (snap != null) {
                                        if (value) {
                                          await userProvider.subscribeTopic(
                                              'nm', snap!);
                                        } else {
                                          await userProvider.subscribeTopic(
                                              '', userProvider.getUser!);
                                        }

                                        setState(() {
                                          if (value) {
                                            isNationalMessage = true;
                                          } else {
                                            isNationalMessage = false;
                                          }
                                          setNotificationOn(
                                              userProvider.getUser!.fcmTopic ??
                                                  '');
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Global Polls',
                                    style: TextStyle(
                                      letterSpacing: 0.2,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Switch(
                                    value: isGlobalPoll,
                                    activeColor: Colors.black,
                                    onChanged: (bool value) async {
                                      if (userProvider.getUser != null) {
                                        if (value) {
                                          await userProvider.subscribeTopic(
                                              'gp', userProvider.getUser!);
                                        } else {
                                          await userProvider.subscribeTopic(
                                              '', userProvider.getUser!);
                                        }

                                        setState(() {
                                          if (value) {
                                            isGlobalPoll = true;
                                          } else {
                                            isGlobalPoll = false;
                                          }
                                          setNotificationOn(
                                              userProvider.getUser?.fcmTopic ??
                                                  '');
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'National Polls',
                                        style: TextStyle(
                                          letterSpacing: 0.2,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      userProvider.getUser == null ||
                                              snap?.aaCountry == ''
                                          ? const SizedBox()
                                          : SizedBox(
                                              width: 25,
                                              height: 12.5,
                                              child: Image.asset(
                                                  'icons/flags/png/${snap?.aaCountry}.png',
                                                  package: 'country_icons'),
                                            ),
                                    ],
                                  ),
                                  Switch(
                                    value: isNationalPoll,
                                    activeColor: Colors.black,
                                    onChanged: (bool value) async {
                                      if (snap?.aaCountry == "") {
                                        nationalityUnknown(context: context);
                                      } else if (snap != null) {
                                        if (value) {
                                          await userProvider.subscribeTopic(
                                              'np', snap!);
                                        } else {
                                          await userProvider.subscribeTopic(
                                              '', userProvider.getUser!);
                                        }
                                        setState(() {
                                          if (value) {
                                            isNationalPoll = true;
                                          } else {
                                            isNationalPoll = false;
                                          }
                                          setNotificationOn(
                                              userProvider.getUser?.fcmTopic ??
                                                  '');
                                        });
                                      }
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                          'Whenever a new message or poll gets archived, you will receive a push notification. You can choose which type of push notification you would prefer receiving. Push notifications can also be turned off completely.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, letterSpacing: 0.2)),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Selector<UserProvider, bool>(
                    selector: (context, userProvider) =>
                        userProvider.fcmTopicLoading,
                    builder: (context, fcmTopicLoading, child) {
                      return Visibility(
                          visible: fcmTopicLoading,
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: const Center(
                                child: CircularProgressIndicator(
                              color: Colors.white,
                            )),
                          ));
                    }),
              )
            ],
          ),
        ),
      );
    });
  }
}
