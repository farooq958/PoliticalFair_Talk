import 'package:flutter/material.dart';

import '../screens/statistics.dart';
import '../utils/global_variables.dart';

class ProfileBio extends StatefulWidget {
  var bio;
  var username;

  ProfileBio({Key? key, required this.bio, required this.username})
      : super(key: key);

  @override
  State<ProfileBio> createState() => _ProfileBioState();
}

class _ProfileBioState extends State<ProfileBio> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: whiteDialog,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: whiteDialog,
              elevation: 4,
              toolbarHeight: 56,
              actions: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8),
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
                                size: 24,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text('About ${widget.username}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ]),
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: PhysicalModel(
                        elevation: 3,
                        color: testing,
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Text(
                            "${widget.bio}",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              letterSpacing: 0.3,
                              fontSize: 16,
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
    );
  }
}
