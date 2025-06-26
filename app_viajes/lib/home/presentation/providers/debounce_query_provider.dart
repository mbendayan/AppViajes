import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

final queryProvider = StateProvider<String>((ref) => '');
final debouncedQueryProvider = StateProvider<String>((ref) {
  return '';
});

class DebounceNotifier {
  Timer? _timer;

  void debounce(
    WidgetRef ref,
    String value, {
    Duration duration = const Duration(milliseconds: 500),
  }) {
    _timer?.cancel();
    _timer = Timer(duration, () {
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
