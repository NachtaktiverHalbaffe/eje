import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:eje/core/utils/notificationplugin.dart';
import 'package:eje/pages/freizeiten/data/datasources/camps_remote_datasource.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/news_remote_datasource.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/news.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class BackgroundServicesManager {
  Future<void> initialize() async {
    final FlutterBackgroundService service = FlutterBackgroundService();
    final AndroidConfiguration androidConfig = AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: false,
      autoStart: true,
      autoStartOnBoot: true,
    );
    final IosConfiguration iosConfig = IosConfiguration(
      autoStart: true,
      onBackground: onIosBackground,
      onForeground: onStart,
    );

    await service.configure(
        iosConfiguration: iosConfig, androidConfiguration: androidConfig);
  }

  Future<void> runBackgroundTasks() async {
    await checkFreizeitenNotification();
    await checkNeuigkeitenNotification();
  }

  /// Backgroundtask for push-notifications for new News
  Future<void> checkNeuigkeitenNotification() async {
    await GetStorage.init();
    final prefs = GetStorage();
    List<News> downloadedNeuigkeiten = List.empty(growable: true);
    List<String> downloadedNeuigkeitenTitel = List.empty(growable: true);
    List<dynamic> cachedNeuigkeitenTitel = prefs.read("cached_neuigkeiten");

    //Downloading content from internet
    try {
      downloadedNeuigkeiten = await NewsRemoteDatasource().getNews();
    } catch (e) {
      return;
    }

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
    if (!listEquals(cachedNeuigkeitenTitel, downloadedNeuigkeitenTitel) &&
        downloadedNeuigkeiten.isNotEmpty) {
      //storing new news
      prefs.write("cached_neuigkeiten", downloadedNeuigkeitenTitel);
      //Displaying notification
      if (await Permission.notification.isGranted) {
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
  }

  ///Backgroundtask for push-notifications in Freizeiten-Channel
  Future<void> checkFreizeitenNotification() async {
    // Initiliaze GetStorage for getting Prefrences
    await GetStorage.init();
    final prefs = GetStorage();
    List<Camp> downloadedCamps = List.empty(growable: true);
    List<int> downloadedCampsIDs = List.empty(growable: true);
    List<dynamic> cachedCamps = prefs.read("cached_freizeiten");

    try {
      downloadedCamps = await CampsRemoteDatasource().getFreizeiten();
    } catch (e) {
      return;
    }

    //Downloading content from internet
    for (var i = 0; i < downloadedCamps.length; i++) {
      downloadedCampsIDs.add(downloadedCamps[i].id);
    }
    // sort lists for comparison
    downloadedCampsIDs.sort();
    cachedCamps.sort();
    // List of available camps are compared by their title
    if (!listEquals(cachedCamps, downloadedCampsIDs) &&
        downloadedCamps.isNotEmpty) {
      //storing actual length of Neuigkeiten in SharedPrefrences
      prefs.write("cached_freizeiten", downloadedCampsIDs);
      //Displaying notification
      if (await Permission.notification.isGranted) {
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
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // Set background service parameters
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(minutes: 15), (timer) async {
    BackgroundServicesManager().runBackgroundTasks();
    service.invoke(
      'update',
    );
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}
