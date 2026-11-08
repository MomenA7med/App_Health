import 'package:app_health/features/core/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/addresses/data/datasources/addresses_api_manager.dart';
import 'package:app_health/features/addresses/data/models/create_address_send_model.dart';
import 'package:app_health/features/addresses/data/repositories/addresses_repository.dart';
import 'package:app_health/features/addresses/domain/usecases/create_user_address_use_case.dart';
import 'package:app_health/features/addresses/domain/usecases/get_address_governorates_use_case.dart';
import 'package:app_health/features/addresses/domain/usecases/get_user_addresses_use_case.dart';
import 'package:app_health/features/addresses/presentation/bloc/addresses_bloc.dart';
import 'package:app_health/features/addresses/presentation/bloc/addresses_event.dart';
import 'package:app_health/features/addresses/presentation/bloc/addresses_state.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class AddAddressScreen extends StatefulWidget {
  static const String routeName = '/add-address';

  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailedAddressController =
      TextEditingController();

  GovernorateModel? _selectedGovernorate;
  AreaModel? _selectedArea;

  @override
  void initState() {
    super.initState();
    // Ensure governorates are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AddressesBloc>().add(
          const FetchGovernoratesForAddressEvent(),
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailedAddressController.dispose();
    super.dispose();
  }

  void _onSaveAddress() {
    final name = _nameController.text.trim();
    final detailed = _detailedAddressController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.translate(LocalizationKeys.pleaseEnterAddressName),
          ),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    if (_selectedGovernorate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.translate(LocalizationKeys.pleaseChooseGovernorate),
          ),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    if (_selectedArea == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate(LocalizationKeys.pleaseChooseArea)),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    if (detailed.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.translate(LocalizationKeys.pleaseEnterDetailedAddress),
          ),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    final sendModel = CreateAddressSendModel(
      addressName: name,
      governorate: _selectedGovernorate!.id,
      area: _selectedArea!.id,
      detailedAddress: detailed,
      isCurrentLocation: true,
    );

    context.read<AddressesBloc>().add(CreateUserAddressEvent(sendModel));
  }

  Widget _buildFieldBox({required String label, required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderSubtle, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.labelSubtitle,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 4.h),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressesBloc, AddressesState>(
      listener: (context, state) {
        if (state is AddressesLoadedState) {
          if (state.newlyCreatedAddress != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  context.translate(LocalizationKeys.addressSavedSuccessfully),
                ),
                backgroundColor: AppColors.colorPrimary,
              ),
            );
            Navigator.of(context).pop(state.newlyCreatedAddress);
          } else if (state.createError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.translate(state.createError!)),
                backgroundColor: AppColors.errorRed,
              ),
            );
          }
        }
      },
      builder: (context, state) {
        List<GovernorateModel> governorates = [];
        bool isCreating = false;

        if (state is AddressesLoadedState) {
          governorates = state.governorates;
          isCreating = state.isCreating;
        }

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppBar(
            screenTitle: context.translate(LocalizationKeys.addNewAddress),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12.h),

                          // Helper Text
                          Text(
                            context.translate(
                              LocalizationKeys.addAddressHelper,
                            ),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textBody,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Field 1: Address Name
                          _buildFieldBox(
                            label: context.translate(
                              LocalizationKeys.addressName,
                            ),
                            child: TextField(
                              controller: _nameController,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.buttonBlackTextColor,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                hintText: context.translate(
                                  LocalizationKeys.addressNameHint,
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),

                          // Field 2: Governorate Dropdown
                          _buildFieldBox(
                            label: context.translate(
                              LocalizationKeys.governorate,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<GovernorateModel>(
                                isDense: true,
                                isExpanded: true,
                                value: _selectedGovernorate,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.textMuted,
                                ),
                                hint: Text(
                                  context.translate(
                                    LocalizationKeys.chooseGovernorate,
                                  ),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                items: governorates.map((gov) {
                                  return DropdownMenuItem<GovernorateModel>(
                                    value: gov,
                                    child: Text(
                                      gov.name,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.buttonBlackTextColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGovernorate = value;
                                    _selectedArea = null;
                                  });
                                },
                              ),
                            ),
                          ),

                          // Field 3: Area Dropdown
                          _buildFieldBox(
                            label: context.translate(LocalizationKeys.area),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<AreaModel>(
                                isDense: true,
                                isExpanded: true,
                                value: _selectedArea,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.textMuted,
                                ),
                                hint: Text(
                                  context.translate(
                                    LocalizationKeys.chooseArea,
                                  ),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                items: (_selectedGovernorate?.areas ?? []).map((
                                  area,
                                ) {
                                  return DropdownMenuItem<AreaModel>(
                                    value: area,
                                    child: Text(
                                      area.name,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.buttonBlackTextColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: _selectedGovernorate == null
                                    ? null
                                    : (value) {
                                        setState(() {
                                          _selectedArea = value;
                                        });
                                      },
                              ),
                            ),
                          ),

                          // Field 4: Detailed Address
                          _buildFieldBox(
                            label: context.translate(
                              LocalizationKeys.detailedAddress,
                            ),
                            child: TextField(
                              controller: _detailedAddressController,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.buttonBlackTextColor,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                hintText: context.translate(
                                  LocalizationKeys.detailedAddressHint,
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),

                  // Action Footer
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),

                    child: SizedBox(
                      width: double.infinity,
                      child: AppElevatedButton.withTitle(
                        onPressed: isCreating ? null : _onSaveAddress,
                        title: context.translate(
                          LocalizationKeys.saveAndUseAddress,
                        ),
                        color: AppColors.colorPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AddAddressScreenWithBloc extends StatelessWidget {
  const AddAddressScreenWithBloc({super.key});

  @override
  Widget build(BuildContext context) {
    final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
    final AddressesApiManager apiManager = AddressesApiManager(dioApiManager);
    final AddressesRepository repository = AddressesRepository(apiManager);

    final getUserAddressesUseCase = GetUserAddressesUseCase(repository);
    final createUserAddressUseCase = CreateUserAddressUseCase(repository);
    final getAddressGovernoratesUseCase = GetAddressGovernoratesUseCase(
      repository,
    );

    return BlocProvider(
      create: (context) => AddressesBloc(
        getUserAddressesUseCase: getUserAddressesUseCase,
        createUserAddressUseCase: createUserAddressUseCase,
        getAddressGovernoratesUseCase: getAddressGovernoratesUseCase,
      )..add(const FetchGovernoratesForAddressEvent()),
      child: const AddAddressScreen(),
    );
  }
}
