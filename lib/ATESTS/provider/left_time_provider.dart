import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:ntp/ntp.dart';

class LeftTimeProvider extends ChangeNotifier {
  DateTime _currentDate = DateTime.now();
  final DateTime _leftTime = DateTime.now();
  bool _loading = false;

  getDate() async {
    try {
      _loading = true;
      await Future.delayed(Duration.zero);
      //    // Uri url =Uri.parse('http://worldtimeapi.org/api/timezone/EST');
      //     Uri url =Uri.parse('https://us-central1-aft-flutter.cloudfunctions.net/getDateTime');
      //
      //
      //     var response= await http.get(url);
      //
      // debugPrint("getDate response is ${response.body} status code ; ${response.statusCode}");
      //   if(response.statusCode==200){
      //    // var data=jsonDecode(response.body);
      //
      //  //   String datetime = da;
      //     //String offset = data['utc_offset'];
      //      _startDate=DateTime.parse(response.body).toLocal();
      //
      //      debugPrint("current time  is $_startDate");
      //      debugPrint('now date ${DateTime.now()}');

      // }
      // _currentDate = await NTP.now();
      _currentDate = DateTime.now();
      _currentDate.toLocal();
      DateTime newdate = DateTime(2022, 1, 1, 00, 00);
    } catch (e) {
      //
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  DateTime get leftTime => _currentDate;

  bool get loading => _loading;
}
