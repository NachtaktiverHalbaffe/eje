import 'package:background_fetch/background_fetch.dart';
import 'package:eje/core/utils/notificationplugin.dart';
import 'package:eje/pages/freizeiten/data/datasources/camps_remote_datasource.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/news_remote_datasource.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/news.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class BackgroundServicesManager {
  final Duration runServiceIntervall = Duration(hours: 1);

  Future<void> connectBackgroundServices() async {
    print("Registering background services...");
    if (GetStorage().read("notifications_neuigkeiten")) {
      BackgroundFetch.registerHeadlessTask(_checkNeuigkeitenNotification);
    }
    if (GetStorage().read("notifications_freizeiten")) {
      BackgroundFetch.registerHeadlessTask(_checkFreizeitenNotification);
    }
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
    if (GetStorage().read("notifications_neuigkeiten")) {
      BackgroundFetch.configure(
          config, (String taskId) => _checkNeuigkeitenNotification(taskId),
          (String taskId) async {
        BackgroundFetch.finish(taskId);
      });
    }
    //configure background service for Freizeiten
    if (GetStorage().read("notifications_freizeiten")) {
      BackgroundFetch.configure(
          config, (taskId) => _checkFreizeitenNotification(taskId),
          (String taskId) async {
        BackgroundFetch.finish(taskId);
      });
    }
  }
}

/// * Backgroundtask for push-notifications for new News
// _checkNeuigkeitenNotificationHeadless loads the newest Nueigkeiten from NeuigkeitenRemoteDatasource
// and checks if there is new data and fires a notification
// @params:
//    taskID: for Background_fetch for identifying the background task
void _checkNeuigkeitenNotification(String taskId) async {
  await GetStorage.init();
  final prefs = GetStorage();
  List<News> downloadedNeuigkeiten = List.empty(growable: true);
  List<String> downloadedNeuigkeitenTitel = List.empty(growable: true);
  List<String> cachedNeuigkeitenTitel = prefs.read("cached_neuigkeiten");

  //Downloading content from internet
  downloadedNeuigkeiten = await NewsRemoteDatasource().getNews();
  for (int i = 0; i < downloadedNeuigkeiten.length; i++) {
    downloadedNeuigkeitenTitel.add(downloadedNeuigkeiten[i].title);
  }
  // sort lists for comparison
  downloadedNeuigkeitenTitel.sort((a, b) {
    return a.toLowerCase().compareTo(b.toLowerCase());
  });
  cachedNeuigkeitenTitel.sort((a, b) {
    return a.toLowerCase().compareTo(b.toLowerCase());
  });
  //checking if List is diffrent from data in cache
  if (!listEquals(cachedNeuigkeitenTitel, downloadedNeuigkeitenTitel)) {
    //storing new news
    prefs.write("cached_neuigkeiten", downloadedNeuigkeitenTitel);
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
  BackgroundFetch.finish(taskId);
}

///Backgroundtask for push-notifications in Freizeiten-Channel
//* _checkFreizeitenNotificationHeadless loads the newest Freizeiten from the FreizeitenRemoteDatasource
//* and checks if there are more Freizeiten than lasttime and fires a notification if it has grown
//* @params taskId: taskID for Background fetch
void _checkFreizeitenNotification(String taskId) async {
  // Initiliaze GetStorage for getting Prefrences
  await GetStorage.init();
  final prefs = GetStorage();
  List<Camp> downloadedCamps;
  List<String> downloadedCampsTitles;
  List<String> cachedCamps = prefs.read("cached_freizeiten");

  downloadedCamps = await CampsRemoteDatasource().getFreizeiten();
  for (var i = 0; i < downloadedCamps.length; i++) {
    downloadedCampsTitles.add(downloadedCamps[i].name);
  }
  //Downloading content from internet
  for (var i = 0; i < downloadedCamps.length; i++) {
    downloadedCampsTitles.add(downloadedCamps[i].name);
  }
  // sort lists for comparison
  downloadedCampsTitles.sort((a, b) {
    return a.toLowerCase().compareTo(b.toLowerCase());
  });
  cachedCamps.sort((a, b) {
    return a.toLowerCase().compareTo(b.toLowerCase());
  });
  // List of available camps are compared by their title
  if (!listEquals(cachedCamps, downloadedCampsTitles)) {
    //storing actual length of Neuigkeiten in SharedPrefrences
    prefs.write("cached_freizeiten", downloadedCampsTitles);
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
  BackgroundFetch.finish(taskId);
}
