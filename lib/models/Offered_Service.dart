// ignore_for_file: file_names
import 'package:eje/models/Hyperlink.dart';
import 'package:equatable/equatable.dart';

class OfferedService extends Equatable {
  final String service;
  final List<String> images;
  final String description;
  final List<Hyperlink> hyperlinks;

  static const List<Hyperlink> defaultHyperlink = [];

  OfferedService({
    required this.service,
    required this.images,
    required this.description,
    this.hyperlinks = defaultHyperlink,
  });

  @override
  List<Object> get props => [service, images, description, hyperlinks];

  factory OfferedService.fromJson(Map<String, dynamic> json) {
    return OfferedService(
        service: json["service"] as String,
        images: (json["images"] as List).cast<String>(),
        description: json["description"] as String,
        hyperlinks: (json["hyperlink"] as List).cast<Hyperlink>());
  }

  Map<String, dynamic> toJson() {
    return {
      "serivce": service,
      "images": images,
      "description": description,
      "hyperlink": hyperlinks
    };
  }
}
