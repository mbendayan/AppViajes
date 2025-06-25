import 'package:app_viajes/home/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_viajes/shared/widgets/appbar_login.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _usernameController.text;
    final password = _passwordController.text;

    try {
      await ref.read(authProvider.notifier).login(email, password);

      final userState = ref.read(authProvider);
      userState.when(
        data: (user) {
          if (user != null) {
            context.push("/home");
          } else {
            _showError('Usuario o contraseña inválidos');
          }
        },
        loading: () {},
        error: (err, stack) {
          _showError('Usuario o contraseña inválidos');
        },
      );
    } catch (e) {
      _showError('Excepción: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: const AppViajesAppBar(title: 'Login'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
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
            authState.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _login,
                  child: Text('Iniciar Sesión'),
                ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () => context.push("/registro"),
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
