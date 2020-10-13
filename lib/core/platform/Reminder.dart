import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'Reminder.g.dart';

@HiveType(typeId: 7)
class Reminder extends Equatable {
  @HiveField(0)
  String kategorie;
  @HiveField(1)
  String identifier;
  @HiveField(2)
  DateTime date;
  @HiveField(3)
  String notificationtext;

  Reminder({this.kategorie, this.identifier, this.date, this.notificationtext});

  @override
  List<Object> get props => [kategorie, identifier, date, notificationtext];
}
