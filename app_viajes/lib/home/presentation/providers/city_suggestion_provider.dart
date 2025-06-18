import 'package:app_viajes/home/presentation/providers/debounce_query_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final citySuggestionsProvider = FutureProvider<List<String>>((ref) async {
  final query = ref.watch(debouncedQueryProvider);

  if (query.isEmpty || query.length < 2) return [];

  // Llamada API con Dio (igual que tenés)
  final dio = Dio();
  final response = await dio.get(
    'https://wft-geo-db.p.rapidapi.com/v1/geo/cities',
    queryParameters: {'namePrefix': query, 'limit': 10},
    options: Options(
      headers: {
        'X-RapidAPI-Key': '57c9600775msh20cb60f6c4a9ebap180d78jsn67fe35586ede',
        'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com',
      },
    ),
  );

  final data = response.data['data'] as List;
  return data.map((city) {
    final cityName = city['city'];
    final country = city['country'];
    return "$cityName, $country";
  }).toList();
});
