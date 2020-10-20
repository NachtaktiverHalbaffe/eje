import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform, File;

import 'package:rxdart/rxdart.dart';

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification> didReveivedLovalNotifications =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;

  //Constructor
  NotificationPlugin._() {
    init();
  }

//initialize Notificationsplugin
  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    //Request IOS permissions
    if (Platform.isIOS) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          .requestPermissions(alert: false, badge: true, sound: true);
    }
    //TODO Add notification icon
    var initializationSettingAndroid =
        AndroidInitializationSettings('app_notf_icon');
    var initializationSettingIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        ReceivedNotification receivedNotification = ReceivedNotification(
            id: id, title: title, body: body, payload: payload);
        didReveivedLovalNotifications.add(receivedNotification);
      },
    );
    //Settings for initialization
    initializationSettings = InitializationSettings(
        android: initializationSettingAndroid, iOS: initializationSettingIOS);
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersion) {
    didReveivedLovalNotifications.listen((receivedNotification) {
      onNotificationInLowerVersion(receivedNotification);
    });
  }

//initialization and set function which to execute when Notification is clicked
  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification(
      {@required int id,
      @required String title,
      String body,
      String payload,
      @required String channelId,
      @required String channelName,
      @required String channelDescription}) async {
    var paltformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        timeoutAfter: 5000,
        styleInformation: DefaultStyleInformation(true, true),
      ),
      iOS: IOSNotificationDetails(),
    );
    await FlutterLocalNotificationsPlugin().show(
      id,
      title,
      body,
      paltformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> scheduledNotification(
      {@required int id,
      @required String title,
      String body,
      String payload,
      @required DateTime scheduleNotificationsDateTime,
      @required String channelId,
      @required String channelName,
      @required String channelDescription}) async {
    var paltformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        styleInformation: DefaultStyleInformation(true, true),
      ),
      iOS: IOSNotificationDetails(),
    );
    await FlutterLocalNotificationsPlugin().schedule(
      id,
      title,
      body,
      scheduleNotificationsDateTime.subtract(Duration(days: 1)),
      paltformChannelSpecifics,
      payload: payload,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> showNotificationsDisabled() async {
    var paltformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        "0",
        "App-Benachrichtigungen",
        "Grundlegende Benachrichtigungen von der App über Appfunktionen",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        timeoutAfter: 5000,
        styleInformation: DefaultStyleInformation(true, true),
      ),
      iOS: IOSNotificationDetails(),
    );
    await FlutterLocalNotificationsPlugin().show(
      0,
      "Benachrichtigungen nicht aktiviert",
      "Bitte Benachrichtigungen in den Einstellungen aktivieren",
      paltformChannelSpecifics,
      payload: "4",
    );
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

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
