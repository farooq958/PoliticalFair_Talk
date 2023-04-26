import 'package:flutter/material.dart';

class FullImageScreenAdd extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final file;

  const FullImageScreenAdd({Key? key, required this.file}) : super(key: key);

  @override
  State<FullImageScreenAdd> createState() => _FullImageScreenAddState();
}

class _FullImageScreenAddState extends State<FullImageScreenAdd> {
  @override
  void initState() {
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
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: SizedBox(
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
                      ),
                      Container(width: 22),
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
                    // height: MediaQuery.of(context).size.height * 1 -
                    //     safePadding -
                    //     kToolbarHeight,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: widget.file,
                        fit: BoxFit.contain,
                      )),
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
