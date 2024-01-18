// ignore_for_file: file_names
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class BAKler extends Equatable {
  final String image;
  final String name;
  final String function;
  final String introduction;
  final String email;

  final String threema;

  BAKler({
    required this.image,
    required this.name,
    required this.function,
    required this.introduction,
    required this.email,
    required this.threema,
  });

  @override
  List<Object> get props =>
      [image, name, function, introduction, email, threema];

  factory BAKler.fromJson(Map<String, dynamic> json) {
    return BAKler(
        image: json["image"] as String,
        name: json["name"] as String,
        function: json["function"] as String,
        introduction: json["introduction"] as String,
        email: json["email"] as String,
        threema: json["threema"] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "name": name,
      "function": function,
      "introduction": introduction,
      "email": email,
      "threema": threema
    };
  }
}
