import 'package:app_viajes/home/presentation/providers/current_travel_provider.dart';
import 'package:app_viajes/home/presentation/providers/step_provider.dart';
import 'package:app_viajes/home/presentation/screens/ver_actividad_screen.dart';
import 'package:app_viajes/models/step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class Step3ActividadScreen extends ConsumerStatefulWidget {
  final bool isViewMode;

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
  Widget build(BuildContext context) {
    final travel = ref.watch(currentTravelProvider);
    final activities = ref.watch(generatedStepsProvider);
    final generatedStepsNotifier = ref.read(generatedStepsProvider.notifier);

    final sortedActivities = [...activities]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    final filteredActivities = getFilteredActivities(sortedActivities);

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
                      onPressed:
                          widget.isViewMode
                              ? null
                              : () {
                                context.push('/activities', extra: travel);
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
            child:
                filteredActivities.isEmpty
                    ? const Center(
                      child: Text('No hay actividades para mostrar.'),
                    )
                    : ListView.builder(
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
                                Text(
                                  'Inicio: ${DateFormat('dd/MM/yyyy').format(activity.startDate)}',
                                ),
                                Text(
                                  'Fin: ${DateFormat('dd/MM/yyyy').format(activity.endDate)}',
                                ),
                                Text('Lugar: ${activity.location}'),
                                Text('Costo: ${activity.cost} USD'),
                                if (activity.recommendations != null)
                                  Text(
                                    'Recomendaciones: ${activity.recommendations}',
                                  ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_red_eye),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => VerActividadScreen(
                                              activity: activity,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                                if (!widget.isViewMode)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      generatedStepsNotifier.state = [
                                        ...generatedStepsNotifier.state.where(
                                          (step) => step.id != activity.id,
                                        ),
                                      ];
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Actividad "${activity.name}" eliminada.',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              ],
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
