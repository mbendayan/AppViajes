import 'package:app_viajes/home/presentation/providers/edit_travel_provider.dart';
import 'package:app_viajes/home/presentation/providers/travel_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class Step1ViajeScreen extends ConsumerStatefulWidget {
  final void Function({
    required String name,
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
  })
  onSaved;
  final bool isViewMode;

  const Step1ViajeScreen({
    super.key,
    this.isViewMode = false,
    required this.onSaved,
  });

  @override
  ConsumerState<Step1ViajeScreen> createState() => _Step1ViajeState();
}

class _Step1ViajeState extends ConsumerState<Step1ViajeScreen> {
  final _destinoController = TextEditingController();
  final _tituloController = TextEditingController();
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  final List<Map<String, String>> countries = [
    {"nombre": "Afganistán", "codigo": "af"},
    {"nombre": "Albania", "codigo": "al"},
    {"nombre": "Argelia", "codigo": "dz"},
    {"nombre": "Andorra", "codigo": "ad"},
    {"nombre": "Angola", "codigo": "ao"},
    {"nombre": "Argentina", "codigo": "ar"},
    {"nombre": "Australia", "codigo": "au"},
    {"nombre": "Austria", "codigo": "at"},
    {"nombre": "Bangladés", "codigo": "bd"},
    {"nombre": "Bélgica", "codigo": "be"},
    {"nombre": "Bolivia", "codigo": "bo"},
    {"nombre": "Brasil", "codigo": "br"},
    {"nombre": "Canadá", "codigo": "ca"},
    {"nombre": "Chile", "codigo": "cl"},
    {"nombre": "China", "codigo": "cn"},
    {"nombre": "Colombia", "codigo": "co"},
    {"nombre": "Cuba", "codigo": "cu"},
    {"nombre": "Dinamarca", "codigo": "dk"},
    {"nombre": "Ecuador", "codigo": "ec"},
    {"nombre": "Egipto", "codigo": "eg"},
    {"nombre": "Finlandia", "codigo": "fi"},
    {"nombre": "Francia", "codigo": "fr"},
    {"nombre": "Alemania", "codigo": "de"},
    {"nombre": "Grecia", "codigo": "gr"},
    {"nombre": "India", "codigo": "in"},
    {"nombre": "Italia", "codigo": "it"},
    {"nombre": "Japón", "codigo": "jp"},
    {"nombre": "México", "codigo": "mx"},
    {"nombre": "Países Bajos", "codigo": "nl"},
    {"nombre": "Nueva Zelanda", "codigo": "nz"},
    {"nombre": "Noruega", "codigo": "no"},
    {"nombre": "Perú", "codigo": "pe"},
    {"nombre": "Rusia", "codigo": "ru"},
    {"nombre": "Sudáfrica", "codigo": "za"},
    {"nombre": "España", "codigo": "es"},
    {"nombre": "Suecia", "codigo": "se"},
    {"nombre": "Suiza", "codigo": "ch"},
    {"nombre": "Turquía", "codigo": "tr"},
    {"nombre": "Reino Unido", "codigo": "gb"},
    {"nombre": "Estados Unidos", "codigo": "us"},
  ];

  @override
  void initState() {
    super.initState();
    final travel = ref.read(editTraverProvider);

    if (travel.id != 0) {
      _tituloController.text = travel.title;
      _destinoController.text = travel.destination;
      _fechaInicio = travel.dateStart;
      _fechaFin = travel.dateEnd;
      ref
          .read(travelFormProvider.notifier)
          .updateForm2(
            name: travel.title,
            destination: travel.destination,
            startDate: travel.dateStart!.toIso8601String(),
            endDate: travel.dateEnd!.toIso8601String(),
          );
    }
  }

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
          ref
              .read(travelFormProvider.notifier)
              .updateForm2(startDate: picked.toIso8601String());
        } else {
          _fechaFin = picked;
          ref
              .read(travelFormProvider.notifier)
              .updateForm2(endDate: picked.toIso8601String());
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
                onChanged: (value) {
                  ref
                      .read(travelFormProvider.notifier)
                      .updateForm2(name: value);
                },
                readOnly: widget.isViewMode,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Campo requerido"
                            : null,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 80,
                child: DropdownButtonFormField<String>(
                  value:
                      _destinoController.text.isNotEmpty
                          ? _destinoController.text
                          : null,
                  items:
                      countries.map((country) {
                        return DropdownMenuItem<String>(
                          value: country['nombre'],
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "flags/${country['codigo']}.svg",
                                width: 24,
                                height: 24,
                                placeholderBuilder:
                                    (context) => const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const Icon(Icons.error),
                              ),
                              const SizedBox(width: 8),
                              Text(country['nombre']!),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged:
                      widget.isViewMode
                          ? null
                          : (value) {
                            setState(() {
                              _destinoController.text = value!;
                              ref
                                  .read(travelFormProvider.notifier)
                                  .updateForm2(destination: value);
                            });
                          },
                  decoration: const InputDecoration(
                    labelText: "Destino",
                    border: OutlineInputBorder(),
                  ),
                ),
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
                            ? null
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
