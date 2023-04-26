import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../methods/auth_methods.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';

class ChangeUserFieldValues extends StatefulWidget {
  const ChangeUserFieldValues({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeUserFieldValues> createState() => _ChangeUserFieldValuesState();
}

class _ChangeUserFieldValuesState extends State<ChangeUserFieldValues> {
  bool isUsername = false;
  bool isEmail = false;
  bool isCountry = false;
  bool isPending = false;
  bool isPhotoUrl = false;
  bool isUserReportCounter = false;
  bool isAdmin = false;

  bool isSearchResults = false;

  bool isViewAdmin = false;

  String newUsernameChanged = '';
  String newEmailChanged = '';
  String newCountryChanged = '';
  String newPendingChanged = '';
  bool newPhotoUrlChanged = false;
  bool newUserReportCounterChanged = false;
  bool newUserReportCounterChangedTo3 = false;
  bool newAdminChanged = false;

  String searchUsernameValue = '';
  String searchEmailValue = '';

  final TextEditingController _searchEmailController = TextEditingController();
  final TextEditingController _searchUsernameController =
      TextEditingController();
  final TextEditingController _changeUsernameController =
      TextEditingController();
  final TextEditingController _changeEmailController = TextEditingController();
  final TextEditingController _changeCountryController =
      TextEditingController();

  List<User> postsList = [];
  StreamSubscription? loadDataStream;
  StreamController<User> updatingStream = StreamController.broadcast();

  List<User> viewAdminPostsList = [];
  StreamSubscription? viewAdminLoadDataStream;
  StreamController<User> viewAdminUpdatingStream = StreamController.broadcast();

  void adminUserChanges(uid, value, type) async {
    try {
      String res = await AuthMethods()
          .adminUserChanges(uid: uid, value: value, type: type);

      if (res == "success") {
        type == 'username'
            ? setState(() {
                newUsernameChanged = value;
                _changeUsernameController.clear();
              })
            : type == 'email'
                ? setState(() {
                    newEmailChanged = value;
                    _changeEmailController.clear();
                  })
                : type == 'country'
                    ? setState(() {
                        newCountryChanged = value;
                        _changeCountryController.clear();
                      })
                    : type == 'pending'
                        ? setState(() {
                            newPendingChanged = value;
                          })
                        : type == 'photoUrl'
                            ? setState(() {
                                newPhotoUrlChanged = true;
                              })
                            : type == 'reportCounter'
                                ? setState(() {
                                    value == 0
                                        ? newUserReportCounterChanged = true
                                        : newUserReportCounterChangedTo3 = true;
                                  })
                                : type == 'admin'
                                    ? setState(() {
                                        newAdminChanged = true;
                                      })
                                    : null;
      } else {}
    } catch (e) {
      // showSnackBar(e.toString(), context);
    }
  }

  // void adminChangeEmail(uid, newEmail) async {
  //   try {
  //     String res =
  //         await AuthMethods().adminChangeEmail(uid: uid, newEmail: newEmail);

  //     if (res == "success") {
  //       setState(() {
  //         newEmailChanged = newEmail;
  //         _changeUsernameController.clear();
  //       });
  //     } else {}
  //   } catch (e) {
  //     // showSnackBar(e.toString(), context);
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (loadDataStream != null) {
      loadDataStream!.cancel();
    }
    if (viewAdminLoadDataStream != null) {
      viewAdminLoadDataStream!.cancel();
    }
  }

  // Future<void>
  initList() async {
    if (loadDataStream != null) {
      loadDataStream!.cancel();
      postsList = [];
    }
    loadDataStream = FirebaseFirestore.instance
        .collection('users')
        .where(searchUsernameValue != '' ? 'usernameLower' : 'aEmail',
            isEqualTo: searchUsernameValue != ''
                ? searchUsernameValue
                : searchEmailValue)
        .limit(1)
        .snapshots()
        .listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            postsList.add(User.fromMap(
              {...change.doc.data()!, 'updatingStream': updatingStream},
              // 0
            )); // we are adding to a local list when the element is added in firebase collection
            break; //the Post element we will send on pair with updatingStream, because a Post constructor makes a listener on a stream.
          case DocumentChangeType.modified:
            updatingStream.add(User.fromMap(
              {...change.doc.data()!},
              // 0
            )); // we are sending a modified object in the stream.
            break;
          case DocumentChangeType.removed:
            postsList.remove(User.fromMap(
              {...change.doc.data()!},
              // 0
            )); // we are removing a Post object from the local list.
            break;
        }
      }
      setState(() {});
    });
  }

  viewAdminList() async {
    if (viewAdminLoadDataStream != null) {
      viewAdminLoadDataStream!.cancel();
      viewAdminPostsList = [];
    }
    viewAdminLoadDataStream = FirebaseFirestore.instance
        .collection('users')
        .where('admin', isEqualTo: true)
        .limit(10)
        .snapshots()
        .listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            viewAdminPostsList.add(User.fromMap(
              {
                ...change.doc.data()!,
                'updatingStream': viewAdminUpdatingStream
              },
              // 0
            )); // we are adding to a local list when the element is added in firebase collection
            break; //the Post element we will send on pair with updatingStream, because a Post constructor makes a listener on a stream.
          case DocumentChangeType.modified:
            viewAdminUpdatingStream.add(User.fromMap(
              {...change.doc.data()!},
              // 0
            )); // we are sending a modified object in the stream.
            break;
          case DocumentChangeType.removed:
            viewAdminPostsList.remove(User.fromMap(
              {...change.doc.data()!},
              // 0
            )); // we are removing a Post object from the local list.
            break;
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.05),
          appBar: AppBar(
            elevation: 4,
            toolbarHeight: 56,
            backgroundColor: Colors.white,
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, right: 8, left: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
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
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Icon(Icons.arrow_back,
                                        color: Color.fromARGB(255, 80, 80, 80)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              const Text('Change User Values',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              setState(
                                () {
                                  isViewAdmin = true;
                                  viewAdminList();
                                },
                              );
                            },
                            child: PhysicalModel(
                              elevation: 2,
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Column(
                                  children: const [
                                    Text(
                                      'View Admins',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
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
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: isViewAdmin
                  ? ListView.builder(
                      itemCount: viewAdminPostsList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final User? user =
                            Provider.of<UserProvider>(context).getUser;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    viewAdminPostsList[index].username,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    )
                  : Column(
                      children: [
                        Column(
                          children: [
                            PhysicalModel(
                              color: Colors.transparent,
                              elevation: 3,
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Theme(
                                  data: ThemeData(
                                    colorScheme:
                                        ThemeData().colorScheme.copyWith(
                                              primary: const Color.fromARGB(
                                                  255, 131, 135, 138),
                                            ),
                                  ),
                                  child: TextField(
                                    onChanged: (val) {
                                      setState(() {});
                                    },
                                    maxLines: 1,
                                    controller: _searchUsernameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Search for Username',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                        top: 12,
                                      ),
                                      prefixIcon: Icon(Icons.search,
                                          color: Colors.grey, size: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            PhysicalModel(
                              color: Colors.transparent,
                              elevation: 3,
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Theme(
                                  data: ThemeData(
                                    colorScheme:
                                        ThemeData().colorScheme.copyWith(
                                              primary: const Color.fromARGB(
                                                  255, 131, 135, 138),
                                            ),
                                  ),
                                  child: TextField(
                                    onChanged: (val) {
                                      setState(() {});
                                    },
                                    maxLines: 1,
                                    controller: _searchEmailController,
                                    decoration: const InputDecoration(
                                      hintText: 'Search for Email',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                        // left: 12,
                                        top: 12,
                                      ),
                                      prefixIcon: Icon(Icons.search,
                                          color: Colors.grey, size: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        PhysicalModel(
                          color: isSearchResults
                              ? const Color.fromARGB(255, 255, 99, 88)
                              : Colors.blue,
                          elevation: 3,
                          borderRadius: BorderRadius.circular(5),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.white.withOpacity(0.4),
                              onTap: () {
                                isSearchResults == false
                                    ? setState(() {
                                        isSearchResults = true;
                                        searchUsernameValue =
                                            _searchUsernameController.text;
                                        searchEmailValue =
                                            _searchEmailController.text;
                                        initList();
                                        newUsernameChanged = '';
                                        newEmailChanged = '';
                                        newEmailChanged = '';
                                        newCountryChanged = '';
                                        newPendingChanged = '';
                                        newPhotoUrlChanged = false;
                                        newUserReportCounterChanged = false;
                                        newUserReportCounterChangedTo3 = false;
                                        newAdminChanged = false;
                                        isUsername = false;
                                        isCountry = false;
                                        isEmail = false;
                                        isAdmin = false;
                                        isPhotoUrl = false;
                                        isUserReportCounter = false;
                                        isPending = false;
                                      })
                                    : setState(() {
                                        isSearchResults = false;
                                        _searchUsernameController.clear();
                                        _searchEmailController.clear();
                                        _changeUsernameController.clear();
                                        _changeEmailController.clear();
                                        searchUsernameValue =
                                            _searchUsernameController.text;
                                        searchEmailValue =
                                            _searchEmailController.text;
                                        newUsernameChanged = '';
                                        newEmailChanged = '';
                                        newEmailChanged = '';
                                        newCountryChanged = '';
                                        newPendingChanged = '';
                                        newPhotoUrlChanged = false;
                                        newUserReportCounterChanged = false;
                                        newUserReportCounterChangedTo3 = false;
                                        newAdminChanged = false;
                                        isUsername = false;
                                        isCountry = false;
                                        isEmail = false;
                                        isAdmin = false;
                                        isPhotoUrl = false;
                                        isUserReportCounter = false;
                                        isPending = false;
                                      });
                              },
                              child: SizedBox(
                                // padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 45,
                                child: Center(
                                  child: Text(
                                    isSearchResults
                                        ? 'Clear Results'
                                        : 'View Results',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        isSearchResults
                            ? Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 4),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                        searchUsernameValue != ''
                                            ? 'Results for username: ${_searchUsernameController.text}'
                                            : searchEmailValue != ''
                                                ? 'Results for email: ${_searchEmailController.text}'
                                                : '',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                  const SizedBox(height: 8),
                                  postsList.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: postsList.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            final User? user =
                                                Provider.of<UserProvider>(
                                                        context)
                                                    .getUser;
                                            return Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isUsername == true
                                                          ? isUsername = false
                                                          : isUsername = true;
                                                    });
                                                  },
                                                  child: PhysicalModel(
                                                    color: isUsername
                                                        ? const Color.fromARGB(
                                                            255, 214, 236, 255)
                                                        : Colors.white,
                                                    elevation: 2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 16,
                                                                  bottom: 16),
                                                          child: Column(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      right: 10,
                                                                      left: 10,
                                                                    ),
                                                                    child:
                                                                        SizedBox(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      child:
                                                                          Text(
                                                                        'Username: ${postsList[index].username}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        newUsernameChanged != ''
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            16),
                                                                child: Column(
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            right:
                                                                                10,
                                                                            left:
                                                                                10,
                                                                          ),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            child:
                                                                                Text(
                                                                              'Username changed to: $newUsernameChanged',
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                        isUsername
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  bottom: 16.0,
                                                                  right: 8,
                                                                  left: 8,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    PhysicalModel(
                                                                      color: Colors
                                                                          .transparent,
                                                                      elevation:
                                                                          3,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            45,
                                                                        width: MediaQuery.of(context).size.width *
                                                                                0.75 -
                                                                            40,
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          // border: Border.all(
                                                                          //     width: 0.75, color: Colors.grey),
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(5.0),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Theme(
                                                                          data:
                                                                              ThemeData(
                                                                            colorScheme: ThemeData().colorScheme.copyWith(
                                                                                  primary: const Color.fromARGB(255, 131, 135, 138),
                                                                                ),
                                                                          ),
                                                                          child:
                                                                              TextField(
                                                                            onChanged:
                                                                                (val) {
                                                                              setState(() {});
                                                                            },
                                                                            maxLines:
                                                                                1,
                                                                            controller:
                                                                                _changeUsernameController,
                                                                            decoration:
                                                                                const InputDecoration(
                                                                              hintText: 'Change Username',
                                                                              labelStyle: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontStyle: FontStyle.normal,
                                                                              ),
                                                                              hintStyle: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.grey,
                                                                                fontStyle: FontStyle.normal,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                              border: InputBorder.none,
                                                                              contentPadding: EdgeInsets.only(
                                                                                top: 12,
                                                                              ),
                                                                              prefixIcon: Icon(Icons.change_circle, color: Colors.grey, size: 18),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            8),
                                                                    PhysicalModel(
                                                                      color: Colors
                                                                          .blue,
                                                                      elevation:
                                                                          3,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            InkWell(
                                                                          splashColor: Colors
                                                                              .white
                                                                              .withOpacity(0.4),
                                                                          onTap:
                                                                              () async {
                                                                            adminUserChanges(
                                                                                postsList[index].UID,
                                                                                _changeUsernameController.text,
                                                                                'username');
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 16),
                                                                            height:
                                                                                45,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.25,
                                                                            child:
                                                                                const Center(
                                                                              child: Text(
                                                                                'Change',
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isEmail == true
                                                          ? isEmail = false
                                                          : isEmail = true;
                                                    });
                                                  },
                                                  child: PhysicalModel(
                                                    color: isEmail
                                                        ? const Color.fromARGB(
                                                            255, 214, 236, 255)
                                                        : Colors.white,
                                                    elevation: 2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 16,
                                                                  bottom: 16),
                                                          child: Column(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      right: 10,
                                                                      left: 10,
                                                                    ),
                                                                    child:
                                                                        SizedBox(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      child:
                                                                          Text(
                                                                        'Email: ${postsList[index].aEmail}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        newEmailChanged != ''
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            16),
                                                                child: Column(
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            right:
                                                                                10,
                                                                            left:
                                                                                10,
                                                                          ),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            child:
                                                                                Text(
                                                                              'Email changed to: $newEmailChanged',
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                        isEmail
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  bottom: 16.0,
                                                                  right: 8,
                                                                  left: 8,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    PhysicalModel(
                                                                      color: Colors
                                                                          .transparent,
                                                                      elevation:
                                                                          3,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            45,
                                                                        width: MediaQuery.of(context).size.width *
                                                                                0.75 -
                                                                            40,
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(5.0),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Theme(
                                                                          data:
                                                                              ThemeData(
                                                                            colorScheme: ThemeData().colorScheme.copyWith(
                                                                                  primary: const Color.fromARGB(255, 131, 135, 138),
                                                                                ),
                                                                          ),
                                                                          child:
                                                                              TextField(
                                                                            onChanged:
                                                                                (val) {
                                                                              setState(() {});
                                                                            },
                                                                            maxLines:
                                                                                1,
                                                                            controller:
                                                                                _changeEmailController,
                                                                            decoration:
                                                                                const InputDecoration(
                                                                              hintText: 'Change Email',
                                                                              labelStyle: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontStyle: FontStyle.normal,
                                                                              ),
                                                                              hintStyle: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.grey,
                                                                                fontStyle: FontStyle.normal,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                              border: InputBorder.none,
                                                                              contentPadding: EdgeInsets.only(
                                                                                top: 12,
                                                                              ),
                                                                              prefixIcon: Icon(Icons.change_circle, color: Colors.grey, size: 18),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            8),
                                                                    PhysicalModel(
                                                                      color: Colors
                                                                          .blue,
                                                                      elevation:
                                                                          3,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            InkWell(
                                                                          splashColor: Colors
                                                                              .white
                                                                              .withOpacity(0.4),
                                                                          onTap:
                                                                              () async {
                                                                            adminUserChanges(
                                                                                postsList[index].UID,
                                                                                _changeEmailController.text,
                                                                                'email');
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 16),
                                                                            height:
                                                                                45,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.25,
                                                                            child:
                                                                                const Center(
                                                                              child: Text(
                                                                                'Change',
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isCountry == true
                                                          ? isCountry = false
                                                          : isCountry = true;
                                                    });
                                                  },
                                                  child: PhysicalModel(
                                                    color: isCountry
                                                        ? const Color.fromARGB(
                                                            255, 214, 236, 255)
                                                        : Colors.white,
                                                    elevation: 2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 16,
                                                                  bottom: 16),
                                                          child: Column(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      right: 10,
                                                                      left: 10,
                                                                    ),
                                                                    child:
                                                                        SizedBox(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      child:
                                                                          Text(
                                                                        'Country: ${postsList[index].aaCountry}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        newCountryChanged != ''
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            16),
                                                                child: Column(
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            right:
                                                                                10,
                                                                            left:
                                                                                10,
                                                                          ),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            child:
                                                                                Text(
                                                                              'Country changed to: $newCountryChanged',
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                        isCountry
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  bottom: 16.0,
                                                                  right: 8,
                                                                  left: 8,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    PhysicalModel(
                                                                      color: Colors
                                                                          .transparent,
                                                                      elevation:
                                                                          3,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            45,
                                                                        width: MediaQuery.of(context).size.width *
                                                                                0.75 -
                                                                            40,
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(5.0),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Theme(
                                                                          data:
                                                                              ThemeData(
                                                                            colorScheme: ThemeData().colorScheme.copyWith(
                                                                                  primary: const Color.fromARGB(255, 131, 135, 138),
                                                                                ),
                                                                          ),
                                                                          child:
                                                                              TextField(
                                                                            onChanged:
                                                                                (val) {
                                                                              setState(() {});
                                                                            },
                                                                            maxLines:
                                                                                1,
                                                                            controller:
                                                                                _changeCountryController,
                                                                            decoration:
                                                                                const InputDecoration(
                                                                              hintText: 'Change Country',
                                                                              labelStyle: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontStyle: FontStyle.normal,
                                                                              ),
                                                                              hintStyle: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.grey,
                                                                                fontStyle: FontStyle.normal,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                              border: InputBorder.none,
                                                                              contentPadding: EdgeInsets.only(
                                                                                top: 12,
                                                                              ),
                                                                              prefixIcon: Icon(Icons.change_circle, color: Colors.grey, size: 18),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            8),
                                                                    PhysicalModel(
                                                                      color: Colors
                                                                          .blue,
                                                                      elevation:
                                                                          3,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            InkWell(
                                                                          splashColor: Colors
                                                                              .white
                                                                              .withOpacity(0.4),
                                                                          onTap:
                                                                              () async {
                                                                            adminUserChanges(
                                                                                postsList[index].UID,
                                                                                _changeCountryController.text,
                                                                                'country');
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 16),
                                                                            height:
                                                                                45,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.25,
                                                                            child:
                                                                                const Center(
                                                                              child: Text(
                                                                                'Change',
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isPending == true
                                                          ? isPending = false
                                                          : isPending = true;
                                                    });
                                                  },
                                                  child: PhysicalModel(
                                                    color: isPending
                                                        ? const Color.fromARGB(
                                                            255, 214, 236, 255)
                                                        : Colors.white,
                                                    elevation: 2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 16,
                                                                  bottom: 16,
                                                                  right: 10,
                                                                  left: 10),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child: Text(
                                                                  'Pending: ${postsList[index].pending}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        newPendingChanged != ''
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            16),
                                                                child: Column(
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            right:
                                                                                10,
                                                                            left:
                                                                                10,
                                                                          ),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            child:
                                                                                Text(
                                                                              'Pending changed to: $newPendingChanged',
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                        isPending
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  bottom: 16.0,
                                                                  right: 8,
                                                                  left: 8,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    PhysicalModel(
                                                                      color: Colors
                                                                          .blue,
                                                                      elevation:
                                                                          3,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            InkWell(
                                                                          splashColor: Colors
                                                                              .white
                                                                              .withOpacity(0.4),
                                                                          onTap:
                                                                              () async {
                                                                            adminUserChanges(
                                                                                postsList[index].UID,
                                                                                postsList[index].pending == 'false' ? 'true' : 'false',
                                                                                'pending');
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 16),
                                                                            height:
                                                                                45,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.4,
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                postsList[index].pending == 'false' ? 'Change to true' : 'Change to false',
                                                                                style: const TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isPhotoUrl == true
                                                          ? isPhotoUrl = false
                                                          : isPhotoUrl = true;
                                                    });
                                                  },
                                                  child: PhysicalModel(
                                                    color: isPhotoUrl
                                                        ? const Color.fromARGB(
                                                            255, 214, 236, 255)
                                                        : Colors.white,
                                                    elevation: 2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 9,
                                                                  bottom: 9),
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  right: 10,
                                                                  left: 10,
                                                                ),
                                                                child: SizedBox(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  child: Row(
                                                                    children: [
                                                                      const Text(
                                                                          'Profile Picture:',
                                                                          style:
                                                                              TextStyle(fontSize: 16)),
                                                                      const SizedBox(
                                                                          width:
                                                                              8),
                                                                      postsList[index].photoUrl !=
                                                                              null
                                                                          ? Material(
                                                                              color: Colors.grey,
                                                                              shape: const CircleBorder(),
                                                                              clipBehavior: Clip.hardEdge,
                                                                              child: Ink.image(
                                                                                image: NetworkImage(postsList[index].photoUrl ?? ''),
                                                                                fit: BoxFit.cover,
                                                                                width: 35,
                                                                                height: 35,
                                                                                child: InkWell(
                                                                                  splashColor: Colors.white.withOpacity(0.5),
                                                                                  onTap: () {
                                                                                    Future.delayed(
                                                                                      const Duration(milliseconds: 100),
                                                                                      () {},
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : Material(
                                                                              color: Colors.grey,
                                                                              shape: const CircleBorder(),
                                                                              clipBehavior: Clip.hardEdge,
                                                                              child: Ink.image(
                                                                                image: const AssetImage('assets/avatarFT.jpg'),
                                                                                fit: BoxFit.cover,
                                                                                width: 35,
                                                                                height: 35,
                                                                                child: InkWell(
                                                                                  splashColor: Colors.white.withOpacity(0.5),
                                                                                  onTap: () {
                                                                                    Future.delayed(
                                                                                      const Duration(milliseconds: 100),
                                                                                      () {},
                                                                                    );
                                                                                  },
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
                                                        newPhotoUrlChanged !=
                                                                false
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            16),
                                                                child: Column(
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            right:
                                                                                10,
                                                                            left:
                                                                                10,
                                                                          ),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            child:
                                                                                const Text(
                                                                              'Photo changed to: null',
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                        isPhotoUrl
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  bottom: 16.0,
                                                                  right: 8,
                                                                  left: 8,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    postsList[index].photoUrl !=
                                                                            null
                                                                        ? Material(
                                                                            color:
                                                                                Colors.grey,
                                                                            shape:
                                                                                const CircleBorder(),
                                                                            clipBehavior:
                                                                                Clip.hardEdge,
                                                                            child:
                                                                                Ink.image(
                                                                              image: NetworkImage(postsList[index].photoUrl ?? ''),
                                                                              fit: BoxFit.cover,
                                                                              width: 150,
                                                                              height: 150,
                                                                              child: InkWell(
                                                                                splashColor: Colors.white.withOpacity(0.5),
                                                                                onTap: () {
                                                                                  Future.delayed(
                                                                                    const Duration(milliseconds: 100),
                                                                                    () {},
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : Material(
                                                                            color:
                                                                                Colors.grey,
                                                                            shape:
                                                                                const CircleBorder(),
                                                                            clipBehavior:
                                                                                Clip.hardEdge,
                                                                            child:
                                                                                Ink.image(
                                                                              image: const AssetImage('assets/avatarFT.jpg'),
                                                                              fit: BoxFit.cover,
                                                                              width: 150,
                                                                              height: 150,
                                                                              child: InkWell(
                                                                                splashColor: Colors.white.withOpacity(0.5),
                                                                                onTap: () {
                                                                                  Future.delayed(
                                                                                    const Duration(milliseconds: 100),
                                                                                    () {},
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    PhysicalModel(
                                                                      color: postsList[index].photoUrl !=
                                                                              null
                                                                          ? Colors
                                                                              .blue
                                                                          : const Color.fromARGB(
                                                                              255,
                                                                              230,
                                                                              230,
                                                                              230),
                                                                      elevation:
                                                                          3,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            InkWell(
                                                                          splashColor: Colors
                                                                              .white
                                                                              .withOpacity(0.4),
                                                                          onTap:
                                                                              () async {
                                                                            postsList[index].photoUrl != null
                                                                                ? adminUserChanges(postsList[index].UID, null, 'photoUrl')
                                                                                : null;
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 16),
                                                                            height:
                                                                                45,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.4,
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                postsList[index].photoUrl != null ? 'Change to null' : 'N/A',
                                                                                style: const TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isUserReportCounter ==
                                                              true
                                                          ? isUserReportCounter =
                                                              false
                                                          : isUserReportCounter =
                                                              true;
                                                    });
                                                  },
                                                  child: PhysicalModel(
                                                    color: isUserReportCounter
                                                        ? const Color.fromARGB(
                                                            255, 214, 236, 255)
                                                        : Colors.white,
                                                    elevation: 2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 16,
                                                                  bottom: 16),
                                                          child: Column(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      right: 10,
                                                                      left: 10,
                                                                    ),
                                                                    child:
                                                                        SizedBox(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      child:
                                                                          Text(
                                                                        'Report Counter: ${postsList[index].userReportCounter}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        newUserReportCounterChanged !=
                                                                    false ||
                                                                newUserReportCounterChangedTo3 !=
                                                                    false
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            16),
                                                                child: Column(
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            right:
                                                                                10,
                                                                            left:
                                                                                10,
                                                                          ),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            child:
                                                                                Text(
                                                                              newUserReportCounterChanged ? 'Report Counter changed to: 0' : 'Report Counter changed to: 3',
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                        isUserReportCounter
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  bottom: 16.0,
                                                                  right: 8,
                                                                  left: 8,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    PhysicalModel(
                                                                      color: Colors
                                                                          .blue,
                                                                      elevation:
                                                                          3,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            InkWell(
                                                                          splashColor: Colors
                                                                              .white
                                                                              .withOpacity(0.4),
                                                                          onTap:
                                                                              () async {
                                                                            adminUserChanges(
                                                                                postsList[index].UID,
                                                                                0,
                                                                                'reportCounter');
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 16),
                                                                            height:
                                                                                45,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.4,
                                                                            child:
                                                                                const Center(
                                                                              child: Text(
                                                                                'Change to 0',
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    PhysicalModel(
                                                                      color: Colors
                                                                          .red,
                                                                      elevation:
                                                                          3,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            InkWell(
                                                                          splashColor: Colors
                                                                              .white
                                                                              .withOpacity(0.4),
                                                                          onTap:
                                                                              () async {
                                                                            adminUserChanges(
                                                                                postsList[index].UID,
                                                                                3,
                                                                                'reportCounter');
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 16),
                                                                            height:
                                                                                45,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.4,
                                                                            child:
                                                                                const Center(
                                                                              child: Text(
                                                                                'Change to 3',
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isAdmin == true
                                                          ? isAdmin = false
                                                          : isAdmin = true;
                                                    });
                                                  },
                                                  child: PhysicalModel(
                                                    color: isAdmin
                                                        ? const Color.fromARGB(
                                                            255, 214, 236, 255)
                                                        : Colors.white,
                                                    elevation: 2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 16,
                                                                  bottom: 16),
                                                          child: Column(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      right: 10,
                                                                      left: 10,
                                                                    ),
                                                                    child:
                                                                        SizedBox(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      child:
                                                                          Text(
                                                                        'Admin: ${postsList[index].admin}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        newAdminChanged != false
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            16),
                                                                child: Column(
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            right:
                                                                                10,
                                                                            left:
                                                                                10,
                                                                          ),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            child:
                                                                                Text(
                                                                              postsList[index].admin ? 'Admin changed to: false' : 'Admin changed to: true',
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                        isAdmin
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  bottom: 16.0,
                                                                  right: 8,
                                                                  left: 8,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    PhysicalModel(
                                                                      color: Colors
                                                                          .blue,
                                                                      elevation:
                                                                          3,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            InkWell(
                                                                          splashColor: Colors
                                                                              .white
                                                                              .withOpacity(0.4),
                                                                          onTap:
                                                                              () async {
                                                                            adminUserChanges(
                                                                                postsList[index].UID,
                                                                                postsList[index].admin == false ? true : false,
                                                                                'admin');
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 16),
                                                                            height:
                                                                                45,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.4,
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                postsList[index].admin == false ? 'Change to true' : 'Change to false',
                                                                                style: const TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                              ],
                                            );
                                          },
                                        )
                                      : const Center(
                                          child: Text(
                                            'No Results Found.',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 114, 114, 114),
                                                fontSize: 18),
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
      ),
    );
  }
}
