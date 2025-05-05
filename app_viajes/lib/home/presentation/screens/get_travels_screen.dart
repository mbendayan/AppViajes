import 'package:app_viajes/models/travelMenuItem.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GetTravelsScreen extends StatelessWidget {
  static const name = 'home_screen';
  final scafoldKey = GlobalKey<ScaffoldState>();

  GetTravelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(title: const Text('Gestión de viajes')),
      body: const _HomeView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push("/nuevoViaje");
        },
        tooltip: "Agregar Viaje",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    var items = travelMenuItems;

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];
        return _CustomListTile(item: item);
      },
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final TravelMenuItem item;

  const _CustomListTile({required this.item});

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
                  onPressed: () {
                    context.pushNamed("/viaje", extra: "hola");
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  label: const Text("Editar"),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Acción para eliminar
                  },
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
