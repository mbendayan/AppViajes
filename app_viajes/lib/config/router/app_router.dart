import 'package:app_viajes/home/presentation/screens/activities_screen.dart';
import 'package:app_viajes/home/presentation/screens/get_another_travels_screen.dart';
import 'package:app_viajes/home/presentation/screens/login_screen.dart';
import 'package:app_viajes/home/presentation/screens/preferences_screen.dart';
import 'package:app_viajes/home/presentation/screens/abm_viaje_screen.dart';
import 'package:app_viajes/home/presentation/screens/get_travels_screen.dart';
import 'package:app_viajes/home/presentation/screens/recomendations_screen.dart';
import 'package:app_viajes/home/presentation/screens/register.dart';
import 'package:app_viajes/home/presentation/screens/traductor_screen.dart';
import 'package:app_viajes/home/presentation/screens/ver_actividad_screen.dart';
import 'package:app_viajes/models/step.dart';
import 'package:app_viajes/models/travel_response.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_viajes/home/presentation/screens/home_screen.dart';
import 'package:app_viajes/home/presentation/screens/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'login',
      path: '/',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      name: RegisterScreen.name,
      path: '/registro',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      name: SettingsScreen.name,
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
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
      path: '/nuevoViaje',
      builder: (context, state) {
        final isViewMode =
            state.extra != null && (state.extra as Map)['isViewMode'] == true;

        final isEditMode =
            state.extra != null && (state.extra as Map)['isEditMode'] == true;

        return ABMViajeScreen(isViewMode: isViewMode, isEditMode: isEditMode);
      },
    ),
    GoRoute(
      name: 'traductor',
      path: '/traductor',
      builder: (context, state) => TranslationScreen(),
    ),
    GoRoute(
      name: 'verViajesYaHechos',
      path: '/verViajesYaHechos',
      builder: (context, state) => GetAnotherTravelsScreen(),
    ),
    GoRoute(
      name: 'recommendations',
      path: '/verRecomendaciones/:id',
      builder: (context, state) {
        final travelId = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        return RecommendationsScreen(travelId: travelId);
      },
    ),

    GoRoute(
      name: 'verActividad',
      path: '/verActividad',
      builder:
          (context, state) => VerActividadScreen(
            activity: Steps(
              id: 1,

              startDate: DateTime.now(),
              endDate: DateTime.now(),
              location: "",
              name: "",
              cost: "",
              recommendations: "",
            ),
          ),
    ),
    GoRoute(
      path: '/activities',
      builder: (BuildContext context, GoRouterState state) {
        final travel = state.extra as CreateTravelResponse;
        return ActivitiesScreen(travel: travel);
      },
    ),
  ],
);
