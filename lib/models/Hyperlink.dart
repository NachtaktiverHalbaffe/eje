// ignore_for_file: file_names
import 'package:hive/hive.dart';

class Hyperlink {
  String link;
  String description;

  Hyperlink({required this.link, required this.description});

  factory Hyperlink.fromJson(Map<String, dynamic> json) {
    return Hyperlink(
        link: json["link"] as String,
        description: json["description"] as String);
  }

  Map<String, dynamic> toJson() {
    return {"link": link, "description": description};
  }
}
