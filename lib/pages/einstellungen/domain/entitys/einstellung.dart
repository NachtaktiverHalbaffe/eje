import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Einstellung extends Equatable {
  final String preference;
  final bool state;

  Einstellung({@required this.preference, @required this.state});

  @override
  List<Object> get props => [preference, state];
}
