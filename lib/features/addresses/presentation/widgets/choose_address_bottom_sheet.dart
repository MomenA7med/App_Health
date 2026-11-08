import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/addresses/data/datasources/addresses_api_manager.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/addresses/data/repositories/addresses_repository.dart';
import 'package:app_health/features/addresses/domain/usecases/create_user_address_use_case.dart';
import 'package:app_health/features/addresses/domain/usecases/get_address_governorates_use_case.dart';
import 'package:app_health/features/addresses/domain/usecases/get_user_addresses_use_case.dart';
import 'package:app_health/features/addresses/presentation/bloc/addresses_bloc.dart';
import 'package:app_health/features/addresses/presentation/bloc/addresses_event.dart';
import 'package:app_health/features/addresses/presentation/bloc/addresses_state.dart';
import 'package:app_health/features/addresses/presentation/screens/add_address_screen.dart';
import 'package:app_health/features/addresses/presentation/widgets/saved_address_item_widget.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/loaders/loader_widget.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class ChooseAddressBottomSheet extends StatefulWidget {
  final UserAddressModel? initialSelectedAddress;
  final ValueChanged<UserAddressModel>? onSelectAddress;
  final VoidCallback? onSelectCurrentLocation;

  const ChooseAddressBottomSheet({
    super.key,
    this.initialSelectedAddress,
    this.onSelectAddress,
    this.onSelectCurrentLocation,
  });

  static Future<UserAddressModel?> show({
    required BuildContext context,
    UserAddressModel? currentSelectedAddress,
    ValueChanged<UserAddressModel>? onSelectAddress,
    VoidCallback? onSelectCurrentLocation,
  }) {
    final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
    final AddressesApiManager apiManager = AddressesApiManager(dioApiManager);
    final AddressesRepository repository = AddressesRepository(apiManager);

    final getUserAddressesUseCase = GetUserAddressesUseCase(repository);
    final createUserAddressUseCase = CreateUserAddressUseCase(repository);
    final getAddressGovernoratesUseCase =
        GetAddressGovernoratesUseCase(repository);

    return showModalBottomSheet<UserAddressModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (bottomSheetContext) => BlocProvider(
        create: (context) => AddressesBloc(
          getUserAddressesUseCase: getUserAddressesUseCase,
          createUserAddressUseCase: createUserAddressUseCase,
          getAddressGovernoratesUseCase: getAddressGovernoratesUseCase,
        )..add(const FetchUserAddressesEvent()),
        child: ChooseAddressBottomSheet(
          initialSelectedAddress: currentSelectedAddress,
          onSelectAddress: onSelectAddress,
          onSelectCurrentLocation: onSelectCurrentLocation,
        ),
      ),
    );
  }

  @override
  State<ChooseAddressBottomSheet> createState() =>
      _ChooseAddressBottomSheetState();
}

class _ChooseAddressBottomSheetState extends State<ChooseAddressBottomSheet> {
  UserAddressModel? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _selectedAddress = widget.initialSelectedAddress;
  }

  Future<void> _navigateToAddAddress(BuildContext context) async {
    final bloc = context.read<AddressesBloc>();
    final newAddress = await Navigator.of(context).push<UserAddressModel>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: const AddAddressScreen(),
        ),
      ),
    );

    if (newAddress != null && mounted) {
      setState(() {
        _selectedAddress = newAddress;
      });
    }
  }

  Widget _buildCurrentLocationCard(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<AddressesBloc>().add(const SelectCurrentLocationEvent());
        widget.onSelectCurrentLocation?.call();
        Navigator.of(context).pop();
      },
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.my_location_rounded,
                size: 20,
                color: AppColors.colorPrimary,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.translate(LocalizationKeys.useCurrentLocation),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    context
                        .translate(LocalizationKeys.detectLocationAutomatically),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textBody,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              context.translate(LocalizationKeys.determineAction),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Drag Handle
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.bottomSheetDragHandle,
                  borderRadius: BorderRadius.circular(9999.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Sheet Title
            Text(
              context.translate(LocalizationKeys.chooseAddress),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 6.h),

            // Helper Text
            Text(
              context.translate(LocalizationKeys.chooseAddressHelper),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textBody,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 18.h),

            // Saved Addresses Label
            Text(
              context.translate(LocalizationKeys.savedAddresses),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 12.h),

            // Addresses List
            Flexible(
              child: BlocBuilder<AddressesBloc, AddressesState>(
                builder: (context, state) {
                  if (state is AddressesLoadingState) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 28.h),
                      child: const Center(child: LoaderWidget()),
                    );
                  }

                  if (state is AddressesErrorState) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.isLocalizationKey
                                ? context.translate(state.errorMessage)
                                : state.errorMessage,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.errorRed,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12.h),
                          AppElevatedButton.withTitle(
                            title: context.translate(LocalizationKeys.retry),
                            onPressed: () {
                              context
                                  .read<AddressesBloc>()
                                  .add(const FetchUserAddressesEvent());
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is AddressesLoadedState) {
                    if (state.items.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Center(
                          child: Text(
                            context
                                .translate(LocalizationKeys.noSavedAddresses),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textBody,
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final address = state.items[index];
                        final isSelected = _selectedAddress?.id == address.id;

                        return SavedAddressItemWidget(
                          address: address,
                          isSelected: isSelected,
                          governorates: state.governorates,
                          onTap: () {
                            setState(() {
                              _selectedAddress = address;
                            });
                            context
                                .read<AddressesBloc>()
                                .add(SelectAddressEvent(address));
                            widget.onSelectAddress?.call(address);
                            Navigator.of(context).pop(address);
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            SizedBox(height: 12.h),

            // Button: Add New Address
            AppElevatedButton.withTitle(
              onPressed: () => _navigateToAddAddress(context),
              title: context.translate(LocalizationKeys.addNewAddress),
              color: AppColors.colorPrimary,
            ),
            SizedBox(height: 16.h),

            // Divider
            const Divider(color: AppColors.borderLight, height: 1),
            SizedBox(height: 16.h),

            // Use Current Location Option Card
            _buildCurrentLocationCard(context),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

