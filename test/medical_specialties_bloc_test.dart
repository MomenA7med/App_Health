import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/medical_specialties/data/models/medical_specialties_response_model.dart';
import 'package:app_health/features/medical_specialties/domain/repositories/base_medical_specialties_repository.dart';
import 'package:app_health/features/medical_specialties/domain/usecases/get_medical_specialties_usecase.dart';
import 'package:app_health/features/medical_specialties/presentation/bloc/medical_specialties_bloc.dart';

class FakeMedicalSpecialtiesRepository
    implements BaseMedicalSpecialtiesRepository {
  bool shouldFail = false;
  List<MedicalSpecialtyModel> specialties = [];

  @override
  Future<MedicalSpecialtiesResponseModel> getMedicalSpecialties() async {
    if (shouldFail) {
      throw ErrorApiModel(
        isMessageLocalizationKey: false,
        message: 'Network Error',
        code: 500,
      );
    }
    return MedicalSpecialtiesResponseModel(
      success: true,
      code: 'MEDICAL_SPECIALTIES_RETRIEVED',
      message: 'Success',
      data: specialties,
    );
  }
}

void main() {
  late FakeMedicalSpecialtiesRepository fakeRepository;
  late GetMedicalSpecialtiesUseCase useCase;
  late MedicalSpecialtiesBloc bloc;

  final sampleList = [
    MedicalSpecialtyModel(
      id: '2',
      nameAr: 'الباطنة',
      nameEn: 'Internal Medicine',
      descriptionAr: 'تشخيص أمراض الباطنة',
      descriptionEn: 'Diagnosis of internal diseases',
      imageUrl: '',
      displayOrder: 2,
    ),
    MedicalSpecialtyModel(
      id: '1',
      nameAr: 'الأسنان',
      nameEn: 'Dentistry',
      descriptionAr: 'علاج الأسنان',
      descriptionEn: 'Dentistry care',
      imageUrl: '',
      displayOrder: 1,
    ),
  ];

  setUp(() {
    fakeRepository = FakeMedicalSpecialtiesRepository();
    useCase = GetMedicalSpecialtiesUseCase(fakeRepository);
    bloc = MedicalSpecialtiesBloc(getMedicalSpecialtiesUseCase: useCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('MedicalSpecialtiesBloc Tests', () {
    test('initial state is MedicalSpecialtiesInitialState', () {
      expect(bloc.state, equals(const MedicalSpecialtiesInitialState()));
    });

    test(
      'emits [Loading, Loaded] sorted by displayOrder on FetchMedicalSpecialtiesEvent success',
      () async {
        fakeRepository.specialties = sampleList;

        final expectedStates = [
          const MedicalSpecialtiesLoadingState(),
          MedicalSpecialtiesLoadedState(
            allSpecialties: [sampleList[1], sampleList[0]],
            filteredSpecialties: [sampleList[1], sampleList[0]],
            query: '',
          ),
        ];

        expectLater(bloc.stream, emitsInOrder(expectedStates));
        bloc.add(const FetchMedicalSpecialtiesEvent());
      },
    );

    test(
      'emits [Loading, Error] on FetchMedicalSpecialtiesEvent failure',
      () async {
        fakeRepository.shouldFail = true;

        final expectedStates = [
          const MedicalSpecialtiesLoadingState(),
          const MedicalSpecialtiesErrorState(
            errorMessage: 'Network Error',
            isLocalizationKey: false,
          ),
        ];

        expectLater(bloc.stream, emitsInOrder(expectedStates));
        bloc.add(const FetchMedicalSpecialtiesEvent());
      },
    );

    test('filters list accurately when SearchSpecialtiesEvent is dispatched', () async {
      fakeRepository.specialties = sampleList;
      bloc.add(const FetchMedicalSpecialtiesEvent());
      await Future.delayed(const Duration(milliseconds: 50));

      bloc.add(const SearchSpecialtiesEvent('dent'));
      await Future.delayed(const Duration(milliseconds: 50));

      final state = bloc.state as MedicalSpecialtiesLoadedState;
      expect(state.filteredSpecialties.length, 1);
      expect(state.filteredSpecialties.first.nameEn, 'Dentistry');

      // Search in Arabic
      bloc.add(const SearchSpecialtiesEvent('الباطنة'));
      await Future.delayed(const Duration(milliseconds: 50));

      final stateAr = bloc.state as MedicalSpecialtiesLoadedState;
      expect(stateAr.filteredSpecialties.length, 1);
      expect(stateAr.filteredSpecialties.first.nameAr, 'الباطنة');

      // Clear search
      bloc.add(const SearchSpecialtiesEvent(''));
      await Future.delayed(const Duration(milliseconds: 50));

      final stateEmpty = bloc.state as MedicalSpecialtiesLoadedState;
      expect(stateEmpty.filteredSpecialties.length, 2);
    });
  });
}
