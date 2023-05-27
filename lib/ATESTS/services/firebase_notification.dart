import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aft/ATESTS/provider/filter_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../responsive/AMobileScreenLayout.dart';
import '../utils/global_variables.dart';

class FirebaseNotification {
  static bool mostLikedNav = false;
  static String mostLikedPageType = '';
  static String mostLikedCountry = '';

  static int id = 0;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // final StreamController<String?> selectNotificationStream =
  // StreamController<String?>.broadcast();

  static grantNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  static setupLocalNotifications() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      '@mipmap/icon_notif',
    );
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    mostLikedNav = false;
    // debugPrint(
    //     'notification click foreground ${notificationResponse.id} ${notificationResponse.payload}');
    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        final data = json.decode(notificationResponse.payload!);
        // debugPrint("selectedNotification working${data} ");

        if (data.isNotEmpty) {
          switch (data['type']) {
            case 'gm':
              if (navigatorKey.currentContext != null) {
                Provider.of<FilterProvider>(navigatorKey.currentContext!,
                        listen: false)
                    .setOneValue('Most Recent');
                Navigator.push(navigatorKey.currentContext!,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const MobileScreenLayout(
                    pageIndex: 1,
                  );
                }));
              }
              break;
            case 'gp':
              if (navigatorKey.currentContext != null) {
                Provider.of<FilterProvider>(navigatorKey.currentContext!,
                        listen: false)
                    .setOneValue('Most Recent');
                Provider.of<FilterProvider>(navigatorKey.currentContext!,
                        listen: false)
                    .setMessage('false');
                Navigator.push(navigatorKey.currentContext!,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const MobileScreenLayout(pageIndex: 1);
                }));
              }
              break;
            case 'np':
              String countryCode = data['country'];
              if (navigatorKey.currentContext != null) {
                Provider.of<FilterProvider>(navigatorKey.currentContext!,
                        listen: false)
                    .setOneValue('Most Recent');
                Provider.of<FilterProvider>(navigatorKey.currentContext!,
                        listen: false)
                    .setMessage('false');
                Provider.of<FilterProvider>(navigatorKey.currentContext!,
                        listen: false)
                    .setCountryByString(countryCode);
                Provider.of<FilterProvider>(navigatorKey.currentContext!,
                        listen: false)
                    .setGlobal('false');

                Navigator.push(navigatorKey.currentContext!,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const MobileScreenLayout(
                    pageIndex: 1,
                  );
                }));
              }
              break;
            case 'nm':
              String countryCode = data['country'];
              if (navigatorKey.currentContext != null) {
                Provider.of<FilterProvider>(navigatorKey.currentContext!,
                        listen: false)
                    .setOneValue('Most Recent');
                Provider.of<FilterProvider>(navigatorKey.currentContext!,
                        listen: false)
                    .setMessage('true');
                Provider.of<FilterProvider>(navigatorKey.currentContext!,
                        listen: false)
                    .setCountryByString(countryCode);
                Provider.of<FilterProvider>(navigatorKey.currentContext!,
                        listen: false)
                    .setGlobal('false');

                Navigator.push(navigatorKey.currentContext!,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const MobileScreenLayout(
                    pageIndex: 1,
                  );
                }));
              }
              break;
            default:
              // debugPrint("error");
              break;
          }
        }
        break;
      case NotificationResponseType.selectedNotificationAction:
        // if (notificationResponse.actionId == navigationActionId) {
        //   //    selectNotificationStream.add(notificationResponse.payload);
        // }
        break;
    }
  }

  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {}

  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
      "id", "Notification_name",
      showBadge: true, importance: Importance.high);

  static listenForegroundMessages() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // debugPrint(
      //     'Got a message whilst in the foreground! ${message.data} ${message.notification}');
      // debugPrint('Message data: ${message.data}');

      if (message.notification?.android?.imageUrl != null ||
          message.notification?.apple?.imageUrl != null) {
        if (Platform.isAndroid) {
          showBigPictureNotificationHiddenLargeIcon(message);
        } else if (Platform.isIOS) {
          showNotificationWithClippedThumbnailAttachment(message);
        }
      } else {
        flutterLocalNotificationsPlugin.show(
          id++,
          message.notification?.title,
          message.notification?.body,
          payload: json.encode(message.data),
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelShowBadge: channel.showBadge,
              styleInformation:
                  BigTextStyleInformation(message.notification?.body ?? ''),
              //     icon: '@mipmap/ic_notification_icon.png',
              //color: const Color(0xffffffff)
              // icon:"drawable/app_icon",
              //color:  Color(0xfffe6017),

              //  fullScreenIntent: true,
              // visibility: NotificationVisibility.public
            ),
          ),
        );
      }
      if (message.notification != null) {
        // debugPrint(
        //     'Message also contained a notification: ${message.notification}');
      }
    });
  }

  static Future<void> showNotificationWithClippedThumbnailAttachment(
      RemoteMessage message) async {
    final String bigPicturePath = await _downloadAndSaveFile(
        message.notification!.apple!.imageUrl!, 'bigPicture.jpg');
    final DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(attachments: <DarwinNotificationAttachment>[
      DarwinNotificationAttachment(
        bigPicturePath,
        thumbnailClippingRect:
            // lower right quadrant of the attachment
            const DarwinNotificationAttachmentThumbnailClippingRect(
          x: 0.5,
          y: 0.5,
          height: 0.5,
          width: 0.5,
        ),
      )
    ]);
    final NotificationDetails notificationDetails = NotificationDetails(
        iOS: darwinNotificationDetails, macOS: darwinNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++,
        message.notification?.title,
        message.notification?.body,
        payload: json.encode(message.data),
        notificationDetails);
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(
      RemoteMessage message) async {
    String imagePath = '';
    if (Platform.isAndroid) {
      imagePath = message.notification!.android!.imageUrl!;
    } else if (Platform.isIOS) {
      imagePath = message.notification!.apple!.imageUrl!;
    }
    final largeIconPath = await _downloadAndSaveFile(imagePath, 'largeIcon');
    final String bigPicturePath =
        await _downloadAndSaveFile(imagePath, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
            hideExpandedLargeIcon: true,
            contentTitle: message.notification?.title,
            htmlFormatContentTitle: true,
            summaryText: message.notification?.body,
            htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'big text channel id', 'big text channel name',
            channelDescription: 'big text channel description',
            icon: '@mipmap/icon_notif',
            largeIcon: FilePathAndroidBitmap(largeIconPath),
            styleInformation: bigPictureStyleInformation);
    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++,
        message.notification?.title,
        message.notification?.body,
        payload: json.encode(message.data),
        notificationDetails);
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static Future<String?> getToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('fcmToken $fcmToken');
    return fcmToken;
  }

  static unSubscribeTopic(String topic) async {
    try {
      // debugPrint('unsubscribing topic $topic');
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    } catch (e) {
      // debugPrint('unSubscribeTopic error $e $st');
    }
  }

  static onBackgroundMessageTap() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // debugPrint("onTap working   message data : ${message.data}");
      mostLikedNav = false;
      if (message.data.isNotEmpty) {
        String value = message.data['type'];
        // debugPrint('value is $value');

        switch (value) {
          case 'gm':
            if (navigatorKey.currentContext != null) {
              Provider.of<FilterProvider>(navigatorKey.currentContext!,
                      listen: false)
                  .setOneValue('Most Recent');
              Navigator.push(navigatorKey.currentContext!,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const MobileScreenLayout(
                  pageIndex: 1,
                );
              }));
            }
            break;
          case 'gp':
            if (navigatorKey.currentContext != null) {
              Provider.of<FilterProvider>(navigatorKey.currentContext!,
                      listen: false)
                  .setOneValue('Most Recent');
              Provider.of<FilterProvider>(navigatorKey.currentContext!,
                      listen: false)
                  .setMessage('false');
              Navigator.push(navigatorKey.currentContext!,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const MobileScreenLayout(
                  pageIndex: 1,
                );
              }));
            }
            break;
          case 'np':
            String countryCode = message.data['country'];
            if (navigatorKey.currentContext != null) {
              Provider.of<FilterProvider>(navigatorKey.currentContext!,
                      listen: false)
                  .setOneValue('Most Recent');
              Provider.of<FilterProvider>(navigatorKey.currentContext!,
                      listen: false)
                  .setMessage('false');
              Provider.of<FilterProvider>(navigatorKey.currentContext!,
                      listen: false)
                  .setCountryByString(countryCode);
              Provider.of<FilterProvider>(navigatorKey.currentContext!,
                      listen: false)
                  .setGlobal('false');

              Navigator.push(navigatorKey.currentContext!,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const MobileScreenLayout(
                  pageIndex: 1,
                );
              }));
            }
            break;
          case 'nm':
            String countryCode = message.data['country'];
            if (navigatorKey.currentContext != null) {
              Provider.of<FilterProvider>(navigatorKey.currentContext!,
                      listen: false)
                  .setOneValue('Most Recent');
              Provider.of<FilterProvider>(navigatorKey.currentContext!,
                      listen: false)
                  .setMessage('true');
              Provider.of<FilterProvider>(navigatorKey.currentContext!,
                      listen: false)
                  .setCountryByString(countryCode);
              Provider.of<FilterProvider>(navigatorKey.currentContext!,
                      listen: false)
                  .setGlobal('false');

              Navigator.push(navigatorKey.currentContext!,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const MobileScreenLayout(
                  pageIndex: 1,
                );
              }));
            }
            break;
          default:
            // debugPrint("error");
            break;
        }
      }
    });
  }

  static onInitialMessageTap() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        if (message.data.isNotEmpty) {
          String value = message.data['type'];
          // debugPrint('value is $value');
          mostLikedNav = true;
          mostLikedPageType = value;
          mostLikedCountry = message.data['country'];
        }
      }
    });
  }

  static subscribeTopic(String topic) async {
    try {
      debugPrint('subscribeTopic triggered $topic');
      await FirebaseMessaging.instance.subscribeToTopic(topic);
    } catch (e) {
      // debugPrint('subscribeTopic $e $st');
    }
  }
}
