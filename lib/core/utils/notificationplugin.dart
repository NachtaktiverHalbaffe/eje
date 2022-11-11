import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'dart:io' show Platform;
import 'package:rxdart/rxdart.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final BehaviorSubject<ReceivedNotification> didReveivedLovalNotifications =
      BehaviorSubject<ReceivedNotification>();
  // ignore: prefer_typing_uninitialized_variables
  var initializationSettings;

  //Constructor
  NotificationPlugin._() {
    init();
  }

//initialize Notificationsplugin
  init() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    //Request IOS permissions
    if (Platform.isIOS) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions(alert: false, badge: true, sound: true);
    }
    //TODO Add notification icon
    var initializationSettingAndroid =
        AndroidInitializationSettings('ic_launcher');
    var initializationSettingIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        ReceivedNotification receivedNotification = ReceivedNotification(
            id: id,
            title: title ?? "",
            body: body ?? "",
            payload: payload ?? "0");
        didReveivedLovalNotifications.add(receivedNotification);
      },
    );
    //Settings for initialization
    initializationSettings = InitializationSettings(
        android: initializationSettingAndroid, iOS: initializationSettingIOS);

    //initialization and set function which to execute when Notification is clicked
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersion) {
    didReveivedLovalNotifications.listen((receivedNotification) {
      onNotificationInLowerVersion(receivedNotification);
    });
  }

  /// Function to show Notification one Time
//* It creates Notificationsdetails with the information and then push a Notification to the OS
//* @param id: Unique id for the notification
//* @param title: title which is displayed in the notification
//* @param body: Text which is displayed in the notification
//* @param payload: information stored in the notification, can be used when launched, but isnt displayed
//* @param channelID: id for the notification channel for Android Notifications managment
//* @param channelName: name of the channel for Android Notifications managment
//* @param channelDescription: decription of the channel for Android Notifications managment
  Future<void> showNotification(
      {required int id,
      required String title,
      String? body,
      String? payload,
      required String channelId,
      required String channelName,
      required String channelDescription}) async {
    var paltformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        styleInformation: DefaultStyleInformation(true, true),
      ),
      iOS: DarwinNotificationDetails(),
    );
    if (await Permission.notification.isGranted) {
      await FlutterLocalNotificationsPlugin().show(
        id,
        title,
        body,
        paltformChannelSpecifics,
        payload: payload,
      );
    } else {
      print("Notification permission not granted. Requesting permission");
      print("Permission: ${await Permission.notification.status}");
      // await requestPermissions();

      PermissionStatus status = await Permission.notification.request();

      if (status == PermissionStatus.granted) {
        print("Permission granted. Launching notification");
        showNotification(
            id: id,
            title: title,
            channelId: channelId,
            channelName: channelName,
            channelDescription: channelDescription);
      }
    }
  }

  /// Function to show Notification at a given DateTime
//* It creates Notificationsdetails with the information and then push a Notification to the OS
//* @param id: Unique id for the notification
//* @param title: title which is displayed in the notification
//* @param body: Text which is displayed in the notification
//* @param payload: information stored in the notification, can be used when launched, but isnt displayed
//* @param channelID: id for the notification channel for Android Notifications managment
//* @param channelName: name of the channel for Android Notifications managment
//* @param channelDescription: decription of the channel for Android Notifications managment
//* @param scheduleNotificationsDateTime: DateTime when notification should pe pushed
//* @param scheduleoffset: Offset of scheduledNotificationDateTime if notification should be pushed earlier or later;
//*                        offset<0: pushed earlier, offset>0 scheduled later
  Future<void> scheduledNotification(
      {required int id,
      required String title,
      String? body,
      String? payload,
      required DateTime scheduleNotificationsDateTime,
      required Duration scheduleoffest,
      required String channelId,
      required String channelName,
      required String channelDescription}) async {
    //Platformspecific settings for Notifications
    var paltformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        styleInformation: DefaultStyleInformation(true, true),
      ),
      iOS: DarwinNotificationDetails(),
    );
    if (await Permission.notification.isGranted) {
      await FlutterLocalNotificationsPlugin().zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
                    scheduleNotificationsDateTime.subtract(scheduleoffest),
                    tz.local)
                .isAfter(tz.TZDateTime.from(DateTime.now(), tz.local))
            ? tz.TZDateTime.from(
                scheduleNotificationsDateTime.subtract(scheduleoffest),
                tz.local)
            : tz.TZDateTime.from(
                DateTime.now().add(Duration(minutes: 1)), tz.local),
        paltformChannelSpecifics,
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
      );
    } else {
      print("Notification permission not granted. Requesting permission");
      print("Permission: ${await Permission.notification.status}");
      // await requestPermissions();
      PermissionStatus status = await Permission.notification.request();

      if (status == PermissionStatus.granted) {
        print("Permission granted. Launching notification");
        scheduledNotification(
            id: id,
            title: title,
            scheduleNotificationsDateTime: scheduleNotificationsDateTime,
            scheduleoffest: scheduleoffest,
            channelId: channelId,
            channelName: channelName,
            channelDescription: channelDescription);
      }
    }
  }

//Default Notification which is pushed if push-notifications are disabled in settings an a notifications
//wants to be pushed
  Future<void> showNotificationsDisabled() async {
    var paltformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        "0",
        "App-Benachrichtigungen",
        channelDescription:
            "Grundlegende Benachrichtigungen von der App über Appfunktionen",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        timeoutAfter: 5000,
        styleInformation: DefaultStyleInformation(true, true),
      ),
      iOS: DarwinNotificationDetails(),
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

  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestPermission();
    }
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}
