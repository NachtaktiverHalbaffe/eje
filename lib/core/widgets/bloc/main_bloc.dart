import 'dart:async';
import 'dart:ffi';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './bloc.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(InitialMainState());

  @override
  Stream<MainState> mapEventToState(
    MainEvent event,
  ) async* {
    if (event is ChangingTheme) {
      yield ChangedTheme();
    }
  }
}
