// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:ntp/ntp.dart';

// class TimerProvider extends ChangeNotifier {
//   Timer? _periodicTimer;
//   bool _expired = false;
//   bool _loading = false;
//   String _day = '', _hours = '', _minutes = '', _seconds = '';

//   String _timerString = '';

//   TimerProvider(DateTime endDate) {
//     init(endDate);
//   }

//   init(DateTime endDate) async {
//     _loading = true;
//     Future.delayed(Duration.zero);
//     notifyListeners();
//     DateTime startDate = await NTP.now();
//     _day = endDate.difference(startDate).inDays.toString();
//     _hours = endDate.difference(startDate).inHours.remainder(24).toString();
//     _minutes = endDate.difference(startDate).inMinutes.remainder(60).toString();
//     // _seconds = endDate.difference(startDate).inSeconds.remainder(60).toString();

//     _timerString = endDate.difference(startDate).inDays >= 1
//         ? '$_day Days'
//         : '${_hours}H ${_minutes}M';
//     _loading = false;

//     // print("INSIDE TIMER PROVIDER, init");
//     // print("(_timerString): ${(_timerString)}");

//     // Only notify listeners if the timer string changes
//     notifyListeners();
//     startTimer(endDate, startDate);
//   }

//   startTimer(DateTime endDate, DateTime startDate) {
//     _periodicTimer = Timer.periodic(
//       const Duration(minutes: 1),
//       (timer) {
//         if (endDate.isBefore(startDate)) {
//           _expired = true;
//           _timerString = 'None';
//           _periodicTimer?.cancel();
//         } else {
//           _expired = false;

//           DateTime n = startDate.add(const Duration(minutes: 1));
//           startDate = n;

//           _day = endDate.difference(startDate).inDays.toString();
//           _hours =
//               endDate.difference(startDate).inHours.remainder(24).toString();
//           _minutes =
//               endDate.difference(startDate).inMinutes.remainder(60).toString();
//           // _seconds =
//           //     endDate.difference(startDate).inSeconds.remainder(60).toString();

//           _timerString = endDate.difference(startDate).inDays >= 1
//               ? '$_day Days'
//               : '${_hours}H ${_minutes}M';

//           //    _timerString = 'D: $_day H:${_hours.toString().padLeft(2, '0')} M:${_minutes.toString().padLeft(2)} ${_seconds.toString().padLeft(2,'0')}';

//         }

//         // print("INSIDE TIMER PROVIDER, startTimer");
//         // print("(_timerString): ${(_timerString)}");

// // Only notify listeners if the timer string changes
//         notifyListeners();
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _periodicTimer?.cancel();
//     super.dispose();
//   }

//   String get timeString => _timerString;
// }
