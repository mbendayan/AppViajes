import 'package:app_viajes/home/presentation/screens/ver_actividad_screen.dart';
import 'package:app_viajes/models/step.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivitiesScreen extends StatefulWidget {
  final String place; // Agregar el parámetro place

  const ActivitiesScreen({Key? key, required this.place}) : super(key: key);

  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final List<Steps> activities = [
    Steps(
      id: 1,
     
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(hours: 3)),
      location: 'Valle Central',
      name: 'Paseo en globo aerostático',
      cost: "150.0",
      recommendations: 'Llevar ropa cómoda.',
    ),
    Steps(
      id: 2,
     
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(hours: 2)),
      location: 'Valle Central',
      name: 'Clase de cocina local',
      cost: "80.0",
      recommendations: 'Aprenderás recetas locales.',
    ),
    Steps(
      id: 3,
    
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 1)),
      location: 'Valle Central',
      name: 'Excursión al Parque Nacional',
      cost: "50.0",
      recommendations: 'Llevar calzado cómodo y agua.',
    ),
  ];

  String searchQuery = '';
  String selectedCategory = 'Ver todo';
  final List<String> categories = [
    'Cultural',
    'Gastronomía',
    'Aventura',
    'Naturaleza',
    'Ver todo',
  ];

  List<Steps> getFilteredActivities() {
    return activities.where((activity) {
      final matchesCategory =
          selectedCategory == 'Ver todo' ||
          activity.recommendations.contains(selectedCategory);
      final matchesSearch = activity.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final matchesPlace = activity.location.contains(widget.place);
      return matchesCategory && matchesSearch && matchesPlace;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredActivities = getFilteredActivities();
    return Scaffold(
      appBar: AppBar(title: Text('Descubre actividades en ${widget.place}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar actividades, tours, experiencias...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child:
                  filteredActivities.isEmpty
                      ? Center(
                        child: Text(
                          'No hay actividades para la fecha seleccionada.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      : ListView.builder(
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
                                  Text(
                                    'Costo: ${activity.cost} €',
                                  ),
                                  Text(
                                    'Recomendaciones: ${activity.recommendations}',
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_red_eye),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => VerActividadScreen(
                                            activity: activity,
                                          ),
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
      ),
    );
  }
}
