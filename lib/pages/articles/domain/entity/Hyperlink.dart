import 'package:hive/hive.dart';

part 'hyperlink.g.dart';

@HiveType(typeId: 9)
class Hyperlink {
  @HiveField(0)
  String link;
  @HiveField(1)
  String description;

  Hyperlink({this.link, this.description});
}
