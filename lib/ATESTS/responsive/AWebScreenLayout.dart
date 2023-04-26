import 'package:flutter/material.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  var messages = 'false';
  var global = 'false';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Text(''),
      );
}
