import 'package:app_viajes/home/presentation/providers/travel_item_provider.dart';
import 'package:app_viajes/models/trave_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_viajes/shared/widgets/appbar_go_home.dart';

class GetAnotherTravelsScreen extends ConsumerWidget {
  static const name = 'getAnotherTravels_screen';

  const GetAnotherTravelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travelItemsState = ref.watch(travelItemProvider);

    return Scaffold(
      appBar: const AppViajesAppBar(title: 'Gestion de Viajes'),
      body: travelItemsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (travelMenuItems) {
          if (travelMenuItems.isEmpty) {
            return const Center(child: Text('No hay viajes disponibles'));
          }

          return ListView.builder(
            itemCount: travelMenuItems.length,
            itemBuilder: (BuildContext context, int index) {
              final item = travelMenuItems[index];
              return _CustomListTile(
                item: item,
                onViewActivities:
                    () => context.push(
                      "/nuevoViaje",
                      extra: {'isViewMode': true},
                    ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final TravelMenuItem item;
  final VoidCallback onViewActivities;

  const _CustomListTile({required this.item, required this.onViewActivities});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Fecha Inicio: ${item.dateStart}"),
            Text("Fecha Fin: ${item.dateEnd}"),
            const SizedBox(height: 8),
            Text(item.destination, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onViewActivities,
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  label: const Text("Ver actividades"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
