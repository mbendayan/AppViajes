import 'package:app_viajes/home/presentation/screens/activities_screen.dart';
import 'package:app_viajes/home/presentation/screens/preferences_screen.dart';
import 'package:app_viajes/home/presentation/screens/abm_viaje_screen.dart';
import 'package:app_viajes/home/presentation/screens/get_travels_screen.dart';
import 'package:app_viajes/home/presentation/screens/register.dart';
import 'package:app_viajes/home/presentation/screens/ver_actividad_screen.dart';
import 'package:app_viajes/models/step.dart';
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
    GoRoute(
      name: 'verActividad',
      path: '/verActividad',
      builder:
          (context, state) => VerActividadScreen(
            activity: Steps(
              id: "1",
              travelId: "",
              startDate: DateTime.now(),
              endDate: DateTime.now(),
              location: "",
              name: "",
              cost: 0,
              recommendations: "",
            ),
          ),
    ),
    GoRoute(
      name: 'getActivities',
      path: '/getActivities',
      builder: (context, state) => ActivitiesScreen(),
    ),
  ],
);
