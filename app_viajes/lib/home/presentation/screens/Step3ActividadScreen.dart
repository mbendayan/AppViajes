import 'package:app_viajes/home/presentation/providers/stepper_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*final stepperProvider = StateNotifierProvider<StepperProvider, bool>(
  (ref) => StepperProvider(),
);*/

class Step3ActividadScreen extends StatefulWidget {
  const Step3ActividadScreen({super.key});

  @override
  State<Step3ActividadScreen> createState() => Step3ActividadState();
}

class Step3ActividadState extends State<Step3ActividadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        ),
      ),
    );
  }
}
