import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class DurationProvider extends ChangeNotifier {
  // static Future<int> getDurationInDays() async {
  //   try {
  //     int durationInDay = 0;
  //     int oldDurationInDay = 0;
  //     var timeStr = "15/09/2022 01:00:000Z";
  //     // var timeStr = "15/09/2022 12:52:000Z";
  //     var dateTime = DateFormat('dd/MM/yy HH:mm:ss').parse(timeStr);

  //     var dateNow = await NTP.now();
  //     // debugPrint('est date is $dateNow');
  //     // var dateNow = ntpTime.toUtc();
  //     var duration = dateNow.difference(dateTime);
  //     var _dd = duration.inDays;
  //     durationInDay = _dd;

  //     return durationInDay;
  //   } catch (e) {
  //     // debugPrint('getDuration $e $st');
  //     return 0;
  //   }
  // }
}
