import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_viajes/config/theme/presentation/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  static const name = 'settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Tema'),
            subtitle: Text(theme.isDarkMode ? 'Oscuro' : 'Claro'),
            trailing: Switch(
              value: theme.isDarkMode,
              onChanged:
                  (_) =>
                      ref.read(themeNotifierProvider.notifier).toggleDarkMode(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () {
              context.go('/');
            },
          ),
        ],
      ),
    );
  }
}
