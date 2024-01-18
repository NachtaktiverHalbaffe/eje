import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class FieldOfWork extends Equatable {
  final String name;
  final List<String> images;
  final String description;
  final String link;

  FieldOfWork({
    required this.name,
    required this.images,
    required this.description,
    this.link = "",
  });

  @override
  List<Object> get props => [name, images, description, link];

  factory FieldOfWork.mapFromJson(Map<String, dynamic> json) {
    return FieldOfWork(
        name: json["name"] as String,
        images: (json["images"] as List).cast<String>(),
        description: json["description"] as String,
        link: json["link"] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "images": images,
      "description": description,
      "Link": link,
    };
  }
}
