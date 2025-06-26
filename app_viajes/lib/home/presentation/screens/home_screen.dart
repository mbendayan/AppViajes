import 'package:app_viajes/home/presentation/providers/user_provider.dart';
import 'package:app_viajes/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoginScreen2(); // Solo devuelve el contenido
  }
}

class LoginScreen2 extends ConsumerWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final userProvider = StateNotifierProvider<UserNotifier, User>(
    (ref) => UserNotifier(User(username: '', id: 0, email: '', password: '')),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotifier = ref.read(userProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text('Login'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                final username = _usernameController.text;
                final password = _passwordController.text;

                final userNotifier = ref.read(userProvider.notifier);
                await userNotifier.login("usuario", "clave");
                context.push("/home");
              },
              child: Text('Iniciar Sesión'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                context.push("/registro");
              },
              child: Text('Registrarse'),
            ),
            TextButton(
              onPressed: () {
                context.push("/preferences");
              },
              child: Text('Preferencias'),
            ),
          ],
        ),
      ),
    );
  }
}
