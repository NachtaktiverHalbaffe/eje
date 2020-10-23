import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:eje/core/utils/notificationplugin.dart';
import 'package:eje/pages/freizeiten/data/datasources/freizeiten_local_datasource.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/neuigkeiten_remote_datasource.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundServicesManager {
  final Duration runServiceIntervall = Duration(hours: 1);

  Future<void> connectBackgroundServices() async {
    await AndroidAlarmManager.periodic(
        runServiceIntervall, 0, await _checkNeuigkeitenNotification);
    await AndroidAlarmManager.periodic(
        runServiceIntervall, 1, await _checkFreizeitenNotification);
  }

//Check if new Neuigkeiten are available
  Future<void> _checkNeuigkeitenNotification() async {
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

  Future<void> _checkFreizeitenNotification() async {
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
}
