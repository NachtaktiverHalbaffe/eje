import 'package:equatable/equatable.dart';

abstract class MainState extends Equatable {
  const MainState();
}

class InitialMainState extends MainState {
  @override
  List<Object> get props => [];
}

class ChangedThemeToLight extends MainState {
  @override
  List<Object> get props => [];
}

class ChangedThemeToDark extends MainState {
  @override
  List<Object> get props => [];
}

class ChangedThemeToAuto extends MainState {
  @override
  List<Object> get props => [];
}
