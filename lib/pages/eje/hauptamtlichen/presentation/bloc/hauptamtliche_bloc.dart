// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/usecases/GetHauptamtliche.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/usecases/GetHauptamtlicher.dart';
import 'package:flutter/foundation.dart';
import './bloc.dart';

class HauptamtlicheBloc extends Bloc<HauptamtlicheEvent, HauptamtlicheState> {
  final GetHauptamtliche getHauptamtliche;
  final GetHauptamtlicher getHauptamtlicher;

  HauptamtlicheBloc({
    @required this.getHauptamtliche,
    @required this.getHauptamtlicher,
  }) : super(Empty());

  @override
  Stream<HauptamtlicheState> mapEventToState(
    HauptamtlicheEvent event,
  ) async* {
    if (event is RefreshHauptamtliche) {
      print("Triggered Event: RefreshHauptamtliche");
      yield Loading();
      final hauptamtlicheOrFailure = await getHauptamtliche();
      yield hauptamtlicheOrFailure.fold(
        (failure) {
          print("Error");
          return Error(message: failure.getErrorMsg());
        },
        (hauptamtliche) {
          print("Succes. Returning LoadedHauptamtliche");
          return LoadedHauptamtliche(hauptamtliche);
        },
      );
    } else if (event is GettingHauptamtlicher) {
      yield Loading();
      final hauptamtlicheOrFailure = await getHauptamtlicher(name: event.name);
      yield hauptamtlicheOrFailure.fold(
        (failure) => Error(message: failure.getErrorMsg()),
        (hauptamtlicher) => LoadedHauptamtlicher(hauptamtlicher),
      );
    }
  }
}
