import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class NeuigkeitenBlocBloc extends Bloc<NeuigkeitenBlocEvent, NeuigkeitenBlocState> {
  @override
  NeuigkeitenBlocState get initialState => InitialNeuigkeitenBlocState();

  @override
  Stream<NeuigkeitenBlocState> mapEventToState(
    NeuigkeitenBlocEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
