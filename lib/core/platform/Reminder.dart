import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'Reminder.g.dart';

@HiveType(typeId: 7)
class Reminder extends Equatable {
  //TODO Check if needed
  @HiveField(0)
  final String kategorie;
  @HiveField(1)
  final String identifier;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final String notificationtext;

  Reminder({this.kategorie, this.identifier, this.date, this.notificationtext});

  @override
  List<Object> get props => [kategorie, identifier, date, notificationtext];
}
