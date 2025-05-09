import 'package:app_viajes/home/presentation/screens/preferences_screen.dart';
import 'package:app_viajes/home/presentation/screens/abm_viaje_screen.dart';
import 'package:app_viajes/home/presentation/screens/get_travels_screen.dart';
import 'package:app_viajes/home/presentation/screens/register.dart';
import 'package:go_router/go_router.dart';
import 'package:app_viajes/home/presentation/screens/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'login',
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      name: RegisterScreen.name,
      path: '/registro',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      name: PreferencesScreen.name,
      path: '/preferences',
      builder: (context, state) => PreferencesScreen(),
    ),
    GoRoute(
      name: GetTravelsScreen.name,
      path: '/home',
      builder: (context, state) => GetTravelsScreen(),
    ),
    GoRoute(
      name: 'verViaje',
      path: '/viaje',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      name: 'nuevoViaje',
      path: '/nuevoViaje',
      builder: (context, state) => ABMViajeScreen(),
    ),
  ],
);
