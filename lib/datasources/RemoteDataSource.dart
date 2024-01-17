import 'package:equatable/equatable.dart';

abstract class RemoteDataSource<T extends Equatable, K> {
  Future<List<T>> getAllElements();
  Future<T> getElement(K elementId);
}
