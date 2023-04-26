import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../methods/auth_methods.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../methods/storage_methods.dart';
import '../responsive/my_flutter_app_icons.dart';
import '../utils/utils.dart';

class EditProfile extends StatefulWidget {
  // final Post post;
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // late Post _post;
  bool posts = true;
  bool comment = false;
  bool username = false;

  String? _image;
  User? user;
  var snap;

  // UI
  bool isLoading = false;
  bool isEditingUsername = false;
  bool isEditingEmail = false;
  bool isEditingBio = false;

  // Controllers
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void selectImage() {
    Future.delayed(const Duration(milliseconds: 50), () async {
      Uint8List im = await pickImage(ImageSource.gallery);
      setState(() {
        // _image = im;
        isLoading = true;
      });
      String photoUrl =
          await StorageMethods().uploadImageToStorage('profilePics', im, false);
      if (photoUrl != null) {
        await AuthMethods().changeProfilePic(profilePhotoUrl: photoUrl);
        UserProvider userProvider = Provider.of(context, listen: false);
        await userProvider.refreshUser();
      }
      if (!mounted) return;
      showSnackBar('Profile picture successfully uploaded.', context);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    _image = user!.photoUrl;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.UID)
          .snapshots(),
      builder: (content,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        snap = snapshot.data != null ? User.fromSnap(snapshot.data!) : snap;
        bool valueFlag = snap?.profileFlag == true ? true : false;
        var selectFlag = snap?.profileFlag == true ? true : false;
        bool valueBadge = snap?.profileBadge == true ? true : false;
        var selectBadge = snap?.profileBadge == true ? true : false;
        bool valueScore = snap?.profileScore == true ? true : false;
        var selectScore = snap?.profileScore == true ? true : false;
        bool valueVotes = snap?.profileVotes == true ? true : false;
        var selectVotes = snap?.profileVotes == true ? true : false;
        if (!snapshot.hasData || snapshot.data == null) {
          return Row();
        }
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Stack(
              children: [
                Scaffold(
                  backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                  appBar: AppBar(
                      automaticallyImplyLeading: false,
                      elevation: 4,
                      toolbarHeight: 56,
                      backgroundColor:
                          // isLoading ? Colors.black.withOpacity(0.2) :
                          Colors.white,
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
                                        Icons.arrow_back,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(width: 22),
                                const Text('Edit Profile',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        letterSpacing: 0.3,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      ]),
                  body: Stack(
                    children: [
                      ListView(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 8),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                    child: SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Stack(
                                        children: [
                                          // Center(
                                          // child:
                                          // Container(
                                          //   width: 120,
                                          //   height: 120,
                                          //   decoration: const BoxDecoration(
                                          //     shape: BoxShape.circle,
                                          //     color: Colors.black,
                                          //   ),
                                          Center(
                                            child: Center(
                                              child: Opacity(
                                                opacity: 0.7,
                                                child: _image != null &&
                                                        _image!.isNotEmpty
                                                    ? Material(
                                                        color: Colors.grey,
                                                        elevation: 4.0,
                                                        shape:
                                                            const CircleBorder(),
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        child: Ink.image(
                                                          image: NetworkImage(
                                                            _image!,
                                                          ),
                                                          fit: BoxFit.cover,
                                                          width: 120.0,
                                                          height: 120.0,
                                                          child: InkWell(
                                                            splashColor: Colors
                                                                .black
                                                                .withOpacity(
                                                                    0.3),
                                                            onTap: selectImage,
                                                          ),
                                                        ),
                                                      )
                                                    : Material(
                                                        color: Colors.grey,
                                                        elevation: 4.0,
                                                        shape:
                                                            const CircleBorder(),
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        child: Ink.image(
                                                          image: const AssetImage(
                                                              'assets/avatarFT.jpg'),
                                                          fit: BoxFit.cover,
                                                          width: 120.0,
                                                          height: 120.0,
                                                          child: InkWell(
                                                            splashColor: Colors
                                                                .black
                                                                .withOpacity(
                                                                    0.3),
                                                            onTap: selectImage,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                          //   ),
                                          // ),
                                          Positioned(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 28.0, right: 3),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Expanded(
                                                  //   child: Container(),
                                                  // ),
                                                  SizedBox(
                                                    height: 60,
                                                    width: 60,
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      shape:
                                                          const CircleBorder(),
                                                      child: InkWell(
                                                        customBorder:
                                                            const CircleBorder(),
                                                        splashColor: Colors
                                                            .black
                                                            .withOpacity(0.3),
                                                        onTap: selectImage,
                                                        child: Icon(
                                                          Icons.add_a_photo,
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  _image == null
                                                                      ? 0.8
                                                                      : 0.55),
                                                          size: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Expanded(
                                                  //   child: Container(),
                                                  // )
                                                ],
                                              ),
                                            ),
                                          ),
                                          snap?.aaCountry != "" &&
                                                  snap?.profileFlag == true
                                              ? Positioned(
                                                  bottom: 0,
                                                  right: 15,
                                                  child: SizedBox(
                                                    width: 40,
                                                    height: 20,
                                                    child: Image.asset(
                                                        'icons/flags/png/${snap?.aaCountry}.png',
                                                        package:
                                                            'country_icons'),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          snap?.profileBadge == true
                                              ? Positioned(
                                                  bottom: 0,
                                                  right: 10,
                                                  child: Stack(
                                                    children: const [
                                                      Positioned(
                                                        left: 5,
                                                        bottom: 5,
                                                        child: CircleAvatar(
                                                          radius: 10,
                                                          backgroundColor:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        child: Icon(
                                                            Icons.verified,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    113,
                                                                    191,
                                                                    255),
                                                            size: 31),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 12.0,
                                      left: 12,
                                    ),
                                    child: PhysicalModel(
                                      color: Colors.white,
                                      elevation: 3,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          // border: Border.all(
                                          //     width: 0.75,
                                          //     color: const Color.fromARGB(
                                          //         255, 203, 203, 203)),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Column(
                                            children: [
                                              Column(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20.0,
                                                                top: 0,
                                                                right: 5),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .verified,
                                                                          size:
                                                                              20,
                                                                          color:
                                                                              // selectBadge !=
                                                                              //         false
                                                                              snap?.profileBadge != false ? const Color.fromARGB(255, 113, 191, 255) : const Color.fromARGB(255, 201, 201, 201),
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                8),
                                                                        Text(
                                                                          'Display Verified Badge',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: selectBadge != false
                                                                                ? Colors.black
                                                                                : Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Switch(
                                                                  value:
                                                                      selectBadge,
                                                                  activeColor:
                                                                      Colors
                                                                          .black,
                                                                  onChanged:
                                                                      (valueFlag) {
                                                                    snap?.pending ==
                                                                            "true"
                                                                        ? voteIfPending(
                                                                            context:
                                                                                context)
                                                                        : snap?.aaCountry ==
                                                                                ""
                                                                            ? verificationRequired(context: context)
                                                                            : selectBadge == false
                                                                                ? setState(() {
                                                                                    selectBadge = true;
                                                                                    valueBadge = true;

                                                                                    selectFlag = false;
                                                                                    valueFlag = false;

                                                                                    AuthMethods().changeProfileBadge(profileBadge: true);
                                                                                    AuthMethods().changeProfileFlag(profileFlag: false);
                                                                                  })
                                                                                : selectBadge == true
                                                                                    ? setState(() {
                                                                                        selectBadge = false;

                                                                                        valueBadge = false;

                                                                                        AuthMethods().changeProfileBadge(profileBadge: false);
                                                                                      })
                                                                                    : null;
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20.0,
                                                                top: 0,
                                                                right: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .flag,
                                                                      size: 20,
                                                                      color: selectFlag !=
                                                                              false
                                                                          ? Colors
                                                                              .red
                                                                          : const Color.fromARGB(
                                                                              255,
                                                                              201,
                                                                              201,
                                                                              201),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            8),
                                                                    Text(
                                                                      'Display National Flag',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: selectFlag !=
                                                                                false
                                                                            ? Colors.black
                                                                            : Colors.grey,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Switch(
                                                              value: selectFlag,
                                                              activeColor:
                                                                  Colors.black,
                                                              onChanged:
                                                                  (valueFlag) {
                                                                snap?.pending ==
                                                                        "true"
                                                                    ? voteIfPending(
                                                                        context:
                                                                            context)
                                                                    : snap?.aaCountry ==
                                                                            ""
                                                                        ? verificationRequired(
                                                                            context:
                                                                                context)
                                                                        : selectFlag ==
                                                                                false
                                                                            ? setState(() {
                                                                                selectFlag = true;
                                                                                valueFlag = true;

                                                                                selectBadge = false;
                                                                                valueBadge = false;

                                                                                AuthMethods().changeProfileFlag(profileFlag: true);
                                                                                AuthMethods().changeProfileBadge(profileBadge: false);
                                                                              })
                                                                            : selectFlag == true
                                                                                ? setState(() {
                                                                                    selectFlag = false;
                                                                                    valueFlag = false;

                                                                                    AuthMethods().changeProfileFlag(profileFlag: false);
                                                                                  })
                                                                                : null;
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // Padding(
                                                  //   padding: const EdgeInsets.only(
                                                  //       left: 20.0, top: 0, right: 5),
                                                  //   child: Row(
                                                  //     mainAxisAlignment:
                                                  //         MainAxisAlignment
                                                  //             .spaceBetween,
                                                  //     children: [
                                                  //       Row(
                                                  //         children: [
                                                  //           Row(
                                                  //             children: [
                                                  //               Icon(
                                                  //                 Icons.check_box,
                                                  //                 size: 20,
                                                  //                 color: selectVotes !=
                                                  //                         false
                                                  //                     ? Colors.green
                                                  //                     : const Color
                                                  //                             .fromARGB(
                                                  //                         255,
                                                  //                         201,
                                                  //                         201,
                                                  //                         201),
                                                  //               ),
                                                  //               const SizedBox(
                                                  //                   width: 8),
                                                  //               Text(
                                                  //                 'Display Votes',
                                                  //                 style: TextStyle(
                                                  //                   fontSize: 14,
                                                  //                   fontWeight:
                                                  //                       FontWeight
                                                  //                           .w500,
                                                  //                   color:
                                                  //                       selectVotes !=
                                                  //                               false
                                                  //                           ? Colors
                                                  //                               .black
                                                  //                           : Colors
                                                  //                               .grey,
                                                  //                 ),
                                                  //               ),
                                                  //             ],
                                                  //           ),
                                                  //         ],
                                                  //       ),
                                                  //       Switch(
                                                  //         value: selectVotes,
                                                  //         activeColor: Colors.black,
                                                  //         onChanged: (valueVotes) {
                                                  //           // snap?.pending == "true"
                                                  //           //     ? voteIfPending(
                                                  //           //         context: context)
                                                  //           //     : snap?.aaCountry ==
                                                  //           //             ""
                                                  //           //         ? verificationRequired(
                                                  //           //             context:
                                                  //           //                 context)
                                                  //           //         :
                                                  //           selectVotes == false
                                                  //               ? setState(() {
                                                  //                   // setValueVotes(
                                                  //                   //     true);
                                                  //                   selectVotes =
                                                  //                       true;
                                                  //                   valueVotes = true;

                                                  //                   AuthMethods()
                                                  //                       .changeProfileVotes(
                                                  //                           profileVotes:
                                                  //                               true);
                                                  //                 })
                                                  //               : selectVotes == true
                                                  //                   ? setState(() {
                                                  //                       // setValueVotes(
                                                  //                       //     false);
                                                  //                       selectVotes =
                                                  //                           false;

                                                  //                       valueVotes =
                                                  //                           false;

                                                  //                       AuthMethods()
                                                  //                           .changeProfileVotes(
                                                  //                               profileVotes:
                                                  //                                   false);
                                                  //                     })
                                                  //                   : null;
                                                  //         },
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0,
                                                    top: 0,
                                                    right: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              MyFlutterApp
                                                                  .medal,
                                                              size: 20,
                                                              color: selectScore !=
                                                                      false
                                                                  ? const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      201,
                                                                      187,
                                                                      55)
                                                                  : const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      201,
                                                                      201,
                                                                      201),
                                                            ),
                                                            const SizedBox(
                                                                width: 8),
                                                            Text(
                                                              'Display Profile Score',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: selectScore !=
                                                                        false
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Switch(
                                                      value: selectScore,
                                                      activeColor: Colors.black,
                                                      onChanged: (valueScore) {
                                                        selectScore == false
                                                            ? setState(() {
                                                                // setValueScore(true);
                                                                selectScore =
                                                                    true;
                                                                valueScore =
                                                                    true;

                                                                AuthMethods()
                                                                    .changeProfileScore(
                                                                        profileScore:
                                                                            true);
                                                              })
                                                            : selectScore ==
                                                                    true
                                                                ? setState(() {
                                                                    // setValueScore(
                                                                    //     false);
                                                                    selectScore =
                                                                        false;

                                                                    valueScore =
                                                                        false;

                                                                    AuthMethods().changeProfileScore(
                                                                        profileScore:
                                                                            false);
                                                                  })
                                                                : null;
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 4.0,
                                                ),
                                                child: UserFieldListTile(
                                                  counterText: '',
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  maxLength: 16,
                                                  label: "Username",
                                                  hintText:
                                                      "Enter new username ...",
                                                  value: user?.username,
                                                  textController:
                                                      _userNameController,
                                                  isEditing: isEditingUsername,
                                                  topPadding: 8,
                                                  onEdit: () {
                                                    Future.delayed(
                                                      const Duration(
                                                          milliseconds: 50),
                                                      () {
                                                        _userNameController
                                                                .text =
                                                            user?.username ??
                                                                '';
                                                        isEditingUsername =
                                                            true;
                                                        setState(() {});
                                                      },
                                                    );
                                                  },
                                                  onCancelEdit: () {
                                                    isEditingUsername = false;
                                                    setState(() {});
                                                  },
                                                  onSave: () async {
                                                    setState(() {
                                                      username = true;
                                                    });
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                    // Validates username
                                                    String? userNameValid =
                                                        await usernameValidator(
                                                            username:
                                                                _userNameController
                                                                    .text);
                                                    if (userNameValid != null) {
                                                      if (!mounted) return;
                                                      showSnackBarError(
                                                          userNameValid,
                                                          context);
                                                    } else {
                                                      bool authenticated =
                                                          await performReAuthenticationAction(
                                                              context: context,
                                                              username:
                                                                  username);
                                                      if (authenticated) {
                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        await AuthMethods()
                                                            .changeUsername(
                                                                username:
                                                                    _userNameController
                                                                        .text);
                                                        UserProvider
                                                            userProvider =
                                                            Provider.of(context,
                                                                listen: false);
                                                        await userProvider
                                                            .refreshUser();
                                                        isEditingUsername =
                                                            false;
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                      }
                                                    }
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: UserFieldListTile(
                                                    maxLength: 100,
                                                    counterText: '',
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    label: "Email",
                                                    hintText:
                                                        "Enter new email ...",
                                                    value: user?.aEmail,
                                                    isEditing: isEditingEmail,
                                                    textController:
                                                        _emailController,
                                                    topPadding: 8,
                                                    onEdit: () {
                                                      // user?.aEmail ==
                                                      //         _emailController.text
                                                      //     ? showSnackBar(
                                                      //         'hi', context)
                                                      //     :
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds: 50),
                                                          () {
                                                        _emailController.text =
                                                            user?.aEmail ?? '';
                                                        isEditingEmail = true;
                                                        setState(() {});
                                                      });
                                                    },
                                                    onCancelEdit: () {
                                                      isEditingEmail = false;
                                                      setState(() {});
                                                    },
                                                    onSave: () async {
                                                      {
                                                        setState(() {
                                                          username = false;
                                                        });
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());
                                                        bool authenticated =
                                                            await performReAuthenticationAction(
                                                                context:
                                                                    context,
                                                                username:
                                                                    username);
                                                        if (authenticated) {
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          var res = await AuthMethods()
                                                              .changeEmail(
                                                                  email:
                                                                      _emailController
                                                                          .text);

                                                          if (res ==
                                                              'success') {
                                                            UserProvider
                                                                userProvider =
                                                                Provider.of(
                                                                    context,
                                                                    listen:
                                                                        false);
                                                            await userProvider
                                                                .refreshUser();
                                                          } else {
                                                            showSnackBar(
                                                                res, context);
                                                          }
                                                          isEditingEmail =
                                                              false;
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        }
                                                      }
                                                    }),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: UserFieldListTile(
                                                    label: "Bio",
                                                    minLines: 7,
                                                    maxLength: 500,
                                                    hintText:
                                                        "Write something about yourself ...",
                                                    value: user?.bio == ''
                                                        ? "-"
                                                        :
                                                        // trimText(
                                                        //     text:
                                                        '${user?.bio}',
                                                    // ),
                                                    isEditing: isEditingBio,
                                                    textController:
                                                        _bioController,
                                                    topPadding: 16,
                                                    onEdit: () {
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds: 50),
                                                          () {
                                                        _bioController.text =
                                                            user?.bio ?? '';
                                                        isEditingBio = true;
                                                        setState(() {});
                                                      });
                                                    },
                                                    onCancelEdit: () {
                                                      isEditingBio = false;
                                                      setState(() {});
                                                    },
                                                    onSave: () async {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());

                                                      setState(() {
                                                        isLoading = true;
                                                      });

                                                      await AuthMethods()
                                                          .changeBio(
                                                              bio:
                                                                  _bioController
                                                                      .text
                                                                      .trim());

                                                      UserProvider
                                                          userProvider =
                                                          Provider.of(context,
                                                              listen: false);
                                                      await userProvider
                                                          .refreshUser();

                                                      isEditingBio = false;
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      showSnackBar(
                                                          'Bio successfully changed.',
                                                          context);
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Visibility(
                    visible: isLoading,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class UserFieldListTile extends StatelessWidget {
  final String label;
  final String? value;
  final TextEditingController textController;
  final VoidCallback onEdit;
  final VoidCallback onCancelEdit;
  final VoidCallback onSave;
  final bool isEditing;
  final String hintText;
  final int? minLines;
  final int? maxLength;
  final String? counterText;
  final double topPadding;
  final textInputAction;

  const UserFieldListTile({
    super.key,
    required this.label,
    required this.value,
    required this.onEdit,
    required this.textController,
    required this.onCancelEdit,
    required this.onSave,
    required this.isEditing,
    required this.hintText,
    this.minLines,
    required this.maxLength,
    this.counterText,
    required this.topPadding,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        left: 12,
        bottom: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          isEditing
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            controller: textController,
                            textInputAction: textInputAction,
                            maxLines: null,
                            maxLength: maxLength,
                            minLines: minLines,
                            decoration: InputDecoration(
                              counterText: counterText,
                              hintText: hintText,
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                left: 10,
                                top: topPadding,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 215, 215, 215),
                                    width: 0),
                              ),
                              fillColor:
                                  const Color.fromARGB(255, 245, 245, 245),
                              filled: true,
                            )),
                      ),
                      // Container(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 27,
                            width: 58,
                            child: InkWell(
                              onTap: onSave,
                              child: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                                size: 22,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: onCancelEdit,
                            child: const SizedBox(
                              height: 27,
                              width: 30,
                              child: Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        value ?? '-',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, left: 10),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Material(
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            splashColor: Colors.grey.withOpacity(0.5),
                            onTap: onEdit,
                            child: const Icon(
                              Icons.edit,
                              color: Color.fromARGB(255, 70, 70, 70),
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ],
      ),
    );
  }
}
