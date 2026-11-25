import 'package:app_health/features/addresses/presentation/screens/add_address_screen.dart';
import 'package:app_health/features/doctor_details/presentation/screens/doctor_details_screen.dart';
import 'package:app_health/features/doctor_list/presentation/screens/doctor_list_screen.dart';
import 'package:app_health/features/home/presentation/screens/home_screen.dart';
import 'package:app_health/features/hospital_details/presentation/screens/hospital_details_screen.dart';
import 'package:app_health/features/hospital_list/presentation/screens/hospital_list_screen.dart';
import 'package:app_health/features/login/presentation/screen/login_screen.dart';
import 'package:app_health/features/medical_specialties/presentation/screen/emergency_specialties_screen.dart';
import 'package:app_health/features/medical_specialties/presentation/screen/medical_specialties_screen.dart';
import 'package:app_health/features/pharmacies_list/presentation/screens/pharmacies_list_screen.dart';
import 'package:app_health/features/pharmacy_details/presentation/screens/pharmacy_details_screen.dart';
import 'package:app_health/features/send_prescription/data/models/send_prescription_response_model.dart';
import 'package:app_health/features/send_prescription/presentation/screens/capture_prescription_screen.dart';
import 'package:app_health/features/send_prescription/presentation/screens/prescription_sent_screen.dart';
import 'package:app_health/features/send_prescription/presentation/screens/review_prescription_screen.dart';
import 'package:app_health/features/send_prescription/presentation/screens/send_prescription_screen.dart';
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
        path: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: MedicalSpecialtiesScreen.routeName,
        builder: (context, state) => const MedicalSpecialtiesScreen(),
      ),
      GoRoute(
        path: EmergencySpecialtiesScreen.routeName,
        builder: (context, state) => const EmergencySpecialtiesScreen(),
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
      GoRoute(
        path: DoctorDetailsScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final doctorId = extra['doctorId'] as String? ?? '';
          final consultationFee = extra['consultationFee'] as double?;
          return DoctorDetailsScreen(
            doctorId: doctorId,
            consultationFee: consultationFee,
          );
        },
      ),
      GoRoute(
        path: AddAddressScreen.routeName,
        builder: (context, state) => const AddAddressScreenWithBloc(),
      ),
      GoRoute(
        path: HospitalListScreen.routeName,
        builder: (context, state) => const HospitalListScreen(),
      ),
      GoRoute(
        path: HospitalDetailsScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final hospitalId = extra['hospitalId'] as String? ?? '';
          return HospitalDetailsScreen(
            hospitalId: hospitalId,
          );
        },
      ),
      GoRoute(
        path: PharmaciesListScreen.routeName,
        builder: (context, state) => const PharmaciesListScreen(),
      ),
      GoRoute(
        path: PharmacyDetailsScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final pharmacyId = extra['pharmacyId'] as String? ?? '';
          return PharmacyDetailsScreen(
            pharmacyId: pharmacyId,
          );
        },
      ),
      GoRoute(
        path: CapturePrescriptionScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final pharmacyId = extra['preselectedPharmacyId'] as String?;
          final existingImagePaths =
              (extra['existingImagePaths'] as List<dynamic>?)?.cast<String>();
          final isAddingPhoto = extra['isAddingPhoto'] as bool? ?? false;
          return CapturePrescriptionScreen(
            preselectedPharmacyId: pharmacyId,
            existingImagePaths: existingImagePaths,
            isAddingPhoto: isAddingPhoto,
          );
        },
      ),
      GoRoute(
        path: ReviewPrescriptionScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final imagePath = extra['imagePath'] as String? ?? '';
          final imagePaths =
              (extra['imagePaths'] as List<dynamic>?)?.cast<String>();
          final pharmacyId = extra['preselectedPharmacyId'] as String?;
          return ReviewPrescriptionScreen(
            imagePath: imagePath,
            imagePaths: imagePaths,
            preselectedPharmacyId: pharmacyId,
          );
        },
      ),
      GoRoute(
        path: SendPrescriptionScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final imagePath = extra['imagePath'] as String?;
          final imagePaths =
              (extra['imagePaths'] as List<dynamic>?)?.cast<String>();
          final isWithoutPrescription =
              extra['isWithoutPrescription'] as bool? ?? false;
          final pharmacyId = extra['preselectedPharmacyId'] as String?;
          return SendPrescriptionScreen(
            imagePath: imagePath,
            imagePaths: imagePaths,
            isWithoutPrescription: isWithoutPrescription,
            preselectedPharmacyId: pharmacyId,
          );
        },
      ),
      GoRoute(
        path: PrescriptionSentScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final order = extra['order'] as PrescriptionOrderModel;
          return PrescriptionSentScreen(order: order);
        },
      ),
    ],
  );
}
