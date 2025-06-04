import 'package:app_viajes/models/travelMenuItem.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GetAnotherTravelsScreen extends StatefulWidget {
  static const name = 'getAnotherTravels_screen';

  const GetAnotherTravelsScreen({super.key});

  @override
  State<GetAnotherTravelsScreen> createState() =>
      _GetAnotherTravelsScreenState();
}

class _GetAnotherTravelsScreenState extends State<GetAnotherTravelsScreen> {
  final List<TravelMenuItem> items = List.from(travelMenuItems);

  void _removeItem(TravelMenuItem item) {
    setState(() {
      items.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de viajes')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          return _CustomListTile(
            item: item,
            onDelete: () => _removeItem(item),
            onEdit:
                () => context.push("/nuevoViaje", extra: {'isViewMode': true}),
          );
        },
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
            Text(
              item.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Fecha Inicio: ${(item.dateStart)}"),
            Text("Fecha Fin: ${(item.dateEnd)}"),
            Text("Costo: ${item.price}"),

            const SizedBox(height: 8),
            Text(item.destination, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
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
