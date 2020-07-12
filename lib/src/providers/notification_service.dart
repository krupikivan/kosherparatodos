import 'dart:io' show File, Platform;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  var initializationSettings;

  NotificationService._() {
    init();
  }

  void init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  void initializePlatformSpecifics() {
    final initializeAndroidSettings =
        AndroidInitializationSettings('@mipmap/icon_transparent');
    final initializeIOSSettings = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          final ReceivedNotification receiveNotification = ReceivedNotification(
              id: id, title: title, body: body, payload: payload);
          didReceiveLocalNotificationSubject.add(receiveNotification);
        });

    initializationSettings = InitializationSettings(
        initializeAndroidSettings, initializeIOSSettings);
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(alert: false, badge: true, sound: true);
  }

  void setListenerForLowerVersions(Function onNotificationInLowerVersions) =>
      didReceiveLocalNotificationSubject.listen((receivedNotification) {
        onNotificationInLowerVersions(receivedNotification);
      });

  void setOnNotificationClick(Function onNotificationClick) async =>
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (String payload) async {
        onNotificationClick(payload);
      });

  Future<void> showNotification(
      String title, String body, String payload) async {
    final androidChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL_ID', 'CHANNEL_NAME', 'CHANNEL_DESCRIPTIONS',
        importance: Importance.Max,
        priority: Priority.High,
        playSound: true,
        styleInformation: DefaultStyleInformation(true, true));
    final iosChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }
}

NotificationService notificationService = NotificationService._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}
