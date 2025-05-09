import 'package:flutter/material.dart';

class ABMViajeScreen extends StatefulWidget {
  const ABMViajeScreen({super.key});

  @override
  State<ABMViajeScreen> createState() => _ABMViajeScreenState();
}

class _ABMViajeScreenState extends State<ABMViajeScreen> {
  int _currentStep = 0;

  final _formKey = GlobalKey<FormState>();
  final _destinoController = TextEditingController();
  final _TituloController = TextEditingController();
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
      appBar: AppBar(title: const Text("ABM Viaje")),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              if (_currentStep < 1) {
                _currentStep++;
              }
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
            title: const Text("Detalles del Viaje"),
            isActive: _currentStep == 0,
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _TituloController,
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
                    decoration: const InputDecoration(
                      labelText: "Costo Total (€)",
                    ),
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

          // Aquí podrías agregar más steps si lo necesitás:
          Step(
            title: const Text("Confirmación"),
            isActive: _currentStep == 1,
            content: const Text(
              "Segundo paso: Confirmar los datos u otra info.",
            ),
          ),
        ],
      ),
    );
  }
}
