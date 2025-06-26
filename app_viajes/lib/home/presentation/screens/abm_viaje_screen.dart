import 'dart:convert';

import 'package:app_viajes/config/theme/app_theme.dart';
import 'package:app_viajes/home/presentation/providers/save_travel_provider.dart';
import 'package:app_viajes/home/presentation/providers/travel_form_provider.dart';
import 'package:app_viajes/home/presentation/providers/travel_provider.dart';
import 'package:app_viajes/home/presentation/screens/step1_viaje_screen.dart';
import 'package:app_viajes/home/presentation/screens/Step3_actividad_screen.dart';
import 'package:app_viajes/home/presentation/screens/step2_preferences_screen.dart';
import 'package:app_viajes/models/trave_menu_item.dart';
import 'package:app_viajes/models/travel_request.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ABMViajeScreen extends ConsumerStatefulWidget {
  final bool isViewMode;
  final bool isEditMode;

  const ABMViajeScreen({
    super.key,
    this.isViewMode = false,
    this.isEditMode = false,
  });

  @override
  ConsumerState<ABMViajeScreen> createState() => _ABMViajeScreenState();
}

class _ABMViajeScreenState extends ConsumerState<ABMViajeScreen> {
  int _currentStep = 0;
  bool _preferencesSaved = false;
  bool _isLoading = false;
  late CreateTravelRequest travel;
  Future<void> sendInvitation(int travelId, String invitedUserEmail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      final url = Uri.parse('http://localhost:8080/travels/$userId/invite');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'travelId': travelId,
          'invitedUserEmail': invitedUserEmail,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "Invitación enviada con éxito",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        Navigator.pop(context);
      } else {
        throw Exception("Error al enviar la invitación: ${response.body}");
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error: $error",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Crea tu viaje")),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () async {
          if (_currentStep == 0) {
            setState(() => _currentStep++);
            return;
          }

          if (_currentStep == 1) {
            setState(() => _isLoading = true);

            travel = ref.read(travelFormProvider);

            try {
              await ref.read(travelProvider.notifier).createTravel(travel, ref);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Viaje creado con éxito")),
                );
                setState(() {
                  _isLoading = false;
                  _currentStep++;
                });
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Error: $e")));
              }

              setState(() => _isLoading = false);
            }

            return;
          }
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep < 2)
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: const Text('Continuar'),
                )
              else
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref.read(saveTravelProvider.notifier).save();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Viaje guardado con éxito"),
                          ),
                        );
                        context.push("/home");
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Error: $e")));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(74, 92, 146, 1),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Guardar'),
                ),

              if (_currentStep > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Regresar'),
                ),
            ],
          );
        },
        steps: [
          Step(
            title: const Text("Datos del viaje"),
            isActive: _currentStep == 0,
            content: SizedBox(
              height: 300,
              child: Step1ViajeScreen(
                onSaved: ({
                  required name,
                  required destination,
                  required startDate,
                  required endDate,
                }) {
                  ref
                      .read(travelFormProvider.notifier)
                      .updateForm2(
                        name: name,
                        destination: destination,
                        startDate: startDate.toIso8601String(),
                        endDate: endDate.toIso8601String(),
                      );
                },
                isViewMode: widget.isViewMode,
              ),
            ),
          ),
          Step(
            title: const Text("Preferencias del viaje"),
            isActive: _currentStep == 1,
            content: Step2PreferencesScreen(
              onSaved: () {},
              isViewMode: widget.isViewMode,
            ),
          ),

          Step(
            title: const Text("Actividades del viaje"),
            isActive: _currentStep == 2,
            content: SizedBox(
              height: 400,
              child: Step3ActividadScreen(isViewMode: widget.isViewMode),
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.isEditMode)
            Positioned(
              bottom: 80,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String? email;
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text("Invitar a un usuario"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "Email de usuario a invitar",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                email = value;
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
                            onPressed: () async {
                              if (email != null && email!.isNotEmpty) {
                                await sendInvitation(1, email!);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Por favor, ingresa un email válido",
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Text("Invitar"),
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
        ],
      ),
    );
  }
}
