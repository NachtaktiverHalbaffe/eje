import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();
}

class ChangingThemeToLight extends MainEvent {
  @override
  List<Object> get props => [];
}

class ChangingThemeToDark extends MainEvent {
  @override
  List<Object> get props => [];
}

class ChangingThemeToAuto extends MainEvent {
  @override
  List<Object> get props => [];
}
