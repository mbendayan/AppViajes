import 'package:app_viajes/home/presentation/providers/stepper_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*final stepperProvider = StateNotifierProvider<StepperProvider, bool>(
  (ref) => StepperProvider(),
);*/

class Step1ViajeScreen extends StatefulWidget {
  const Step1ViajeScreen({super.key});

  @override
  State<Step1ViajeScreen> createState() => Step1ViajeState();
}

class Step1ViajeState extends State<Step1ViajeScreen> {
  final _destinoController = TextEditingController();
  final _tituloController = TextEditingController();
  final _costoController = TextEditingController();
  final _descripcionController = TextEditingController();
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  int get _duracion {
    if (_fechaInicio != null && _fechaFin != null) {
      return _fechaFin!.difference(_fechaInicio!).inDays;
    }
    return 0;
  }

  Future<void> _selectFecha(BuildContext context, bool esInicio) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (esInicio) {
          _fechaInicio = picked;
        } else {
          _fechaFin = picked;
        }
      });
    }
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
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Campo requerido"
                            : null,
              ),
              TextFormField(
                controller: _destinoController,
                decoration: const InputDecoration(labelText: "Destino"),
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
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.timer),
                  const SizedBox(width: 10),
                  Text("Duración: $_duracion días"),
                ],
              ),
              TextFormField(
                controller: _costoController,
                decoration: const InputDecoration(labelText: "Costo Total (€)"),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Campo requerido"
                            : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: "Descripción"),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
