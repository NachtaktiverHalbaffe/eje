import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class Employee extends Equatable {
  final String image;
  final String name;
  final String function;
  final String introduction;
  final String email;
  final String telefon;
  final String handy;
  final String threema;

  Employee({
    required this.image,
    required this.name,
    required this.function,
    required this.introduction,
    required this.email,
    required this.telefon,
    required this.handy,
    required this.threema,
  });

  @override
  List<Object> get props =>
      [image, name, function, introduction, email, telefon, handy, threema];

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        image: json["image"] as String,
        name: json["name"] as String,
        function: json["function"] as String,
        introduction: json["introduction"] as String,
        email: json["email"] as String,
        telefon: json["telefon"] as String,
        handy: json["handy"] as String,
        threema: json["threema"] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "name": name,
      "function": function,
      "introduction": introduction,
      "email": email,
      "telefon": telefon,
      "handy": handy,
      "threema": threema
    };
  }
}
