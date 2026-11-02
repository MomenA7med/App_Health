import 'package:app_health/features/doctor_list/presentation/screens/doctor_list_screen.dart';
import 'package:app_health/features/login/presentation/screen/login_screen.dart';
import 'package:app_health/features/medical_specialties/presentation/screen/medical_specialties_screen.dart';
import 'package:app_health/features/register/presentation/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_health/features/splash/splash_screen.dart';
import 'package:app_health/flavor_config/app_config_utils.dart';

class AppRouter {
  /// main Navigation Router
  static final GlobalKey<NavigatorState> mainNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter router = GoRouter(
    debugLogDiagnostics: AppConfigUtils.showRoutingLog,
    navigatorKey: mainNavigatorKey,
    initialLocation: SplashScreen.routeName,
    routes: <RouteBase>[
      GoRoute(
        path: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: LoginScreen.routeName,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: RegisterScreen.routeName,
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: MedicalSpecialtiesScreen.routeName,
        builder: (context, state) => const MedicalSpecialtiesScreen(),
      ),
      GoRoute(
        path: DoctorListScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final specialtyId = extra['specialtyId'] as String? ?? '';
          final specialtyTitle = extra['specialtyTitle'] as String? ?? '';
          return DoctorListScreen(
            specialtyId: specialtyId,
            specialtyTitle: specialtyTitle,
          );
        },
      ),
    ],
  );
}
