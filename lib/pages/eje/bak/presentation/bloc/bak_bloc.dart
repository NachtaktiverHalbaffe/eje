// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/eje/bak/domain/usecases/GetBAK.dart';
import 'package:eje/pages/eje/bak/domain/usecases/GetBAKler.dart';
import 'package:meta/meta.dart';

import './bloc.dart';

class BakBloc extends Bloc<BakEvent, BakState> {
  final GetBAK getBAK;
  final GetBAKler getBAKler;

  BakBloc({
    @required this.getBAK,
    @required this.getBAKler,
  }) : super(Empty());

  @override
  Stream<BakState> mapEventToState(
    BakEvent event,
  ) async* {
    if (event is RefreshBAK) {
      print("Triggered Event: RefreshBak");
      yield Loading();
      final bakOrFailure = await getBAK();
      yield bakOrFailure.fold(
        (failure) {
          print("Error");
          return Error(message: failure.getErrorMsg());
        },
        (bak) {
          print("Succes. Returning LoadedHauptamtliche");
          return LoadedBAK(bak);
        },
      );
    } else if (event is GettingBAKler) {
      yield Loading();
      final bakOrFailure = await getBAKler(name: event.name);
      yield bakOrFailure.fold(
        (failure) => Error(message: failure.getErrorMsg()),
        (bakler) => LoadedBAKler(bakler),
      );
    }
  }
}
