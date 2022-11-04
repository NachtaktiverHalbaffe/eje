import 'dart:math';

import 'package:eje/core/utils/notificationplugin.dart';
import 'package:eje/pages/freizeiten/data/datasources/camps_remote_datasource.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/news_remote_datasource.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/news.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundServicesManager {
  /// * Backgroundtask for push-notifications for new News
// _checkNeuigkeitenNotificationHeadless loads the newest Nueigkeiten from NeuigkeitenRemoteDatasource
// and checks if there is new data and fires a notification
// @params:
//    taskID: for Background_fetch for identifying the background task
  static Future<void> checkNeuigkeitenNotification() async {
    await GetStorage.init();
    final prefs = GetStorage();
    List<News> downloadedNeuigkeiten = List.empty(growable: true);
    List<String> downloadedNeuigkeitenTitel = List.empty(growable: true);
    List<dynamic> cachedNeuigkeitenTitel = prefs.read("cached_neuigkeiten");

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
      await notificationPlugin.showNotification(
        id: Random().nextInt(100),
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

  ///Backgroundtask for push-notifications in Freizeiten-Channel
//* _checkFreizeitenNotificationHeadless loads the newest Freizeiten from the FreizeitenRemoteDatasource
//* and checks if there are more Freizeiten than lasttime and fires a notification if it has grown
//* @params taskId: taskID for Background fetch
  static Future<void> checkFreizeitenNotification() async {
    // Initiliaze GetStorage for getting Prefrences
    await GetStorage.init();
    final prefs = GetStorage();
    List<Camp> downloadedCamps = List.empty(growable: true);
    List<int> downloadedCampsTitles = List.empty(growable: true);
    List<dynamic> cachedCamps = prefs.read("cached_freizeiten");

    downloadedCamps = await CampsRemoteDatasource().getFreizeiten();
    for (var i = 0; i < downloadedCamps.length; i++) {
      downloadedCampsTitles.add(downloadedCamps[i].id);
    }
    //Downloading content from internet
    for (var i = 0; i < downloadedCamps.length; i++) {
      downloadedCampsTitles.add(downloadedCamps[i].id);
    }
    // sort lists for comparison
    downloadedCampsTitles.sort();
    cachedCamps.sort();
    // List of available camps are compared by their title
    if (!listEquals(cachedCamps, downloadedCampsTitles)) {
      //storing actual length of Neuigkeiten in SharedPrefrences
      prefs.write("cached_freizeiten", downloadedCampsTitles);
      //Displaying notification
      await notificationPlugin.showNotification(
        id: Random().nextInt(100),
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
}
