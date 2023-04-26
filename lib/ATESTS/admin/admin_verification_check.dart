import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import '../models/user.dart';
import '../screens/full_image_profile.dart';

class AdminVerificationCheck extends StatefulWidget {
  final User user;

  const AdminVerificationCheck({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<AdminVerificationCheck> createState() => _AdminVerificationCheckState();
}

class _AdminVerificationCheckState extends State<AdminVerificationCheck> {
  late User _user;

  @override
  void initState() {
    super.initState();

    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    _user = widget.user;

    return Column(
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Future.delayed(
                  const Duration(milliseconds: 150),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FullImageProfile(photo: _user.photoOne)),
                    );
                  },
                );
              },
              child: Container(
                  height: 170,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 241, 241, 241),
                  ),
                  child: Image.network(_user.photoOne ?? '',
                      width: 100, height: 100)),
            ),
            InkWell(
              onTap: () {
                Future.delayed(
                  const Duration(milliseconds: 150),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FullImageProfile(photo: _user.photoTwo)),
                    );
                  },
                );
              },
              child: Container(
                  height: 170,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 241, 241, 241),
                  ),
                  child: Image.network(_user.photoTwo ?? '',
                      width: 100, height: 100)),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
