import 'package:app_viajes/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                context.go('/home');
              },
              child: Image.asset('assets/images/logo.jpeg', height: 40),
            ),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: Colors.black)),
          ],
        ),
        actions: [
          ...(actions ?? []),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
