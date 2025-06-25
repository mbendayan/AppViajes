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
  final exists = state.any((s) =>
    s.name == step.name &&
    s.startDate == step.startDate &&
    s.endDate == step.endDate
  );

  if (!exists) {
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
