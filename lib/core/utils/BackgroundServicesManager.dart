import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:eje/core/utils/notificationplugin.dart';
import 'package:eje/pages/freizeiten/data/datasources/freizeiten_local_datasource.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/neuigkeiten_remote_datasource.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/termine/domain/entities/Ort.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:path_provider/path_provider.dart' as path_provider;

class BackgroundServicesManager {
  final Duration runServiceIntervall = Duration(hours: 1);

  Future<void> connectBackgroundServices() async {
    /*if (Platform.isAndroid) {
      await AndroidAlarmManager.periodic(
          runServiceIntervall, 0, await _checkNeuigkeitenNotification);
      await AndroidAlarmManager.periodic(
          runServiceIntervall, 1, await _checkFreizeitenNotification);
    }*/
    BackgroundFetch.registerHeadlessTask(_checkNeuigkeitenNotification);
    //BackgroundFetch.registerHeadlessTask(_checkFreizeitenNotification);
  }

  Future<void> initPlatformState() async {
    //Backgroundconfig
    var config = BackgroundFetchConfig(
      minimumFetchInterval: 15,
      stopOnTerminate: false,
      startOnBoot: true,
      enableHeadless: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: NetworkType.ANY,
    );
    // Configure background task for Neuigkeiten
    BackgroundFetch.configure(
        config, (taskId) => _checkNeuigkeitenNotification(taskId));
    //configure background service fpr Freizeiten
    //BackgroundFetch.configure(
    //    config, (taskId) => _checkFreizeitenNotification(taskId));
  }
}

/// Backgroundtask for push-notificvations for new News
//* _checkNeuigkeitenNotificationHeadless loads the newest Nueigkeiten from NeuigkeitenRemoteDatasource
//* and checks if thereses new data and fires a notification
//* @param taskID: for Background_fetch for identifying the background task
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
  BackgroundFetch.finish(taskId);
}

///Backgroundtask for push-notifications in Freizeiten-Channel
//* _checkFreizeitenNotificationHeadless loads the newest Freizeiten from the FreizeitenRemoteDatasource
//* and checks if there are more Freizeiten than lasttime and fires a notification if it has grown
//* @params taskId: taskID for Background fetch
void _checkFreizeitenNotification(String taskId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<Freizeit> _freizeiten = List();
  Box _box = await Hive.openBox('Freizeiten');
  if (prefs.getBool("notifications_freizeiten")) {
    //Donwloading content from internet
    //TODO connect to online API

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
  BackgroundFetch.finish(taskId);
}
