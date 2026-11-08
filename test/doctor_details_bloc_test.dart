import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_profile_response_model.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_reviews_response_model.dart';
import 'package:app_health/features/doctor_details/domain/repositories/base_doctor_details_repository.dart';
import 'package:app_health/features/doctor_details/domain/usecases/get_doctor_profile_use_case.dart';
import 'package:app_health/features/doctor_details/domain/usecases/get_doctor_reviews_use_case.dart';
import 'package:app_health/features/doctor_details/presentation/bloc/doctor_details_bloc.dart';
import 'package:app_health/features/doctor_details/presentation/bloc/doctor_details_event.dart';
import 'package:app_health/features/doctor_details/presentation/bloc/doctor_details_state.dart';

class FakeDoctorDetailsRepository implements BaseDoctorDetailsRepository {
  bool shouldFailProfile = false;
  bool shouldFailReviews = false;

  late DoctorProfileModel profileModel;
  late DoctorReviewsDataModel reviewsModel;

  @override
  Future<DoctorProfileResponseModel> getDoctorProfileApi(
    String doctorId,
  ) async {
    if (shouldFailProfile) {
      throw ErrorApiModel(
        isMessageLocalizationKey: false,
        message: 'Failed to load profile',
        code: 500,
      );
    }
    return DoctorProfileResponseModel(
      success: true,
      code: 'DOCTOR_PROFILE_RETRIEVED',
      message: 'Success',
      data: profileModel,
    );
  }

  @override
  Future<DoctorReviewsResponseModel> getDoctorReviewsApi(
    String doctorId,
  ) async {
    if (shouldFailReviews) {
      throw ErrorApiModel(
        isMessageLocalizationKey: false,
        message: 'Failed to load reviews',
        code: 500,
      );
    }
    return DoctorReviewsResponseModel(
      success: true,
      code: 'DOCTOR_REVIEWS_RETRIEVED',
      message: 'Success',
      data: reviewsModel,
    );
  }
}

void main() {
  late FakeDoctorDetailsRepository fakeRepo;
  late GetDoctorProfileUseCase profileUseCase;
  late GetDoctorReviewsUseCase reviewsUseCase;
  late DoctorDetailsBloc bloc;

  final sampleDoctor = DoctorProfileModel(
    id: 'doc-1',
    specialtyId: 'spec-1',
    name: 'د. عمر أحمد',
    specializationTitle: 'استشاري الباطنة',
    ratingAverage: 4.9,
    totalReviews: 10,
    clinicName: 'المركز الطبي التخصصي',
    clinicAddress: 'شارع الطيران',
    cityLocation: 'مدينة نصر، القاهرة',
    aboutText: 'استشاري الباطنة',
    qualifications: const ['دكتوراه أمراض الباطنة'],
    workingHours: 'من 3 إلى 9 مساءً',
    isFavorite: false,
  );

  final sampleReviews = DoctorReviewsDataModel(
    ratingAverage: 4.9,
    totalReviews: 1,
    items: const [
      DoctorReviewModel(
        id: 'rev-1',
        patientName: 'أحمد م.',
        rating: 5,
        comment: 'ممتاز',
        createdAt: '2026-10-24T12:00:00Z',
      ),
    ],
  );

  setUp(() {
    fakeRepo = FakeDoctorDetailsRepository()
      ..profileModel = sampleDoctor
      ..reviewsModel = sampleReviews;
    profileUseCase = GetDoctorProfileUseCase(fakeRepo);
    reviewsUseCase = GetDoctorReviewsUseCase(fakeRepo);
    bloc = DoctorDetailsBloc(
      getDoctorProfileUseCase: profileUseCase,
      getDoctorReviewsUseCase: reviewsUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('DoctorDetailsBloc Tests', () {
    test('initial state is DoctorDetailsInitial', () {
      expect(bloc.state, isA<DoctorDetailsInitial>());
    });

    test('FetchDoctorDetailsEvent emits [Loading, Loaded] when profile succeeds',
        () async {
      final expectedStates = [
        isA<DoctorDetailsLoadingState>(),
        predicate<DoctorDetailsState>((state) {
          if (state is DoctorDetailsLoadedState) {
            return state.doctor.name == 'د. عمر أحمد' &&
                state.reviewsLoading == true;
          }
          return false;
        }),
        predicate<DoctorDetailsState>((state) {
          if (state is DoctorDetailsLoadedState) {
            return state.doctor.name == 'د. عمر أحمد' &&
                state.reviews != null &&
                state.reviewsLoading == false;
          }
          return false;
        }),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const FetchDoctorDetailsEvent(doctorId: 'doc-1'));
    });

    test('FetchDoctorDetailsEvent emits [Loading, Error] when profile fails',
        () async {
      fakeRepo.shouldFailProfile = true;

      final expectedStates = [
        isA<DoctorDetailsLoadingState>(),
        predicate<DoctorDetailsState>((state) {
          if (state is DoctorDetailsErrorState) {
            return state.errorMessage == 'Failed to load profile';
          }
          return false;
        }),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const FetchDoctorDetailsEvent(doctorId: 'doc-1'));
    });

    test('ChangeDoctorDetailsTabEvent switches tab in loaded state', () async {
      bloc.add(const FetchDoctorDetailsEvent(doctorId: 'doc-1'));
      await Future.delayed(const Duration(milliseconds: 50));

      bloc.add(const ChangeDoctorDetailsTabEvent(tabIndex: 1));
      await Future.delayed(const Duration(milliseconds: 50));

      expect(bloc.state, isA<DoctorDetailsLoadedState>());
      expect((bloc.state as DoctorDetailsLoadedState).activeTab, 1);
    });

    test('ToggleDoctorFavoriteEvent toggles favorite status in loaded state',
        () async {
      bloc.add(const FetchDoctorDetailsEvent(doctorId: 'doc-1'));
      await Future.delayed(const Duration(milliseconds: 50));

      expect((bloc.state as DoctorDetailsLoadedState).isFavorite, isFalse);

      bloc.add(const ToggleDoctorFavoriteEvent());
      await Future.delayed(const Duration(milliseconds: 50));

      expect((bloc.state as DoctorDetailsLoadedState).isFavorite, isTrue);
    });
  });
}

