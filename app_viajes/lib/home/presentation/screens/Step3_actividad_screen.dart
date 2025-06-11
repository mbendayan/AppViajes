
/*final stepperProvider = StateNotifierProvider<StepperProvider, bool>(
  (ref) => StepperProvider(),
);*/
import 'package:app_viajes/home/presentation/providers/current_travel_provider.dart';
import 'package:app_viajes/home/presentation/providers/step_provider.dart';
import 'package:app_viajes/home/presentation/screens/activities_screen.dart';
import 'package:app_viajes/home/presentation/screens/ver_actividad_screen.dart';
import 'package:app_viajes/models/step.dart';
import 'package:app_viajes/models/travel_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class Step3ActividadScreen extends ConsumerStatefulWidget {
  final bool isViewMode; // Nuevo parámetro para modo visualizar

  const Step3ActividadScreen({super.key, this.isViewMode = false});

  @override
  ConsumerState<Step3ActividadScreen> createState() => _Step3ActividadState();
}

class _Step3ActividadState extends ConsumerState<Step3ActividadScreen> {
  DateTime? selectedDate;

  List<Steps> getFilteredActivities(List<Steps> activities) {
    if (selectedDate == null) return activities;
    return activities
        .where((activity) => isSameDay(activity.startDate, selectedDate!))
        .toList();
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _selectDate() async {
    if (!widget.isViewMode) {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2025),
        lastDate: DateTime(2030),
      );

      if (pickedDate != null && pickedDate != selectedDate) {
        setState(() {
          selectedDate = pickedDate;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final List<Steps> activities = ref.read(generatedStepsProvider);
  }

  @override
  Widget build(BuildContext context) {
    CreateTravelResponse? travel = ref.read(currentTravelProvider);
    final List<Steps> activities = ref.read(generatedStepsProvider);
    final filteredActivities = getFilteredActivities(activities);
    print(activities);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _selectDate,
                      child: const Text('Filtrar por Fecha'),
                    ),
                  ElevatedButton(
                      onPressed: widget.isViewMode
                          ? null
                          : () {
                           context.push(
                           '/activities',
                           extra: travel, // Esto es un objeto CreateTravelResponse
                              );
                            },
                      child: const Text('Agregar Actividad'),
                    ),
                  ],
                ),
                if (selectedDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredActivities.length,
              itemBuilder: (context, index) {
                final activity = filteredActivities[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(activity.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Inicio: ${DateFormat('dd/MM/yyyy').format(activity.startDate)}'),
                        Text('Fin: ${DateFormat('dd/MM/yyyy').format(activity.endDate)}'),
                        Text('Costo: ${activity.cost} "USD"'),
                        Text('Recomendaciones: ${activity.recommendations}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerActividadScreen(activity: activity),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
