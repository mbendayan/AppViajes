import 'package:flutter/material.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});
  static const name = 'preferences';

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final TextEditingController _budgetController = TextEditingController();
  String? _selectedAccommodation;
  String? _selectedTravelType;
  List<String> _selectedTransports = [];

  // Identificador del panel expandido actualmente
  String? _expandedSection;

  final List<Map<String, dynamic>> _accommodationOptions = [
    {'label': 'Hotel', 'icon': Icons.hotel},
    {'label': 'Hostel', 'icon': Icons.bed},
    {'label': 'Departamento', 'icon': Icons.apartment},
    {'label': 'Camping', 'icon': Icons.park},
  ];

  final List<Map<String, dynamic>> _travelTypeOptions = [
    {'label': 'Aventura', 'icon': Icons.hiking},
    {'label': 'Relajado', 'icon': Icons.spa},
    {'label': 'Cultural', 'icon': Icons.museum},
    {'label': 'Gastronomico', 'icon': Icons.restaurant},
  ];

  final List<Map<String, dynamic>> _transportOptions = [
    {'label': 'Avion', 'icon': Icons.flight},
    {'label': 'Tren', 'icon': Icons.train},
    {'label': 'Auto', 'icon': Icons.directions_car},
    {'label': 'Bus', 'icon': Icons.directions_bus},
  ];

  void _toggleTransport(String transport) {
    setState(() {
      _selectedTransports.contains(transport)
          ? _selectedTransports.remove(transport)
          : _selectedTransports.add(transport);
    });
  }

  void _savePreferences() {
    print('Budget: ${_budgetController.text}');
    print('Accommodation: $_selectedAccommodation');
    print('Travel Type: $_selectedTravelType');
    print('Transport Types: $_selectedTransports');
  }

  Widget _buildGridOptions({
    required List<Map<String, dynamic>> options,
    required String? selected,
    required Function(String) onSelect,
    bool multiSelect = false,
    List<String>? selectedList,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: options.map((option) {
          final label = option['label'];
          final icon = option['icon'];
          final isSelected = multiSelect
              ? selectedList!.contains(label)
              : selected == label;

          return GestureDetector(
            onTap: () => onSelect(label),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(icon, color: Colors.black54),
                  const SizedBox(width: 8),
                  Expanded(child: Text(label)),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Preferences'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ExpansionPanelList.radio(
            expandedHeaderPadding: EdgeInsets.zero,
            initialOpenPanelValue: _expandedSection,
            children: [
              ExpansionPanelRadio(
                value: 'budget',
                headerBuilder: (_, __) => const ListTile(title: Text('Presupuesto')),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _budgetController,
                    decoration: const InputDecoration(
                      labelText: 'Presupuesto (USD)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ),
              ExpansionPanelRadio(
                value: 'accommodation',
                headerBuilder: (_, __) => const ListTile(title: Text('Tipo de Alojamiento')),
                body: _buildGridOptions(
                  options: _accommodationOptions,
                  selected: _selectedAccommodation,
                  onSelect: (value) => setState(() => _selectedAccommodation = value),
                ),
              ),
              ExpansionPanelRadio(
                value: 'travelType',
                headerBuilder: (_, __) => const ListTile(title: Text('Tipo de Viaje')),
                body: _buildGridOptions(
                  options: _travelTypeOptions,
                  selected: _selectedTravelType,
                  onSelect: (value) => setState(() => _selectedTravelType = value),
                ),
              ),
              ExpansionPanelRadio(
                value: 'transport',
                headerBuilder: (_, __) => const ListTile(title: Text('Medio de Transporte')),
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
              setState(() {
                _expandedSection = isExpanded ? null : ['budget', 'accommodation', 'travelType', 'transport'][index];
              });
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _savePreferences,
            child: const Text('Guardar Preferencias'),
          )
        ],
      ),
    );
  }
}
