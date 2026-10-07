import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/redactor.dart';

/// Bound to a concrete implementation in `app/bootstrap.dart`: the Kotlin
/// redactor on Android (#53, #58), the Dart stub elsewhere.
final redactorProvider = Provider<Redactor>(
  (ref) => throw UnimplementedError('Bind redactorProvider in bootstrap'),
);
