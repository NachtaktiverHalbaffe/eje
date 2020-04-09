import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();
}

class ChangingTheme extends MainEvent{
  @override

  List<Object> get props => [];
}
