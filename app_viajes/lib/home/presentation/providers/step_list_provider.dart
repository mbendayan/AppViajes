import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_viajes/models/step.dart';

class StepsNotifier extends StateNotifier<List<Steps>> {
  StepsNotifier() : super([]);

  void setSteps(List<Steps> steps) {
    state = steps;
  }

  void addStep(Steps step) {
    state = [...state, step];
  }

  void removeStep(int id) {
    state = state.where((step) => step.id != id).toList();
  }

  List<Steps> filterByDate(DateTime? date) {
    if (date == null) return state;
    return state.where((s) =>
        s.startDate.year == date.year &&
        s.startDate.month == date.month &&
        s.startDate.day == date.day).toList();
  }
}

final stepsProvider = StateNotifierProvider<StepsNotifier, List<Steps>>((ref) {
  return StepsNotifier();
});