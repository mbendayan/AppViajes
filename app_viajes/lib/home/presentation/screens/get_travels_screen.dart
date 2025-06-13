import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_viajes/home/presentation/providers/travel_item_provider.dart';
import 'package:app_viajes/home/presentation/providers/travel_provider.dart';
import 'package:app_viajes/models/trave_menu_item.dart';
import 'package:app_viajes/shared/widgets/app_scaffold.dart';

class GetTravelsScreen extends ConsumerStatefulWidget {
  static const name = 'getTravels_screen';

  const GetTravelsScreen({super.key});

  @override
  ConsumerState<GetTravelsScreen> createState() => _GetTravelsScreenState();
}

class _GetTravelsScreenState extends ConsumerState<GetTravelsScreen> {
  List<dynamic> invitations = [];
  bool isLoading = false;

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

  Future<void> fetchInvitations() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    try {
      final response = await http.get(
        Uri.parse(
          "http://localhost:8080/api/users/${userId}/invitations/received",
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          invitations = json.decode(response.body);
        });
      } else {
        throw Exception("Failed to load invitations");
      }
    } catch (error) {
      debugPrint("Error fetching invitations: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> respondToInvitation(
    int invitationId,
    String response,
    BuildContext dialogContext, // para cerrar el diálogo
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      final url = Uri.parse(
        "http://localhost:8080/api/users/$userId/invitations/$invitationId/respond",
      );

      final body = jsonEncode({'response': response});
      final headers = {'Content-Type': 'application/json'};

      final httpResponse = await http.post(url, body: body, headers: headers);

      if (httpResponse.statusCode == 200) {
        Fluttertoast.showToast(
          msg:
              response == "ACCEPTED"
                  ? "Invitación aceptada correctamente"
                  : "Invitación rechazada",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );

        Navigator.of(dialogContext).pop(); // ❗Cerrar el diálogo

        await fetchInvitations(); // Actualizar invitaciones

        // 🔄 Recargar viajes después de aceptar
        if (response == "ACCEPTED" && userId != null) {
          await ref.read(travelProvider.notifier).fetchUserTravels(userId);
        }
      } else {
        throw Exception("Error al responder la invitación");
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al procesar la invitación",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      debugPrint("Error al responder la invitación: $error");
    }
  }

  void showInvitationsDialog() async {
    await fetchInvitations();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Invitaciones Recibidas"),
          content:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : invitations.isEmpty
                  ? const Text("No tienes invitaciones pendientes.")
                  : SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: invitations.length,
                      itemBuilder: (context, index) {
                        final invitation = invitations[index];
                        final isAccepted = invitation['status'] == 'ACCEPTED';
                        final isRejected = invitation['status'] == 'REJECTED';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(invitation['travelName']),
                            trailing:
                                isAccepted
                                    ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                    : isRejected
                                    ? const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    )
                                    : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton(
                                          onPressed:
                                              () => respondToInvitation(
                                                invitation['id'],
                                                "ACCEPTED",
                                                context,
                                              ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          child: const Text("Aceptar"),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed:
                                              () => respondToInvitation(
                                                invitation['id'],
                                                "REJECTED",
                                                context,
                                              ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: const Text("Rechazar"),
                                        ),
                                      ],
                                    ),
                          ),
                        );
                      },
                    ),
                  ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
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
              return CustomListTile(
                item: item,
                onDelete: () => _removeItem(item),
                onEdit:
                    () => context.push(
                      "/nuevoViaje",
                      extra: {'isEditMode': true},
                    ),
                getRecomendations:
                    () => context.push("/verRecomendaciones/${item.id}"),
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
              onPressed: showInvitationsDialog,
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

class CustomListTile extends StatelessWidget {
  final TravelMenuItem item;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback getRecomendations;

  const CustomListTile({
    Key? key,
    required this.item,
    required this.onDelete,
    required this.onEdit,
    required this.getRecomendations,
  }) : super(key: key);

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
            Text(item.destination, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: getRecomendations,
                  icon: const Icon(Icons.list, color: Colors.green),
                  label: const Text("Ver Recomendaciones"),
                ),
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
