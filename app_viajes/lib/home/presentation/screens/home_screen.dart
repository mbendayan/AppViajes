import 'package:app_viajes/home/presentation/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(HomeScreen());
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                // Acción para iniciar sesión
                final username = _usernameController.text;
                final password = _passwordController.text;
                print('Usuario: $username, Contraseña: $password');
              },
              child: Text('Iniciar Sesión'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // Acción para registrarse
                context.push("/registro");
              },
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
