// ignore_for_file: file_names
import 'package:eje/models/hyperlink.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';

part 'offered_service.g.dart';

@HiveType(typeId: 8)
class OfferedService extends Equatable {
  @HiveField(0)
  final String service;
  @HiveField(1)
  final List<String> images;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final List<Hyperlink> hyperlinks;

  OfferedService({
    required this.service,
    required this.images,
    required this.description,
    this.hyperlinks = const [],
  });

  @override
  List<Object> get props => [service, images, description, hyperlinks];
}
