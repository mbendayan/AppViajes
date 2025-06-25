import 'package:app_viajes/models/step.dart';
import 'package:flutter/material.dart';
import 'package:app_viajes/shared/widgets/appbar_go_home.dart';
import 'package:intl/intl.dart';

class VerActividadScreen extends StatelessWidget {
  final Steps activity;

  const VerActividadScreen({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppViajesAppBar(title: activity.name),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    activity.recommendations ?? "Sin recomendaciones",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Inicio: ${DateFormat('dd/MM/yyyy').format(activity.startDate)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Fin: ${DateFormat('dd/MM/yyyy').format(activity.endDate)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Costo: ${activity.cost} USD',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ubicación:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(activity.location, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
