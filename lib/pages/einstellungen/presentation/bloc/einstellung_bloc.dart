import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class EinstellungBloc extends Bloc<EinstellungEvent, EinstellungState> {
  @override
  EinstellungState get initialState => InitialEinstellungState();

  @override
  Stream<EinstellungState> mapEventToState(
    EinstellungEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
