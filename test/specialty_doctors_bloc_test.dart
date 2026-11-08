import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/core/data/models/meta/meta_api_model.dart';
import 'package:app_health/features/core/data/models/meta/paging_send_model.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_list_send_model.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_lists_api_model_successful_response.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';
import 'package:app_health/features/doctor_list/data/models/specialty_doctors_response_model.dart';
import 'package:app_health/features/doctor_list/domain/repositories/base_doctor_list_repository.dart';
import 'package:app_health/features/doctor_list/domain/usecases/get_doctor_list_use_case.dart';
import 'package:app_health/features/doctor_list/presentation/bloc/doctor_list_bloc.dart';
import 'package:app_health/features/doctor_list/presentation/bloc/doctor_list_event.dart';
import 'package:app_health/features/doctor_list/presentation/bloc/doctor_list_state.dart';

class FakeDoctorListRepository implements BaseDoctorListRepository {
  bool shouldFail = false;
  List<DoctorModel> doctors = [];
  int totalCountOverride = 0;
  DoctorListSendModel? lastSendModel;

  @override
  Future<InsuranceCompaniesResponseModel> getInsuranceCompaniesApi() async {
    return const InsuranceCompaniesResponseModel(
      success: true,
      code: 'OK',
      message: 'OK',
      data: [],
    );
  }

  @override
  Future<GovernoratesResponseModel> getGovernoratesApi() async {
    return const GovernoratesResponseModel(
      success: true,
      code: 'OK',
      message: 'OK',
      data: [],
    );
  }

  @override
  Future<DoctorListsApiModelSuccessfulResponse> getDoctorListsApi(
    DoctorListSendModel sendModel,
  ) async {
    lastSendModel = sendModel;
    if (shouldFail) {
      throw ErrorApiModel(
        isMessageLocalizationKey: false,
        message: 'Network error occurred',
        code: 500,
      );
    }
    final int totalCount = totalCountOverride > 0
        ? totalCountOverride
        : doctors.length;
    final int pageSize = sendModel.pagination.pageSize;
    final int totalPages = pageSize > 0 ? (totalCount / pageSize).ceil() : 0;

    return DoctorListsApiModelSuccessfulResponse(
      doctors,
      MetaApiModel(
        currentPage: sendModel.pagination.pageNumber,
        totalPages: totalPages,
        total: totalCount,
      ),
    );
  }
}

void main() {
  late FakeDoctorListRepository fakeRepository;
  late GetDoctorListsUseCase useCase;
  late DoctorListsBloc bloc;

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
    fakeRepository = FakeDoctorListRepository();
    fakeRepository.doctors = List.from(sampleDoctors);
    useCase = GetDoctorListsUseCase(fakeRepository);
    bloc = DoctorListsBloc(getDoctorListsUseCase: useCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('DoctorListsBloc Tests (booking_list structure)', () {
    test('initial state is DoctorListsInitial', () {
      expect(bloc.state, isA<DoctorListsInitial>());
    });

    test('emits [Loading, Loaded] when fetching first page succeeds', () async {
      final sendModel = DoctorListSendModel(
        specialtyId: 'spec-1',
        pagination: PagingListSendModel(pageNumber: 1, pageSize: 20),
      );

      final expectedStates = [
        isA<DoctorListListLoadingState>(),
        predicate<DoctorListsState>((state) {
          if (state is DoctorListsLoadedState) {
            return state.doctorList.length == 3 &&
                state.metaUiModel.currentPage == 1;
          }
          return false;
        }),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));
      bloc.add(GetDoctorListsApiEvent(sendModel: sendModel));
    });

    test(
      'emits [PagingLoading, Loaded] when fetching subsequent page',
      () async {
        final sendModel = DoctorListSendModel(
          specialtyId: 'spec-1',
          pagination: PagingListSendModel(pageNumber: 2, pageSize: 20),
        );

        final expectedStates = [
          isA<DoctorListLoadingAsPagingState>(),
          predicate<DoctorListsState>((state) {
            if (state is DoctorListsLoadedState) {
              return state.metaUiModel.currentPage == 2;
            }
            return false;
          }),
        ];

        expectLater(bloc.stream, emitsInOrder(expectedStates));
        bloc.add(GetDoctorListsApiEvent(sendModel: sendModel));
      },
    );

    test('emits [Loading, Error] when fetching doctors fails', () async {
      fakeRepository.shouldFail = true;

      final sendModel = DoctorListSendModel(
        specialtyId: 'spec-1',
        pagination: PagingListSendModel(pageNumber: 1, pageSize: 20),
      );

      final expectedStates = [
        isA<DoctorListListLoadingState>(),
        predicate<DoctorListsState>((state) {
          if (state is DoctorListErrorState) {
            return state.errorMassage == 'Network error occurred';
          }
          return false;
        }),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));
      bloc.add(GetDoctorListsApiEvent(sendModel: sendModel));
    });

    test('toggles favorite doctor correctly', () async {
      final sendModel = DoctorListSendModel(
        specialtyId: 'spec-1',
        pagination: PagingListSendModel(pageNumber: 1, pageSize: 20),
      );
      bloc.add(GetDoctorListsApiEvent(sendModel: sendModel));

      await expectLater(
        bloc.stream,
        emitsThrough(isA<DoctorListsLoadedState>()),
      );

      bloc.add(ToggleFavoriteDoctorEvent('1'));
      await expectLater(
        bloc.stream,
        emits(
          predicate<DoctorListsLoadedState>((state) {
            return state.favoriteDoctorIds.contains('1');
          }),
        ),
      );

      bloc.add(ToggleFavoriteDoctorEvent('1'));
      await expectLater(
        bloc.stream,
        emits(
          predicate<DoctorListsLoadedState>((state) {
            return !state.favoriteDoctorIds.contains('1');
          }),
        ),
      );
    });

    test('emits NoMoreDataToLoadState on NoMoreDataToLoadEvent', () async {
      expectLater(bloc.stream, emits(isA<NoMoreDataToLoadState>()));
      bloc.add(NoMoreDataToLoadEvent());
    });
  });
}
