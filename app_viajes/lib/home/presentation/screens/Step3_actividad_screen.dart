import 'package:app_viajes/home/presentation/screens/activities_screen.dart';
import 'package:app_viajes/home/presentation/screens/ver_actividad_screen.dart';
import 'package:app_viajes/models/step.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/*final stepperProvider = StateNotifierProvider<StepperProvider, bool>(
  (ref) => StepperProvider(),
);*/
class Step3ActividadScreen extends StatefulWidget {
  const Step3ActividadScreen({super.key});

  @override
  State<Step3ActividadScreen> createState() => Step3ActividadState();
}

class Step3ActividadState extends State<Step3ActividadScreen> {
  DateTime? selectedDate;
  List<Steps> activities = [
    Steps(
      id: '1',
      travelId: 't1',
      startDate: DateTime.parse('2025-05-20'),
      endDate: DateTime.parse('2025-05-20'),
      location: '40.7128,-74.0060',
      name: 'Visita al museo',
      cost: 15.00,
      recommendations: 'Visitar primero la sección de arte moderno.',
    ),
    Steps(
      id: '2',
      travelId: 't2',
      startDate: DateTime.parse('2025-05-21'),
      endDate: DateTime.parse('2025-05-21'),
      location: '40.7128,-74.0060',
      name: 'Visita al museo',
      cost: 15.00,
      recommendations: 'Visitar primero la sección de arte moderno.',
    ),
  ];

  List<Steps> getFilteredActivities() {
    if (selectedDate == null) return activities;
    return activities
        .where((activity) => activity.startDate == selectedDate)
        .toList();
  }

  void _selectDate() async {
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

  @override
  Widget build(BuildContext context) {
    final filteredActivities = getFilteredActivities();

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
                      child: Text('Filtrar por Fecha'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    ActivitiesScreen(place: 'Valle Central'),
                          ),
                        );
                      },
                      child: Text('Agregar Actividad'),
                    ),
                  ],
                ),
                if (selectedDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
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
                        Text('Costo: ${activity.cost.toStringAsFixed(2)} €'),
                        Text('Recomendaciones: ${activity.recommendations}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    VerActividadScreen(activity: activity),
                          ),
                        );
                      },
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
