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
  final bool isViewMode; // Nuevo parámetro para determinar el modo

  const Step1ViajeScreen({super.key, this.isViewMode = false, required this.onSaved});


  @override
  ConsumerState<Step1ViajeScreen> createState() => _Step1ViajeState();
}


class _Step1ViajeState extends ConsumerState<Step1ViajeScreen> {
  final _destinoController = TextEditingController();
  final _tituloController = TextEditingController();
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  Future<void> _selectFecha(BuildContext context, bool esInicio) async {
     if (widget.isViewMode) return;
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
    return Scaffold(
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: "Título"),
                 onChanged: (value) {
                  ref.read(travelFormProvider.notifier).updateForm2(name: value);
                },
                readOnly:
                    widget
                        .isViewMode, // Campo de solo lectura si está en modo visualizar
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Campo requerido"
                            : null,
              ),
              TextFormField(
                controller: _destinoController,
                decoration: const InputDecoration(labelText: "Destino"),
                 onChanged: (value) {
                  ref.read(travelFormProvider.notifier).updateForm2(destination: value);
                },
                readOnly: widget.isViewMode,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Campo requerido"
                            : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 10),
                  const Text("Fecha de Inicio: "),
                  TextButton(
                    onPressed:
                        widget.isViewMode
                            ? null // Botón deshabilitado si está en modo visualizar
                            : () => _selectFecha(context, true),
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
                    onPressed:
                        widget.isViewMode
                            ? null
                            : () => _selectFecha(context, false),
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
      ),
    );
  }
}