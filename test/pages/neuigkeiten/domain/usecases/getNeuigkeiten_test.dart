import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/neuigkeiten_repository.dart';
import 'package:eje/pages/neuigkeiten/domain/usecases/GetNeuigkeit.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class Mockneuigkeiten_repository extends Mock
    implements NeuigkeitenRespository {}

void main() {
  GetNeuigkeit usecase;
  Mockneuigkeiten_repository mockneuigkeiten_repository;
  setUp(() {
    mockneuigkeiten_repository = Mockneuigkeiten_repository();
    usecase = GetNeuigkeit(mockneuigkeiten_repository);
  });
  final tTitel = "test";
  final tNeuigkeit = Neuigkeit(
      titel: "test", text_preview: "test", text: "test", bilder: ["Test"]);
  ;
  test(
    'Sollte Neuigkeit-Entity von den Repository bekommen',
    () async {
      // arrange
      when(mockneuigkeiten_repository.getNeuigkeit(any))
          .thenAnswer((_) async => Right(tNeuigkeit));
      // act
      final result = await usecase(titel: tTitel);
      // assert
      expect(result, Right(tNeuigkeit));
      verify(mockneuigkeiten_repository.getNeuigkeit(tTitel));
      verifyNoMoreInteractions(mockneuigkeiten_repository);
    },
  );
}
