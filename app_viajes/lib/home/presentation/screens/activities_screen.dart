
import 'package:app_viajes/home/presentation/providers/new_steps_provider.dart';
import 'package:app_viajes/home/presentation/providers/step_provider.dart';
import 'package:app_viajes/home/presentation/screens/ver_actividad_screen.dart';
import 'package:app_viajes/models/travel_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ActivitiesScreen extends ConsumerWidget {
  final CreateTravelResponse travel;

  const ActivitiesScreen({Key? key, required this.travel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncActivities = ref.watch(newStepsProvider(travel.id));
    final generatedSteps = ref.watch(generatedStepsProvider);
    final generatedNotifier = ref.read(generatedStepsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Actividades en ${travel.destination}')),
      body: asyncActivities.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error al cargar actividades: $e'),
        ),
        data: (activities) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: activities.isEmpty
              ? const Center(
                  child: Text(
                    'No hay actividades disponibles para este viaje.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    final alreadyAdded = generatedSteps.any((s) => s.id == activity.id);

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(activity.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Inicio: ${DateFormat('dd/MM/yyyy').format(activity.startDate)}'),
                            Text('Fin: ${DateFormat('dd/MM/yyyy').format(activity.endDate)}'),
                            Text('Costo: ${activity.cost} USD'),
                            if (activity.recommendations != null)
                              Text('Recomendaciones: ${activity.recommendations}'),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                alreadyAdded ? Icons.check_circle : Icons.add_circle_outline,
                                color: alreadyAdded ? Colors.green : null,
                              ),
                              onPressed: alreadyAdded
                                  ? null
                                  : () {
                                      generatedNotifier.addStep(activity);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${activity.name} agregada al viaje')),
                                      );
                                    },
                            ),
                            IconButton(
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
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}