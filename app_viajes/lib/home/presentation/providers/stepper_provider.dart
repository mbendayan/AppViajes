import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepperProvider extends StateNotifier<bool> {
  StepperProvider() : super(false);

  Future<void> validate(bool isValid) async {
    state = isValid;
  }
}
