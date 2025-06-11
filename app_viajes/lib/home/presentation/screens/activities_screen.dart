
import 'package:app_viajes/home/presentation/providers/step_list_provider.dart';
import 'package:app_viajes/models/step.dart';
import 'package:app_viajes/home/presentation/screens/ver_actividad_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ActivitiesScreen extends ConsumerWidget {
  final String place;

  const ActivitiesScreen({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(stepsProvider)
        .where((activity) => activity.location.contains(place))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Descubre actividades en $place')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: activities.isEmpty
            ? const Center(
                child: Text(
                  'No hay actividades disponibles en este lugar.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(activity.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Inicio: ${DateFormat('dd/MM/yyyy').format(activity.startDate)}'),
                          Text('Fin: ${DateFormat('dd/MM/yyyy').format(activity.endDate)}'),
                          Text('Costo: ${activity.cost} €'),
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
    );
  }
}
