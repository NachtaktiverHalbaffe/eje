import 'package:shared_preferences/shared_preferences.dart';

Future<void> prefStartup() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getBool("First_Startup") == null){
    print("First startup. Setting default Preferences");
    prefs.setBool("First_Startup", true);
    prefs.setBool("nightmode_auto", true);
    prefs.setBool("nightmode_on", false);
    prefs.setBool("nightmode_off", false);
    prefs.setBool("notifications_on", true);
    prefs.setBool("notifications_neuigkeiten", false);
    prefs.setBool("notifications_freizeiten", true);
    prefs.setBool("notifications_veranstaltungen", true);
    prefs.setBool("only_wifi", false);
    prefs.setBool("cache_pictures", true);
  }
}