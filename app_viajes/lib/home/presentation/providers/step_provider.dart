import 'package:app_viajes/models/step.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final generatedStepsProvider =
    StateNotifierProvider<GeneratedStepsNotifier, List<Steps>>(
  (ref) => GeneratedStepsNotifier(),
);

class GeneratedStepsNotifier extends StateNotifier<List<Steps>> {
  GeneratedStepsNotifier() : super([]);

  void setSteps(List<Steps> newSteps) {
    state = newSteps;
  }

  void addStep(Steps step) {
    if (!state.any((s) => s.id == step.id)) {
      state = [...state, step];
    }
  }

  void removeStep(int id) {
    state = state.where((s) => s.id != id).toList();
  }

  void clearSteps() {
    state = [];
  }
}
