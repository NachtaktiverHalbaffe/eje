import 'package:eje/core/platform/Hyperlink.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'Service.g.dart';

@HiveType(typeId: 8)
class Service extends Equatable {
  @HiveField(0)
  final String service;
  @HiveField(1)
  final List<String> bilder;
  @HiveField(2)
  final String inhalt;
  @HiveField(3)
  final List<Hyperlink> hyperlinks;

  Service({
    @required this.service,
    @required this.bilder,
    @required this.inhalt,
    this.hyperlinks,
  });

  @override
  List<Object> get props => [service, bilder, inhalt, hyperlinks];
}
