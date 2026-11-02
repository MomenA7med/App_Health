import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_filter_model.dart';
import 'package:app_health/features/doctor_list/data/models/specialty_doctors_response_model.dart';
import 'package:app_health/features/doctor_list/domain/repositories/base_doctor_list_repository.dart';
import 'package:app_health/features/doctor_list/domain/usecases/get_specialty_doctors_usecase.dart';
import 'package:app_health/features/doctor_list/presentation/bloc/doctor_list_bloc.dart';
import 'package:app_health/features/doctor_list/presentation/bloc/doctor_list_event.dart';
import 'package:app_health/features/doctor_list/presentation/bloc/doctor_list_state.dart';

class FakeSpecialtyDoctorsRepository
    implements BaseDoctorListRepository {
  bool shouldFail = false;
  List<DoctorModel> doctors = [];

  @override
  Future<SpecialtyDoctorsResponseModel> getSpecialtyDoctors({
    required String specialtyId,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (shouldFail) {
      throw ErrorApiModel(
        isMessageLocalizationKey: false,
        message: 'Network error occurred',
        code: 500,
      );
    }
    return SpecialtyDoctorsResponseModel(
      success: true,
      code: 'DOCTORS_RETRIEVED',
      message: 'Success',
      data: SpecialtyDoctorsDataModel(
        items: doctors,
        page: 1,
        pageSize: 20,
        totalCount: doctors.length,
      ),
    );
  }
}

void main() {
  late FakeSpecialtyDoctorsRepository fakeRepository;
  late GetSpecialtyDoctorsUseCase useCase;
  late DoctorListBloc bloc;

  final sampleDoctors = [
    DoctorModel(
      id: '1',
      name: 'د. عمر أحمد',
      gender: 'Male',
      specializationTitle: 'استشاري الباطنة',
      ratingAverage: 4.9,
      totalReviews: 10,
      clinicName: 'المركز الطبي التخصصي',
      clinicAddress: 'شارع الطيران',
      cityLocation: 'مدينة نصر، القاهرة',
      area: 'مدينة نصر',
      distanceKm: 1.2,
      consultationFee: 350,
      nextAvailableSlot: 'اليوم، ٣:٣٠ مساءً',
      nextAvailableDate: '2026-11-01',
    ),
    DoctorModel(
      id: '2',
      name: 'د. سارة محمود',
      gender: 'Female',
      specializationTitle: 'أخصائي الباطنة',
      ratingAverage: 4.6,
      totalReviews: 5,
      clinicName: 'عيادة النيل',
      clinicAddress: 'شارع عباس العقاد',
      cityLocation: 'مدينة نصر، القاهرة',
      area: 'مدينة نصر',
      distanceKm: 2.4,
      consultationFee: 280,
      nextAvailableSlot: 'غداً، ١٠:٠٠ صباحاً',
      nextAvailableDate: '2026-11-02',
    ),
    DoctorModel(
      id: '3',
      name: 'د. خالد حسن',
      gender: 'Male',
      specializationTitle: 'استشاري الجهاز الهضمي',
      ratingAverage: 4.8,
      totalReviews: 15,
      clinicName: 'مستشفى السلام',
      clinicAddress: 'كورنيش النيل',
      cityLocation: 'المعادي، القاهرة',
      area: 'المعادي',
      distanceKm: 6.5,
      consultationFee: 450,
      nextAvailableSlot: 'اليوم، ٦:٠٠ مساءً',
      nextAvailableDate: '2026-11-01',
    ),
  ];

  setUp(() {
    fakeRepository = FakeSpecialtyDoctorsRepository();
    fakeRepository.doctors = List.from(sampleDoctors);
    useCase = GetSpecialtyDoctorsUseCase(fakeRepository);
    bloc = DoctorListBloc(getSpecialtyDoctorsUseCase: useCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('DoctorListBloc Tests', () {
    test('initial state is DoctorListInitialState', () {
      expect(bloc.state, const DoctorListInitialState());
    });

    test('emits [Loading, Loaded] when fetching doctors succeeds', () async {
      final expectedStates = [
        const DoctorListLoadingState(),
        predicate<DoctorListState>((state) {
          if (state is DoctorListLoadedState) {
            return state.allDoctors.length == 3 &&
                state.displayedDoctors.length == 3 &&
                state.sortOption == DoctorSortOption.nearest;
          }
          return false;
        }),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));
      bloc.add(const FetchSpecialtyDoctorsEvent(specialtyId: 'spec-1'));
    });

    test('emits [Loading, Error] when fetching doctors fails', () async {
      fakeRepository.shouldFail = true;

      final expectedStates = [
        const DoctorListLoadingState(),
        predicate<DoctorListState>((state) {
          if (state is DoctorListErrorState) {
            return state.errorMessage == 'Network error occurred';
          }
          return false;
        }),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));
      bloc.add(const FetchSpecialtyDoctorsEvent(specialtyId: 'spec-1'));
    });

    test('filters doctors correctly by search query', () async {
      bloc.add(const FetchSpecialtyDoctorsEvent(specialtyId: 'spec-1'));
      await expectLater(
        bloc.stream,
        emitsThrough(isA<DoctorListLoadedState>()),
      );

      bloc.add(const SearchDoctorsEvent('سارة'));
      await expectLater(
        bloc.stream,
        emits(
          predicate<DoctorListLoadedState>((state) {
            return state.displayedDoctors.length == 1 &&
                state.displayedDoctors.first.name == 'د. سارة محمود';
          }),
        ),
      );
    });

    test('filters doctors correctly by gender', () async {
      bloc.add(const FetchSpecialtyDoctorsEvent(specialtyId: 'spec-1'));
      await expectLater(
        bloc.stream,
        emitsThrough(isA<DoctorListLoadedState>()),
      );

      bloc.add(
        const ApplyFilterEvent(
          DoctorFilterModel(gender: 'female'),
        ),
      );

      await expectLater(
        bloc.stream,
        emits(
          predicate<DoctorListLoadedState>((state) {
            return state.displayedDoctors.length == 1 &&
                state.displayedDoctors.first.gender == 'Female';
          }),
        ),
      );
    });

    test('filters doctors correctly by price range', () async {
      bloc.add(const FetchSpecialtyDoctorsEvent(specialtyId: 'spec-1'));
      await expectLater(
        bloc.stream,
        emitsThrough(isA<DoctorListLoadedState>()),
      );

      bloc.add(
        const ApplyFilterEvent(
          DoctorFilterModel(minPrice: 300, maxPrice: 400),
        ),
      );

      await expectLater(
        bloc.stream,
        emits(
          predicate<DoctorListLoadedState>((state) {
            return state.displayedDoctors.length == 1 &&
                state.displayedDoctors.first.consultationFee == 350;
          }),
        ),
      );
    });

    test('filters doctors correctly by date (today)', () async {
      bloc.add(const FetchSpecialtyDoctorsEvent(specialtyId: 'spec-1'));
      await expectLater(
        bloc.stream,
        emitsThrough(isA<DoctorListLoadedState>()),
      );

      bloc.add(
        const ApplyFilterEvent(
          DoctorFilterModel(consultationDate: 'today'),
        ),
      );

      await expectLater(
        bloc.stream,
        emits(
          predicate<DoctorListLoadedState>((state) {
            return state.displayedDoctors.length == 2;
          }),
        ),
      );
    });

    test('sorts doctors correctly by price low to high and high to low', () async {
      bloc.add(const FetchSpecialtyDoctorsEvent(specialtyId: 'spec-1'));
      await expectLater(
        bloc.stream,
        emitsThrough(isA<DoctorListLoadedState>()),
      );

      bloc.add(const ChangeSortOptionEvent(DoctorSortOption.priceLowToHigh));
      await expectLater(
        bloc.stream,
        emits(
          predicate<DoctorListLoadedState>((state) {
            return state.displayedDoctors.first.consultationFee == 280 &&
                state.displayedDoctors.last.consultationFee == 450;
          }),
        ),
      );

      bloc.add(const ChangeSortOptionEvent(DoctorSortOption.priceHighToLow));
      await expectLater(
        bloc.stream,
        emits(
          predicate<DoctorListLoadedState>((state) {
            return state.displayedDoctors.first.consultationFee == 450 &&
                state.displayedDoctors.last.consultationFee == 280;
          }),
        ),
      );
    });

    test('sorts doctors correctly by highest rated', () async {
      bloc.add(const FetchSpecialtyDoctorsEvent(specialtyId: 'spec-1'));
      await expectLater(
        bloc.stream,
        emitsThrough(isA<DoctorListLoadedState>()),
      );

      bloc.add(const ChangeSortOptionEvent(DoctorSortOption.highestRated));
      await expectLater(
        bloc.stream,
        emits(
          predicate<DoctorListLoadedState>((state) {
            return state.displayedDoctors.first.ratingAverage == 4.9;
          }),
        ),
      );
    });

    test('toggles favorite doctor id properly', () async {
      bloc.add(const FetchSpecialtyDoctorsEvent(specialtyId: 'spec-1'));
      await expectLater(
        bloc.stream,
        emitsThrough(isA<DoctorListLoadedState>()),
      );

      bloc.add(const ToggleFavoriteDoctorEvent('1'));
      await expectLater(
        bloc.stream,
        emits(
          predicate<DoctorListLoadedState>((state) {
            return state.favoriteDoctorIds.contains('1');
          }),
        ),
      );

      bloc.add(const ToggleFavoriteDoctorEvent('1'));
      await expectLater(
        bloc.stream,
        emits(
          predicate<DoctorListLoadedState>((state) {
            return !state.favoriteDoctorIds.contains('1');
          }),
        ),
      );
    });

    test('resets filter back to initial', () async {
      bloc.add(const FetchSpecialtyDoctorsEvent(specialtyId: 'spec-1'));
      await expectLater(
        bloc.stream,
        emitsThrough(isA<DoctorListLoadedState>()),
      );

      bloc.add(const ApplyFilterEvent(DoctorFilterModel(gender: 'female')));
      await expectLater(
        bloc.stream,
        emits(
          predicate<DoctorListLoadedState>((state) {
            return state.displayedDoctors.length == 1;
          }),
        ),
      );

      bloc.add(const ResetFilterEvent());
      await expectLater(
        bloc.stream,
        emits(
          predicate<DoctorListLoadedState>((state) {
            return state.displayedDoctors.length == 3 &&
                state.filter == DoctorFilterModel.initial;
          }),
        ),
      );
    });
  });
}

