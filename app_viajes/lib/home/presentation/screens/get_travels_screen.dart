import 'package:app_viajes/models/travelMenuItem.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GetTravelsScreen extends StatefulWidget {
  static const name = 'getTravels_screen';

  const GetTravelsScreen({super.key});

  @override
  State<GetTravelsScreen> createState() => _GetTravelsScreenState();
}

class _GetTravelsScreenState extends State<GetTravelsScreen> {
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
            onEdit: () => context.push("/nuevoViaje"),
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
                      title: Text("Unirse a un viaje"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: InputDecoration(
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
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (codigo != null && codigo!.isNotEmpty) {
                              print("Código ingresado: $codigo");
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Por favor, ingresa un código válido",
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text("Unirse"),
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
              onPressed: () {
                context.push("/nuevoViaje");
              },
              tooltip: "Agregar Viaje",
              child: const Icon(Icons.add),
            ),
          ),
          Positioned(
            bottom: 202,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                context.push("/traductor");
              },
              tooltip: "Ver palabras clave",
              child: const Icon(Icons.add),
            ),
          ),
          Positioned(
            bottom: 144,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                context.push("/verViajesYaHechos");
              },
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
            Text(
              item.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Fecha Inicio: ${(item.dateStart)}"),
            Text("Fecha Fin: ${(item.dateEnd)}"),
            Text("Costo: ${item.price}"),
            Text("Codigo: ${item.code}"),

            const SizedBox(height: 8),
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
