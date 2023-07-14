import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/post.dart';
import '../utils/global_variables.dart';

class FullImageScreen extends StatefulWidget {
  final Post post;
  const FullImageScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  late Post _post;

  @override
  void initState() {
    _post = widget.post;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var safePadding = MediaQuery.of(context).padding.top;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white.withOpacity(0.2),
            elevation: 0,
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
                            child: const Icon(Icons.arrow_back,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Container(width: 16),
                      const Text('Image Viewer',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 21,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: InteractiveViewer(
                  clipBehavior: Clip.none,
                  minScale: 1,
                  maxScale: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Center(
                        child: Container(
                          child: CircularProgressIndicator(
                            color: darkBlue,
                          ),
                          height: 25,
                          width: 25,
                        ),
                      ),
                      imageUrl: _post.aPostUrl,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
