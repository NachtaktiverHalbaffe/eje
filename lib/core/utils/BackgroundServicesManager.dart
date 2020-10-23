import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:eje/core/utils/notificationplugin.dart';
import 'package:eje/pages/freizeiten/data/datasources/freizeiten_local_datasource.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/neuigkeiten_remote_datasource.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class BackgroundServicesManager {
  final Duration runServiceIntervall = Duration(hours: 1);

  Future<void> connectBackgroundServices() async {
    /*if (Platform.isAndroid) {
      await AndroidAlarmManager.periodic(
          runServiceIntervall, 0, await _checkNeuigkeitenNotification);
      await AndroidAlarmManager.periodic(
          runServiceIntervall, 1, await _checkFreizeitenNotification);
    }*/
    BackgroundFetch.registerHeadlessTask(_checkNeuigkeitenNotificationHeadless);
    BackgroundFetch.registerHeadlessTask(_checkFreizeitenNotificationHeadless);
  }

//Check if new Neuigkeiten are available
  void _checkNeuigkeitenNotification(String taskId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Neuigkeit> _neuigkeiten = List();
    if (prefs.getBool("notifications_neuigkeiten")) {
      //Donwloading content from internet
      _neuigkeiten = await NeuigkeitenRemoteDatasource().getNeuigkeiten();
      //checking if List had growed
      if (prefs.getInt("neuigkeiten_length") != _neuigkeiten.length) {
        //storing actual length of Neuigkeiten in SharedPrefrences
        prefs.setInt("neuigkeiten_length", _neuigkeiten.length);
        //Displaying notification
        notificationPlugin.showNotification(
          id: 0,
          title: "Neuigkeiten aus dem Jugendwerk",
          channelId: "Neuigkeiten",
          channelName: "Neuigkeiten",
          channelDescription:
              "Benachrichtigungen, wenn es neue Neuigkeiten aus dem Jugendwerk gibt.",
          body: "Schaue dir in der App die neuen Neuigkeiten an.",
          payload: "0",
        );
      }
    }
  }

  void _checkFreizeitenNotification(String taskId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Freizeit> _freizeiten = List();
    Box _box = await Hive.openBox('Freizeiten');
    if (prefs.getBool("notifications_freizeiten")) {
      //Donwloading content from internet
      //TODO connect to online API
      _freizeiten = FreizeitenLocalDatasource().getCachedFreizeiten();
      //checking if List had growed
      if (prefs.getInt("freizeiten_length") != _freizeiten.length) {
        //storing actual length of Neuigkeiten in SharedPrefrences
        prefs.setInt("freizeiten_length", _freizeiten.length);
        //Displaying notification
        notificationPlugin.showNotification(
          id: 0,
          title: "Neue Freizeitanmeldungen online",
          channelId: "Freizeiten",
          channelName: "Freizeiten",
          channelDescription:
              "Benachrichtigungen, wenn neue Anmeldungen für Freizeiten online gehen",
          body: "Es gibt neue Freizeiten, für die die Anmeldung online ist",
          payload: "3",
        );
      }
    }
    await _box.compact();
    await _box.close();
  }

  Future<void> initPlatformState() async {
    int _status = 0;
    // Configure background task for Neuigkeiten
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.ANY), (String taskId) async {
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      await _checkNeuigkeitenNotification(taskId);
      BackgroundFetch.finish(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
      _status = status;
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
      _status = e;
    });
    //configure background service fpr Freizeiten
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.ANY), (String taskId) async {
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      await _checkFreizeitenNotification(taskId);
      BackgroundFetch.finish(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
      _status = status;
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
      _status = e;
    });
  }
}

void _checkNeuigkeitenNotificationHeadless(String taskId) async {
  await BackgroundServicesManager()._checkNeuigkeitenNotification(taskId);
  BackgroundFetch.finish(taskId);
  BackgroundFetch.scheduleTask(TaskConfig(
      taskId: "de.eje_esslingen.eje.checkNeuigkeitenNotificationHeadless",
      delay: 5000,
      periodic: false,
      forceAlarmManager: true,
      stopOnTerminate: false,
      enableHeadless: true));
}

void _checkFreizeitenNotificationHeadless(String taskId) async {
  await BackgroundServicesManager()._checkFreizeitenNotification(taskId);
  BackgroundFetch.finish(taskId);
  BackgroundFetch.scheduleTask(TaskConfig(
      taskId: "de.eje_esslingen.eje.checkFreizeitenNotificationHeadless",
      delay: 5000,
      periodic: false,
      forceAlarmManager: true,
      stopOnTerminate: false,
      enableHeadless: true));
}
