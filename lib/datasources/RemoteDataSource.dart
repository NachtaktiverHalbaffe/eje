import 'package:equatable/equatable.dart';

abstract class RemoteDataSource<T extends Equatable, K> {
  Future<List<T>> getAllElement();
  Future<T> getElement(K elementId);
}
