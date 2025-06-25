import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // Para manejar el JSON
import 'package:http/http.dart' as http;

class RecommendationsScreen extends StatefulWidget {
  final int travelId;

  const RecommendationsScreen({Key? key, required this.travelId})
    : super(key: key);

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  Map<String, dynamic> recommendations = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://localhost:8080/travels/${widget.travelId}/recommendations',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          recommendations = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load recommendations');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading recommendations: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final categories =
        recommendations.keys.where((key) => key != 'temperatura').toList();
    final temperature = recommendations['temperatura'];

    return Scaffold(
      appBar: AppBar(title: const Text('Recomendaciones')),
      body: Column(
        children: [
          if (temperature != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'temperatura: $temperature',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 400.0,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              items:
                  categories.map((category) {
                    final items = List<String>.from(
                      recommendations[category] ?? [],
                    );

                    return Builder(
                      builder: (BuildContext context) {
                        return _buildCategoryCard(category, items);
                      },
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String category, List<String> items) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ), // Limita el ancho máximo
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Evita que sea desplazable
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '- ${items[index]}',
                      style: const TextStyle(fontSize: 16),
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
