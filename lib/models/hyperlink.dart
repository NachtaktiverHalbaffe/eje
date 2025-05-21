// ignore_for_file: file_names
import 'package:hive_ce/hive.dart';

part 'hyperlink.g.dart';

@HiveType(typeId: 9)
class Hyperlink {
  @HiveField(0)
  String link;
  @HiveField(1)
  String description;

  Hyperlink({required this.link, required this.description});
}
