import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:eje/pages/neuigkeiten/data/NeuigkeitenDao.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/neuigkeiten_state.dart';

import 'bloc.dart';

class NeuigkeitenBloc extends Bloc<NeuigkeitenEvent, NeuigkeitenState> {
  NeuigkeitDao _neuigkeitenDao = NeuigkeitDao();
  @override
  NeuigkeitenState get initialState => NeuigkeitenLoading();

  @override
  Stream<NeuigkeitenState> mapEventToState(
    NeuigkeitenEvent event,
  ) async* {

    if(event is LoadNeuigkeiten){
      yield NeuigkeitenLoading();
      yield* _reloadNeuigkeiten();
    } else if(event is DeleteNeuigkeit){
      await _neuigkeitenDao.delete(event.neuigkeit);
      yield* _reloadNeuigkeiten();
    }
  }

  Stream<NeuigkeitenState> _reloadNeuigkeiten() async*{
    final neuigkeiten = await _neuigkeitenDao.getAll();
    yield NeuigkeitenLoaded(neuigkeiten);
  }
}
