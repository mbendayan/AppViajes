import 'dart:convert';

import 'package:app_viajes/home/presentation/providers/edit_travel_provider.dart';
import 'package:app_viajes/home/presentation/providers/travel_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step2PreferencesScreen extends ConsumerStatefulWidget {
  final VoidCallback? onSaved;
  final bool isViewMode; // Nuevo parámetro para modo visualizar

  const Step2PreferencesScreen({
    super.key,
    this.isViewMode = false,
    this.onSaved,
  });

  @override
  ConsumerState<Step2PreferencesScreen> createState() =>
      _Step2PreferencesScreenState();
}

class _Step2PreferencesScreenState
    extends ConsumerState<Step2PreferencesScreen> {
  @override
  void initState() {
    super.initState();
    final travel = ref.read(editTraverProvider);

    if (travel.id != 0) {
      final preferences = jsonDecode(travel.preferences ?? '{}');
      _budgetController.text = preferences['presupuesto'] ?? '';
      _selectedAccommodation = preferences['tipoAlojamiento'];
      _selectedTravelType = preferences['tipoViaje'];
      _selectedTransports = List<String>.from(
        preferences['tipoTransporte'] ?? [],
      );
    } else {
      // inicializa si id =0
      _budgetController.text = '';
      _selectedAccommodation = null;
      _selectedTravelType = null;
      _selectedTransports = [];
    }
  }

  final TextEditingController _budgetController = TextEditingController();
  String? _selectedAccommodation;
  String? _selectedTravelType;
  List<String> _selectedTransports = [];
  String? _expandedSection;

  final _accommodationOptions = [
    {'label': 'Hotel', 'icon': Icons.hotel},
    {'label': 'Hostel', 'icon': Icons.bed},
    {'label': 'Departamento', 'icon': Icons.apartment},
    {'label': 'Camping', 'icon': Icons.park},
  ];

  final _travelTypeOptions = [
    {'label': 'Aventura', 'icon': Icons.hiking},
    {'label': 'Relajado', 'icon': Icons.spa},
    {'label': 'Cultural', 'icon': Icons.museum},
    {'label': 'Gastronómico', 'icon': Icons.restaurant},
  ];

  final _transportOptions = [
    {'label': 'Avión', 'icon': Icons.flight},
    {'label': 'Tren', 'icon': Icons.train},
    {'label': 'Auto', 'icon': Icons.directions_car},
    {'label': 'Bus', 'icon': Icons.directions_bus},
  ];

  void _toggleTransport(String transport) {
    if (!widget.isViewMode) {
      setState(() {
        if (_selectedTransports.contains(transport)) {
          _selectedTransports.remove(transport);
        } else {
          _selectedTransports.add(transport);
        }
      });
      _savePreferencesToProvider();
    }
  }

  void _savePreferencesToProvider() {
    final budgetText = _budgetController.text.trim();

    final preferencesMap = {
      'presupuesto': budgetText,
      'tipoViaje': _selectedTravelType ?? '',
      'tipoAlojamiento': _selectedAccommodation ?? '',
      'tipoTransporte': _selectedTransports,
    };

    final preferencesJson = jsonEncode(preferencesMap);

    ref
        .read(travelFormProvider.notifier)
        .updateForm(preferences: preferencesJson);

    widget.onSaved?.call();
  }

  Widget _buildGridOptions({
    required List<Map<String, dynamic>> options,
    required String? selected,
    required Function(String) onSelect,
    bool multiSelect = false,
    List<String>? selectedList,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        children:
            options.map((option) {
              final label = option['label'];
              final icon = option['icon'];
              final isSelected =
                  multiSelect
                      ? selectedList!.contains(label)
                      : selected == label;

              return GestureDetector(
                onTap:
                    widget.isViewMode
                        ? null
                        : () {
                          onSelect(label);
                          _savePreferencesToProvider();
                        },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Colors.blue.shade100
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 16, color: Colors.black54),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      children: [
        ExpansionPanelList.radio(
          expandedHeaderPadding: EdgeInsets.zero,
          initialOpenPanelValue: _expandedSection,
          children: [
            ExpansionPanelRadio(
              value: 'budget',
              headerBuilder:
                  (_, __) => const ListTile(title: Text('Presupuesto')),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _budgetController,
                  decoration: const InputDecoration(
                    labelText: 'Presupuesto (USD)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  enabled: !widget.isViewMode, // modo lectura deshabilitado
                  onChanged: (value) {
                    final parsed = double.tryParse(value);
                    if (parsed == null || parsed < 0) {
                      _budgetController.text = '';
                      _budgetController.selection = TextSelection.collapsed(
                        offset: 0,
                      );
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text('Valor inválido'),
                              content: const Text(
                                'El presupuesto debe ser un número mayor o igual a 0.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                      );
                      return;
                    }

                    _savePreferencesToProvider();
                  },
                ),
              ),
            ),
            ExpansionPanelRadio(
              value: 'accommodation',
              headerBuilder:
                  (_, __) => const ListTile(title: Text('Tipo de Alojamiento')),
              body: _buildGridOptions(
                options: _accommodationOptions,
                selected: _selectedAccommodation,
                onSelect: (value) {
                  setState(() => _selectedAccommodation = value);
                },
              ),
            ),
            ExpansionPanelRadio(
              value: 'travelType',
              headerBuilder:
                  (_, __) => const ListTile(title: Text('Tipo de Viaje')),
              body: _buildGridOptions(
                options: _travelTypeOptions,
                selected: _selectedTravelType,
                onSelect: (value) {
                  setState(() => _selectedTravelType = value);
                },
              ),
            ),
            ExpansionPanelRadio(
              value: 'transport',
              headerBuilder:
                  (_, __) => const ListTile(title: Text('Medio de Transporte')),
              body: _buildGridOptions(
                options: _transportOptions,
                selected: '',
                selectedList: _selectedTransports,
                onSelect: _toggleTransport,
                multiSelect: true,
              ),
            ),
          ],
          expansionCallback: (index, isExpanded) {
            if (!widget.isViewMode) {
              setState(() {
                _expandedSection =
                    isExpanded
                        ? null
                        : [
                          'budget',
                          'accommodation',
                          'travelType',
                          'transport',
                        ][index];
              });
            }
          },
        ),
      ],
    );
  }
}
