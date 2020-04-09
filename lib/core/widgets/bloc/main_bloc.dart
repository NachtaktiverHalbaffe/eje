import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  @override
  MainState get initialState => InitialMainState();

  @override
  Stream<MainState> mapEventToState(
    MainEvent event,
  ) async* {
    if(event is ChangingTheme){
      yield ChangedTheme();
    }
  }
}
