import 'package:app_viajes/models/step.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<List<Steps>> generatedStepsProvider = StateProvider<List<Steps>>((ref) => []);