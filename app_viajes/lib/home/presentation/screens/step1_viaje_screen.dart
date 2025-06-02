import 'package:app_viajes/home/presentation/providers/stepper_provider.dart';
import 'package:app_viajes/home/presentation/providers/travel_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*final stepperProvider = StateNotifierProvider<StepperProvider, bool>(
  (ref) => StepperProvider(),
);*/
class Step1ViajeScreen extends ConsumerStatefulWidget {
  final void Function({
    required String name,
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
  }) onSaved;

  const Step1ViajeScreen({super.key, required this.onSaved});

  @override
  ConsumerState<Step1ViajeScreen> createState() => _Step1ViajeState();
}


class _Step1ViajeState extends ConsumerState<Step1ViajeScreen> {
  final _destinoController = TextEditingController();
  final _tituloController = TextEditingController();
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  Future<void> _selectFecha(BuildContext context, bool esInicio) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (esInicio) {
          _fechaInicio = picked;
                  ref.read(travelFormProvider.notifier).updateForm2(startDate: picked.toIso8601String());
        } else {
          _fechaFin = picked;
          ref.read(travelFormProvider.notifier).updateForm2(endDate: picked.toIso8601String());
        }
      });
    }
  }

  void _saveStep1Provider() {
  if (_fechaInicio == null || _fechaFin == null) return;

  ref.read(travelFormProvider.notifier).updateForm2(
    name: _tituloController.text,
    destination: _destinoController.text,
    startDate: _fechaInicio!.toIso8601String(),
    endDate: _fechaFin!.toIso8601String(),
    
  );
}


  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: "Título"),
              onChanged: (value) {
                  ref.read(travelFormProvider.notifier).updateForm2(name: value);
                }),
            TextFormField(
              controller: _destinoController,
              decoration: const InputDecoration(labelText: "Destino"),onChanged: (value) {
                  ref.read(travelFormProvider.notifier).updateForm2(destination: value);
                }),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 10),
                const Text("Fecha de Inicio: "),
                TextButton(
                  onPressed: () => _selectFecha(context, true),
                  child: Text(
                    _fechaInicio == null
                        ? "Seleccionar"
                        : "${_fechaInicio!.day}/${_fechaInicio!.month}/${_fechaInicio!.year}",
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 10),
                const Text("Fecha de Fin: "),
                TextButton(
                  onPressed: () => _selectFecha(context, false),
                  child: Text(
                    _fechaFin == null
                        ? "Seleccionar"
                        : "${_fechaFin!.day}/${_fechaFin!.month}/${_fechaFin!.year}",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}