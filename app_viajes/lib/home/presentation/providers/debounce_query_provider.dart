import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

// Estado donde guardás lo que el usuario escribe
final queryProvider = StateProvider<String>((ref) => '');

// Estado para guardar la query debounced
final debouncedQueryProvider = StateProvider<String>((ref) {
  // Inicialmente vacío
  return '';
});

class DebounceNotifier {
  Timer? _timer;

  void debounce(WidgetRef ref, String value, {Duration duration = const Duration(milliseconds: 500)}) {
    _timer?.cancel();
    _timer = Timer(duration, () {
      // Actualizo el provider con el valor "debounced"
      ref.read(debouncedQueryProvider.notifier).state = value;
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}

final debounceNotifierProvider = Provider<DebounceNotifier>((ref) {
  final notifier = DebounceNotifier();
  ref.onDispose(() {
    notifier.dispose();
  });
  return notifier;
});
