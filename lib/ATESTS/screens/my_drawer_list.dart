import 'dart:io';

import 'package:aft/ATESTS/screens/statistics.dart';
import 'package:aft/ATESTS/screens/verify_one.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../admin/admin_verification.dart';
import '../admin/bug_screen.dart';
import '../admin/reported_screen.dart';
import '../authentication/signup.dart';
import '../info screens/data_privacy.dart';
import '../info screens/how_it_works.dart';
import '../info screens/terms_conditions.dart';
import '../methods/auth_methods.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../utils/utils.dart';
import 'blocked_list.dart';
import '../admin/change_user_field_values.dart';
import 'notifications.dart';
import 'profile_all_user.dart';
import 'profile_screen_edit.dart';
import 'report_bug.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool)? onLoading;
  final durationInDay;
  const SettingsScreen({
    super.key,
    this.onLoading,
    required this.durationInDay,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? user;
  var snap;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return user == null
        ? buildSettings(context, "null", "null", false, false)
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.UID)
                .snapshots(),
            builder: (content,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              snap = snapshot.data != null && snapshot.data!.data() != null
                  ? User.fromMap(snapshot.data!.data()!)
                  : snap;
              if (!snapshot.hasData || snapshot.data == null) {
                return const SizedBox();
              } else {
                return buildSettings(context, snap?.aaCountry, snap?.pending,
                    snap?.profileFlag, snap?.profileBadge);
              }
            });
  }

  Widget buildSettings(BuildContext context, String country, String pending,
      bool profileFlag, bool profileBadge) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return IntrinsicHeight(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              width: double.infinity,
              height: country == "" && pending == "false" ? 222 : 166,
              padding: const EdgeInsets.only(
                  right: 10.0, left: 16, top: 8, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: Material(
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: InkWell(
                                customBorder: const CircleBorder(),
                                splashColor: Colors.grey.withOpacity(0.5),
                                onTap: () {
                                  Future.delayed(
                                      const Duration(milliseconds: 50), () {
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 28,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 245, 245, 245),
                          ),
                          child: Stack(
                            children: [
                              user?.photoUrl != null
                                  ? Material(
                                      color: Colors.grey,
                                      elevation: 2.0,
                                      shape: const CircleBorder(),
                                      clipBehavior: Clip.hardEdge,
                                      child: Ink.image(
                                        image: NetworkImage(
                                          '${user?.photoUrl}',
                                        ),
                                        fit: BoxFit.cover,
                                        width: 75,
                                        height: 75,
                                        child: InkWell(
                                          splashColor:
                                              Colors.grey.withOpacity(0.5),
                                          onTap: () {
                                            Future.delayed(
                                              const Duration(milliseconds: 100),
                                              () {
                                                performLoggedUserAction(
                                                  context: context,
                                                  action: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfileAllUser(
                                                          uid: user?.UID ?? '',
                                                          initialTab: 0,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : Material(
                                      color: Colors.grey,
                                      elevation: 2.0,
                                      shape: const CircleBorder(),
                                      clipBehavior: Clip.hardEdge,
                                      child: Ink.image(
                                        image: const AssetImage(
                                            'assets/avatarFT.jpg'),
                                        fit: BoxFit.cover,
                                        width: 75,
                                        height: 75,
                                        child: InkWell(
                                          splashColor:
                                              Colors.grey.withOpacity(0.5),
                                          onTap: () {
                                            Future.delayed(
                                              const Duration(milliseconds: 100),
                                              () {
                                                performLoggedUserAction(
                                                  context: context,
                                                  action: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProfileAllUser(
                                                                uid:
                                                                    user?.UID ??
                                                                        '',
                                                                initialTab: 0,
                                                              )),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                              Positioned(
                                bottom: 0,
                                right: 7,
                                child: Row(
                                  children: [
                                    country != "" && profileFlag
                                        ? SizedBox(
                                            width: 25,
                                            height: 12.5,
                                            child: Image.asset(
                                                'icons/flags/png/${snap?.aaCountry}.png',
                                                package: 'country_icons'))
                                        : Row()
                                  ],
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 4,
                                  child: country != "" && profileBadge
                                      ? Stack(
                                          children: const [
                                            Positioned(
                                              right: 3,
                                              top: 3,
                                              child: CircleAvatar(
                                                radius: 7,
                                                backgroundColor: Colors.white,
                                              ),
                                            ),
                                            Positioned(
                                              child: Icon(Icons.verified,
                                                  color: Color.fromARGB(
                                                      255, 113, 191, 255),
                                                  size: 20),
                                            ),
                                          ],
                                        )
                                      : Row()),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Container(
                            height: 75,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    user != null
                                        ? 'Logged in as'
                                        : 'Logged in as a',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    )),
                                const SizedBox(height: 2),
                                Text(
                                  user != null ? user.username : 'Guest',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.5,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),

                  // ///
                  country == "" && pending == "false"
                      ? Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: PhysicalModel(
                                color: const Color.fromARGB(255, 245, 245, 245),
                                borderRadius: BorderRadius.circular(50),
                                elevation: 2,
                                child: Material(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    splashColor: Colors.black.withOpacity(0.3),
                                    onTap: () {
                                      Future.delayed(
                                          const Duration(milliseconds: 150),
                                          () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const VerifyOne(),
                                          ),
                                        );
                                      });
                                    },
                                    child: Container(
                                      // width: 208,
                                      decoration: BoxDecoration(
                                        // border: Border.all(
                                        //     width: 1, color: Colors.black),

                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20,
                                            top: 12,
                                            bottom: 12,
                                            right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.verified,
                                              color: Color.fromARGB(
                                                  255, 70, 70, 70),
                                              size: 20,
                                            ),
                                            Container(width: 8),
                                            const Text(
                                              'Verify My Account',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.2,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(),

                  // ///
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      // border: Border(
                      //     top: BorderSide(
                      //   width: 1,
                      //   color: Colors.black,
                      // )),
                    ),
                    child: Column(
                      children: [
                        user?.admin == true
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: PhysicalModel(
                                  color:
                                      const Color.fromARGB(255, 245, 245, 245),
                                  elevation: 2,
                                  child: Column(
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        // borderRadius: const BorderRadius.only(
                                        //     topLeft: Radius.circular(8),
                                        //     topRight: Radius.circular(8),
                                        //     ),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 12, top: 17),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          child: const Text('Admin',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            splashColor:
                                                Colors.grey.withOpacity(0.3),
                                            onTap: () {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 150), () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AdminVerification()),
                                                );
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12,
                                                  top: 17,
                                                  bottom: 17),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                      Icons.lock_outlined,
                                                      size: 23,
                                                      color: Colors.black),
                                                  Container(width: 15),
                                                  const Text(
                                                    'Verification System',
                                                    style: TextStyle(
                                                        fontSize: 16.5,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            splashColor:
                                                Colors.grey.withOpacity(0.3),
                                            onTap: () {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 150), () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ReportScreen(
                                                            durationInDay: widget
                                                                .durationInDay,
                                                          )),
                                                );
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12,
                                                  top: 17,
                                                  bottom: 17),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                      Icons.lock_outlined,
                                                      size: 23,
                                                      color: Colors.black),
                                                  Container(width: 15),
                                                  const Text(
                                                    'Content Moderation',
                                                    style: TextStyle(
                                                        fontSize: 16.5,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            splashColor:
                                                Colors.grey.withOpacity(0.3),
                                            onTap: () {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 150), () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ChangeUserFieldValues()),
                                                );
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12,
                                                  top: 17,
                                                  bottom: 17),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                      Icons.lock_outlined,
                                                      size: 23,
                                                      color: Colors.black),
                                                  Container(width: 15),
                                                  const Text(
                                                    'Change User Values',
                                                    style: TextStyle(
                                                        fontSize: 16.5,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            splashColor:
                                                Colors.grey.withOpacity(0.3),
                                            onTap: () {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 150), () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ReportBugAdmin()),
                                                );
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12,
                                                  top: 17,
                                                  bottom: 17),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                      Icons.lock_outlined,
                                                      size: 23,
                                                      color: Colors.black),
                                                  Container(width: 15),
                                                  const Text(
                                                    'Reported Bugs',
                                                    style: TextStyle(
                                                        fontSize: 16.5,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Row(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PhysicalModel(
                            color: const Color.fromARGB(255, 245, 245, 245),
                            elevation: 2,
                            child: Column(
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  // borderRadius: const BorderRadius.only(
                                  //     topLeft: Radius.circular(8),
                                  //     topRight: Radius.circular(8),
                                  //     ),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 12, top: 17),
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    child: const Text('Personalization',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashColor: Colors.grey.withOpacity(0.3),
                                      onTap: () {
                                        Future.delayed(
                                            const Duration(milliseconds: 150),
                                            () {
                                          performLoggedUserAction(
                                              context: context,
                                              action: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const EditProfile()),
                                                );
                                              });
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, top: 17, bottom: 17),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.person_outline,
                                                size: 23, color: Colors.black),
                                            Container(width: 15),
                                            const Text(
                                              'Edit Profile',
                                              style: TextStyle(
                                                  fontSize: 16.5,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Consumer<UserProvider>(
                                    builder: (context, userProvider, child) {
                                  return SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        splashColor:
                                            Colors.grey.withOpacity(0.3),
                                        onTap: () {
                                          Future.delayed(
                                              const Duration(milliseconds: 125),
                                              () {
                                            performLoggedUserAction(
                                                context: context,
                                                action: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Notifications()),
                                                  );
                                                });
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12, top: 17, bottom: 17),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                  Icons
                                                      .notifications_active_outlined,
                                                  size: 23,
                                                  color: Colors.black),
                                              Container(width: 15),
                                              const Text(
                                                'Notification Preferences',
                                                style: TextStyle(
                                                    fontSize: 16.5,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashColor: Colors.grey.withOpacity(0.3),
                                      onTap: () {
                                        Future.delayed(
                                            const Duration(milliseconds: 125),
                                            () {
                                          performLoggedUserAction(
                                              context: context,
                                              action: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const BlockedList()),
                                                );
                                              });
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, top: 17, bottom: 17),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.block,
                                                size: 23, color: Colors.black),
                                            Container(width: 15),
                                            const Text(
                                              'Blocked List',
                                              style: TextStyle(
                                                  fontSize: 16.5,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    decoration: const BoxDecoration(
                      // border: Border(
                      //     // top: BorderSide(width: 1, color: Colors.black),
                      //     bottom: BorderSide(width: 1, color: Colors.black),
                      //     ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PhysicalModel(
                        color: const Color.fromARGB(255, 245, 245, 245),
                        elevation: 2,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 12, top: 17),
                              width: MediaQuery.of(context).size.width * 1,
                              child: const Text('Other',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.grey.withOpacity(0.3),
                                  onTap: () {
                                    Future.delayed(
                                        const Duration(milliseconds: 150), () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HowItWorks()),
                                      );
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, top: 17, bottom: 17),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.help_outline,
                                            size: 23, color: Colors.black),
                                        Container(width: 15),
                                        const Text(
                                          'How does Fairtalk work?',
                                          style: TextStyle(
                                              fontSize: 16.5,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.grey.withOpacity(0.3),
                                  onTap: () {
                                    Future.delayed(
                                        const Duration(milliseconds: 150), () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Statistics()),
                                      );
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, top: 17, bottom: 17),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.insert_chart_outlined,
                                            size: 23, color: Colors.black),
                                        Container(width: 15),
                                        const Text(
                                          'Statistics',
                                          style: TextStyle(
                                              fontSize: 16.5,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.grey.withOpacity(0.3),
                                  onTap: () {
                                    //           Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //            RateDialogPage(rateMyApp: ),
                                    //   ),
                                    // );
                                    Future.delayed(
                                        const Duration(milliseconds: 150), () {
                                      performLoggedUserAction(
                                          context: context,
                                          action: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ReportBug()),
                                            );
                                          });
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, top: 17, bottom: 17),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.bug_report_outlined,
                                            color: Colors.black, size: 23),
                                        Container(width: 15),
                                        const Text(
                                          'Report a Bug',
                                          style: TextStyle(
                                              fontSize: 16.5,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.grey.withOpacity(0.3),
                                  onTap: () {
                                    Future.delayed(
                                        const Duration(milliseconds: 150), () {
                                      contactInfo(context: context);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, top: 17, bottom: 17),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.email_outlined,
                                            color: Colors.black, size: 23),
                                        Container(width: 15),
                                        const Text(
                                          'Contact Information',
                                          style: TextStyle(
                                            fontSize: 16.5,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      // border: Border(
                      //     // top: BorderSide(
                      //     //     width: 1,
                      //     //     color: Colors.black),
                      //     bottom: BorderSide(width: 1, color: Colors.black),
                      //     ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: PhysicalModel(
                        color: const Color.fromARGB(255, 245, 245, 245),
                        elevation: 2,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 12, top: 17),
                              width: MediaQuery.of(context).size.width * 1,
                              child: const Text('Account Controls',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.grey.withOpacity(0.3),
                                  onTap: () async {
                                    if (user != null) {
                                      var val = await AuthMethods().signOut();
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .logoutUser();
                                    }
                                    Future.delayed(
                                        const Duration(milliseconds: 0), () {
                                      goToLogin(context);
                                      user == null
                                          ? null
                                          : showSnackBar(
                                              'Successfully logged out.',
                                              context);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, top: 17, bottom: 17),
                                    child: Row(
                                      children: [
                                        Icon(
                                            user == null
                                                ? Icons.login
                                                : Icons.logout,
                                            size: 23,
                                            color: Colors.black),
                                        Container(width: 15),
                                        Text(
                                          user == null ? 'Login' : 'Logout',
                                          style: const TextStyle(
                                              fontSize: 16.5,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            user == null
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    child: Material(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        splashColor:
                                            Colors.grey.withOpacity(0.3),
                                        onTap: () {
                                          Future.delayed(
                                              const Duration(milliseconds: 150),
                                              () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignupScreen()),
                                            );
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12, top: 17, bottom: 17),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                  Icons.verified_user_outlined,
                                                  size: 23,
                                                  color: Colors.black),
                                              Container(width: 15),
                                              const Text(
                                                'Sign Up',
                                                style: TextStyle(
                                                    fontSize: 16.5,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        splashColor:
                                            Colors.grey.withOpacity(0.3),
                                        onTap: () async {
                                          // performLoggedUserAction(
                                          //     context: context,
                                          //     action: () {
                                          //       return deleteAccount(
                                          //           context: context,
                                          //           // phrase:
                                          //           //     'Deleting your account is permanent and this action cannot be undone.',
                                          //           // type: 'Delete Account',
                                          //           action: () async {
                                          //             AuthMethods().deleteUser(
                                          //                 uid: user.UID,
                                          //                 context: context);
                                          //           });
                                          //     });
                                          bool authenticated =
                                              await performReAuthenticationDeleteAccountAction(
                                            context: context,
                                          );
                                          if (authenticated) {
                                            (widget.onLoading ??
                                                (value) {})(true);
                                            await AuthMethods().deleteUser(
                                              uid: user.UID,
                                              context: context,
                                            );
                                            (widget.onLoading ??
                                                (value) {})(false);
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12, top: 17, bottom: 17),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                  Icons.delete_forever_outlined,
                                                  size: 23,
                                                  color: Colors.black),
                                              Container(width: 15),
                                              const Text(
                                                'Delete Account',
                                                style: TextStyle(
                                                    fontSize: 16.5,
                                                    color: Colors.black),
                                              ),
                                            ],
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12, right: 12, left: 12),
              child: PhysicalModel(
                color: const Color.fromARGB(255, 245, 245, 245),
                elevation: 2,
                child: Container(
                  height: 35,
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(
                      top: 2, bottom: 2, right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 85,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              Future.delayed(const Duration(milliseconds: 150),
                                  () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const DataPrivacy(),
                                  ),
                                );
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(top: 6.0, bottom: 6),
                              child: Text(
                                'Data Privacy',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 11.5,
                                    color: Colors.black,
                                    letterSpacing: 0.3,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(),
                      SizedBox(
                        height: 27,
                        child: Image.asset(
                          'assets/bottomIconSettings5.png',
                        ),
                      ),
                      const SizedBox(),
                      SizedBox(
                        width: 85,
                        child: Material(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            splashColor: Colors.grey.withOpacity(0.3),
                            onTap: () {
                              Future.delayed(const Duration(milliseconds: 150),
                                  () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TermsConditions(),
                                  ),
                                );
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(top: 6.0, bottom: 6),
                              child: Text(
                                'Terms of Use',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 11.5,
                                    color: Colors.black,
                                    letterSpacing: 0.3,
                                    fontWeight: FontWeight.w500),
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
          ],
        ),
      ),
    );
  }
}
