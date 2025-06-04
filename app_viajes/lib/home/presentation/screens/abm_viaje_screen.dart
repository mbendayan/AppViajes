import 'package:app_viajes/config/dio/dio_client.dart';
import 'package:app_viajes/home/presentation/providers/travel_form_provider.dart';
import 'package:app_viajes/home/presentation/providers/travel_provider.dart';
import 'package:app_viajes/home/presentation/screens/preferences_screen.dart';
import 'package:app_viajes/home/presentation/screens/step1_viaje_screen.dart';
import 'package:app_viajes/home/presentation/screens/Step3_actividad_screen.dart';
import 'package:app_viajes/home/presentation/screens/step1_viaje_screen.dart';
import 'package:app_viajes/home/presentation/screens/step2_preferences_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ABMViajeScreen extends ConsumerStatefulWidget {
  final bool isViewMode; // Nuevo parámetro para el modo visualizar

  const ABMViajeScreen({super.key, this.isViewMode = false});

  @override
  ConsumerState<ABMViajeScreen> createState() => _ABMViajeScreenState();
  
}

class _ABMViajeScreenState extends ConsumerState<ABMViajeScreen> {
  int _currentStep = 0;
  bool _preferencesSaved = false;
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ABM Viaje")),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () async {
  if (_currentStep == 0) {
    setState(() => _currentStep++);
    return;
  }

 if (_currentStep == 1) {
    

    final travel = ref.read(travelFormProvider);
    try {
      await ref.read(travelProvider.notifier).createTravel(travel, ref);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Viaje creado con éxito")),
        );
        setState(() => _currentStep++);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
    return;
  }

  if (_currentStep < 2) {
    setState(() => _currentStep++);
  }
},
onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep < 2)
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: const Text('Continuar'),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    // Lógica para guardar
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Guardar'),
                ),
              if (_currentStep > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Regresar'),
                ),
            ],
          );
        },
        steps: [
          Step(
  title: const Text("Datos del viaje"),
  isActive: _currentStep == 0,
  content: SizedBox(
    height: 300,
    child: Step1ViajeScreen(
      onSaved: ({required name, required destination, required startDate, required endDate}) {
        ref.read(travelFormProvider.notifier).updateForm2(
        name: name,
        destination: destination,
        startDate: startDate.toIso8601String(),
        endDate: endDate.toIso8601String(),
        );
      },
      isViewMode: widget.isViewMode,
    ),
  ),
),
Step(
            title: const Text("Preferencias del viaje"),
            isActive: _currentStep == 1,
            content: Step2PreferencesScreen(
              onSaved: () {
                // En este caso no se necesita lógica adicional aquí,
                // porque Step2PreferencesScreen ya guarda usando Riverpod.
              },
              isViewMode: widget.isViewMode,
            ),
          ),

          Step(
            title: const Text("Actividades del viaje"),
            isActive: _currentStep == 2,
            content: SizedBox(
              height: 400, // Define un tamaño fijo
              child: Step3ActividadScreen(
                isViewMode: widget.isViewMode,
              ), // Pasar el modo
            ),
          ),
        ],
      ),
    );
  }
}
