import '../entities/reflection.dart';

abstract interface class ReflectionRepository {
  /// Reflects on the user's [answers], given in order; the first one names
  /// what takes up most of their time.
  Future<Reflection> reflect(List<String> answers);
}
