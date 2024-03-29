// ignore_for_file: file_names
import 'package:hive/hive.dart';

part 'Hyperlink.g.dart';

@HiveType(typeId: 9)
class Hyperlink {
  @HiveField(0)
  String link;
  @HiveField(1)
  String description;

  Hyperlink({required this.link, required this.description});
}
