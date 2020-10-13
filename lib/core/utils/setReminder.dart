import 'package:eje/core/platform/Reminder.dart';
import 'package:hive/hive.dart';

class ReminderManager {
  void setReminder(Reminder reminderToCache) async {
    Box _box = await Hive.openBox('Reminder');
    bool isAlreadyCached = false;
    // Check if reminderToCache is already cached
    for (int i = 0; i < _box.length; i++) {
      if (_box.getAt(i).identifier == reminderToCache.identifier) {
        isAlreadyCached = true;
        break;
      }
    }
    //Cache reminderToCache if it isnt cached already
    if (isAlreadyCached == false) {
      _box.add(reminderToCache);
    }
    _box.compact();
    _box.close();
  }

  Future<Reminder> getReminder(String identifier) async {
    Box _box = await Hive.openBox('Reminder');
    for (int i = 0; i < _box.length; i++) {
      if (_box.getAt(i).identifier == identifier) {
        _box.compact();
        _box.close();
        return _box.getAt(i);
      }
    }
    _box.compact();
    _box.close();
    return Reminder(
        kategorie: "",
        identifier: "",
        date: DateTime.now(),
        notificationtext: "");
  }
}