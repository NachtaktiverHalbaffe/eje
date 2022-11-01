import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './bloc.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(InitialMainState()) {
    on<ChangingThemeToAuto>((event, emit) => emit(ChangedThemeToAuto()));
    on<ChangingThemeToDark>((event, emit) => emit(ChangedThemeToDark()));
    on<ChangingThemeToLight>((event, emit) => emit(ChangedThemeToLight()));
  }
}
