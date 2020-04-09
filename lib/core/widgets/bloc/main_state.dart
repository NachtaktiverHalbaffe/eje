import 'package:equatable/equatable.dart';

abstract class MainState extends Equatable {
  const MainState();
}

class InitialMainState extends MainState {
  @override
  List<Object> get props => [];
}

class ChangedTheme extends MainState {
  @override
  List<Object> get props => [];
}
