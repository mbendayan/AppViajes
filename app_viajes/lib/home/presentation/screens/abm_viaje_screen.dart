import 'package:app_viajes/home/presentation/screens/preferences_screen.dart';
import 'package:app_viajes/home/presentation/screens/register.dart';
import 'package:app_viajes/home/presentation/screens/step1_viaje_screen.dart';
import 'package:app_viajes/home/presentation/screens/Step3ActividadScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ABMViajeScreen extends ConsumerStatefulWidget {
  const ABMViajeScreen({super.key});

  @override
  ConsumerState<ABMViajeScreen> createState() => _ABMViajeScreenState();
}

class _ABMViajeScreenState extends ConsumerState<ABMViajeScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    //    final isStepValid = ref.watch(stepperProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("ABM Viaje")),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 1) {
            setState(() {
              _currentStep++;
            });
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        steps: [
          Step(
            title: Text("Datos del viaje"),
            isActive: _currentStep == 0,
            content: SizedBox(
              height: 400, // Define un tamaño fijo
              child: Step1ViajeScreen(),
            ),
          ),
          Step(
            title: const Text("Preferencias del viaje"),
            isActive: _currentStep == 1,
            content: SizedBox(
              height: 400, // Define un tamaño fijo
              child: PreferencesScreen(),
            ),
          ),
          Step(
            title: const Text("Actividades del viaje"),
            isActive: _currentStep == 2,
            content: SizedBox(
              height: 400, // Define un tamaño fijo
              child: Step3ActividadScreen(),
            ),
          ),
        ],
      ),
    );
  }
}
