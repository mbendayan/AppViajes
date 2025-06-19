import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class DestinoAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String value) onChanged;

  const DestinoAutocompleteField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<DestinoAutocompleteField> createState() => _DestinoAutocompleteFieldState();
}

class _DestinoAutocompleteFieldState extends State<DestinoAutocompleteField> {
  Timer? _debounce;

  Future<List<String>> fetchSuggestionsWithDebounce(String pattern) async {
    _debounce?.cancel();

    final completer = Completer<List<String>>();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (pattern.length < 2) {
        completer.complete([]);
        return;
      }

      try {
        final dio = Dio();
        final response = await dio.get(
          'https://wft-geo-db.p.rapidapi.com/v1/geo/cities',
          queryParameters: {'namePrefix': pattern, 'limit': 5}, // 5 para mostrar menos
          options: Options(
            headers: {
              'X-RapidAPI-Key': '57c9600775msh20cb60f6c4a9ebap180d78jsn67fe35586ede',
              'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com',
            },
          ),
        );

        final data = response.data['data'] as List;
        final suggestions = data.map((city) {
          final cityName = city['city'];
          final country = city['country'];
          return "$cityName, $country";
        }).toList();

        completer.complete(suggestions);
      } catch (e) {
        completer.complete([]);
      }
    });

    return completer.future;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.controller,
        decoration: const InputDecoration(labelText: 'Destino'),
        onChanged: (value) {
          widget.onChanged(value);
        },
      ),
      suggestionsCallback: (pattern) async {
        return await fetchSuggestionsWithDebounce(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(title: Text(suggestion));
      },
      onSuggestionSelected: (suggestion) {
        widget.controller.text = suggestion;
        widget.onChanged(suggestion);
      },
      noItemsFoundBuilder: (_) => const SizedBox.shrink(),
      suggestionsBoxDecoration: const SuggestionsBoxDecoration(
        constraints: BoxConstraints(maxHeight: 200),
      ),
    );
  }
}
