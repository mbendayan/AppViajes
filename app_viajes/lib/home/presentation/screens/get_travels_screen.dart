import 'package:app_viajes/home/presentation/providers/travel_item_provider.dart';
import 'package:app_viajes/home/presentation/providers/travel_provider.dart';
import 'package:app_viajes/models/trave_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_viajes/shared/widgets/app_scaffold.dart';


class GetTravelsScreen extends ConsumerStatefulWidget {
  static const name = 'getTravels_screen';

  const GetTravelsScreen({super.key});

  @override
  ConsumerState<GetTravelsScreen> createState() => _GetTravelsScreenState();
}

class _GetTravelsScreenState extends ConsumerState<GetTravelsScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchTravels();
  }

  Future<void> _loadUserIdAndFetchTravels() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId != null) {
      await ref.read(travelProvider.notifier).fetchUserTravels(userId);
    } else {
      debugPrint('No se encontró userId en SharedPreferences');
    }
  }

  void _removeItem(TravelMenuItem item) {
    // Acá podrías agregar lógica para eliminar el viaje si es necesario
  }

  @override
  Widget build(BuildContext context) {

    final travelItemsState = ref.watch(travelItemProvider);

    return AppScaffold(
      title: 'Gestión de viajes',
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
                onDelete: () => _removeItem(item),
                onEdit: () => context.push("/nuevoViaje"),
              );
            },
          );
        },
      ),
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 80,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String? codigo;
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text("Unirse a un viaje"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                              labelText: "Código del viaje",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              codigo = value;
                            },
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (codigo != null && codigo!.isNotEmpty) {
                              print("Código ingresado: $codigo");
                              Navigator.pop(context);
                              // Acá podrías agregar la lógica para unirse al viaje
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Por favor, ingresa un código válido",
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text("Unirse"),
                        ),
                      ],
                    );
                  },
                );
              },
              tooltip: "Sumate a un viaje",
              child: const Icon(Icons.share),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () => context.push("/nuevoViaje"),
              tooltip: "Agregar Viaje",
              child: const Icon(Icons.add),
            ),
          ),
          Positioned(
            bottom: 202,
            right: 16,
            child: FloatingActionButton(
              onPressed: () => context.push("/traductor"),
              tooltip: "Ver palabras clave",
              child: const Icon(Icons.translate),
            ),
          ),
          Positioned(
            bottom: 144,
            right: 16,
            child: FloatingActionButton(
              onPressed: () => context.push("/verViajesYaHechos"),
              tooltip: "Ver viajes ya hechos",
              child: const Icon(Icons.flight),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final TravelMenuItem item;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _CustomListTile({
    required this.item,
    required this.onDelete,
    required this.onEdit,
  });

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
            Text(item.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Fecha Inicio: ${item.dateStart}"),
            Text("Fecha Fin: ${item.dateEnd}"),
            Text(item.destination, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  label: const Text("Editar"),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text("Eliminar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}