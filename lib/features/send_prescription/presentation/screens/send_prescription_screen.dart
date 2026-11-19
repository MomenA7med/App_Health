import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/addresses/presentation/widgets/choose_address_bottom_sheet.dart';
import 'package:app_health/features/send_prescription/data/datasources/send_prescription_api_manager.dart';
import 'package:app_health/features/send_prescription/data/repositories/send_prescription_repository.dart';
import 'package:app_health/features/send_prescription/domain/repositories/base_send_prescription_repository.dart';
import 'package:app_health/features/send_prescription/domain/usecases/get_prescription_governorates_use_case.dart';
import 'package:app_health/features/send_prescription/domain/usecases/get_prescription_pharmacies_use_case.dart';
import 'package:app_health/features/send_prescription/domain/usecases/get_prescription_saved_addresses_use_case.dart';
import 'package:app_health/features/send_prescription/domain/usecases/send_prescription_use_case.dart';
import 'package:app_health/features/send_prescription/presentation/bloc/send_prescription_bloc.dart';
import 'package:app_health/features/send_prescription/presentation/bloc/send_prescription_event.dart';
import 'package:app_health/features/send_prescription/presentation/bloc/send_prescription_state.dart';
import 'package:app_health/features/send_prescription/presentation/screens/prescription_sent_screen.dart';
import 'package:app_health/features/send_prescription/presentation/widgets/prescription_attachment_card_widget.dart';
import 'package:app_health/features/send_prescription/presentation/widgets/select_pharmacies_bottom_sheet.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/features/widgets/location_filter_selector_widget.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/feedback/feedback_message.dart';
import 'package:app_health/utils/loaders/loader_widget.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class SendPrescriptionScreen extends StatelessWidget {
  final String? imagePath;
  final List<String>? imagePaths;
  final bool isWithoutPrescription;
  final String? preselectedPharmacyId;
  final BaseSendPrescriptionRepository? repository;

  const SendPrescriptionScreen({
    super.key,
    this.imagePath,
    this.imagePaths,
    this.isWithoutPrescription = false,
    this.preselectedPharmacyId,
    this.repository,
  });

  static const String routeName = '/send-prescription';

  static Future<T?> open<T>(
    BuildContext context, {
    String? imagePath,
    List<String>? imagePaths,
    bool isWithoutPrescription = false,
    String? preselectedPharmacyId,
  }) {
    return context.push<T>(
      routeName,
      extra: {
        'imagePath': imagePath,
        'imagePaths': imagePaths,
        'isWithoutPrescription': isWithoutPrescription,
        'preselectedPharmacyId': preselectedPharmacyId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRepo = repository ??
        SendPrescriptionRepository(
          SendPrescriptionApiManager(GetIt.I<DioApiManager>()),
        );

    final sendUseCase = SendPrescriptionUseCase(effectiveRepo);
    final govUseCase = GetPrescriptionGovernoratesUseCase(effectiveRepo);
    final pharmUseCase = GetPrescriptionPharmaciesUseCase(effectiveRepo);
    final addressUseCase = GetPrescriptionSavedAddressesUseCase(effectiveRepo);

    final effectiveImagePath = imagePath ??
        (imagePaths != null && imagePaths!.isNotEmpty
            ? imagePaths!.first
            : null);

    return BlocProvider<SendPrescriptionBloc>(
      create: (context) => SendPrescriptionBloc(
        sendPrescriptionUseCase: sendUseCase,
        getGovernoratesUseCase: govUseCase,
        getPharmaciesUseCase: pharmUseCase,
        getSavedAddressesUseCase: addressUseCase,
      )..add(
          InitSendPrescriptionEvent(
            imagePath: effectiveImagePath,
            imagePaths: imagePaths,
            isWithoutPrescription: isWithoutPrescription,
            preselectedPharmacyId: preselectedPharmacyId,
          ),
        ),
      child: SendPrescriptionScreenContent(imagePaths: imagePaths),
    );
  }
}

class SendPrescriptionScreenContent extends StatefulWidget {
  final List<String>? imagePaths;

  const SendPrescriptionScreenContent({
    super.key,
    this.imagePaths,
  });

  @override
  State<SendPrescriptionScreenContent> createState() =>
      _SendPrescriptionScreenContentState();
}

class _SendPrescriptionScreenContentState
    extends State<SendPrescriptionScreenContent> {
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _getSubmitButtonTitle(BuildContext context, int count) {
    if (count == 2) {
      return context.translate(LocalizationKeys.sendToTwoPharmacies);
    } else if (count > 2) {
      return context
          .translate(LocalizationKeys.sendToPharmacies)
          .replaceAll('{count}', count.toString());
    }
    return context.translate(LocalizationKeys.sendPrescription);
  }

  String _getRecipientSummaryText(BuildContext context, int count) {
    if (count == 1) {
      return context.translate(LocalizationKeys.onePharmacySelected);
    } else if (count == 2) {
      return context.translate(LocalizationKeys.twoPharmaciesSelected);
    } else if (count > 2) {
      return context
          .translate(LocalizationKeys.selectedPharmaciesCount)
          .replaceAll('{count}', count.toString());
    }
    return context.translate(LocalizationKeys.selectPharmacies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.translate(LocalizationKeys.orderDetailsTitle),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.buttonBlackTextColor,
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.all(8.r),
          child: InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(22.r),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderLight, width: 1.0),
              ),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 18.r,
                color: AppColors.buttonBlackTextColor,
              ),
            ),
          ),
        ),
      ),
      body: BlocConsumer<SendPrescriptionBloc, SendPrescriptionState>(
        listener: (context, state) {
          if (state.status == SendPrescriptionStatus.success &&
              state.submittedOrder != null) {
            PrescriptionSentScreen.open(
              context,
              order: state.submittedOrder!,
            );
          } else if (state.status == SendPrescriptionStatus.error &&
              state.errorMessage != null) {
            showFeedbackMessage(
              state.isErrorLocalizationKey
                  ? context.translate(state.errorMessage!)
                  : state.errorMessage!,
              context: context,
              feedbackStyle: FeedbackStyle.snackBar,
            );
          }
        },
        builder: (context, state) {
          if (state.status == SendPrescriptionStatus.loading) {
            return const Center(child: LoaderWidget());
          }

          final selectedPharmacies = state.selectedPharmacies;
          final isLocationModeArea = state.locationStrategy == 0;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Attached Prescription or Without Prescription Indicator
                      if (!state.isWithoutPrescription && state.imagePath != null) ...[
                        PrescriptionAttachmentCardWidget(
                          imagePath: state.imagePath,
                          imagePaths: widget.imagePaths,
                          onRemove: () {
                            context
                                .read<SendPrescriptionBloc>()
                                .add(const SetPrescriptionImageEvent(null));
                          },
                        ),
                        SizedBox(height: 20.h),
                      ],

                      // 2. Location Strategy Selector
                      LocationFilterSelectorWidget(
                        locationMode: isLocationModeArea ? 'area' : 'saved',
                        onLocationModeChanged: (mode) {
                          context.read<SendPrescriptionBloc>().add(
                                ChangeLocationStrategyEvent(
                                  mode == 'saved' ? 1 : 0,
                                ),
                              );
                        },
                        governorates: state.governorates,
                        selectedGovernorateId: state.selectedGovernorate?.id,
                        selectedGovernorateName: state.selectedGovernorate?.name,
                        selectedAreaId: state.selectedArea?.id,
                        selectedAreaName: state.selectedArea?.name,
                        onGovernorateChanged: (id, name) {
                          final matches =
                              state.governorates.where((g) => g.id == id);
                          if (matches.isNotEmpty) {
                            context
                                .read<SendPrescriptionBloc>()
                                .add(SelectGovernorateEvent(matches.first));
                          }
                        },
                        onAreaChanged: (id, name) {
                          final areas = state.selectedGovernorate?.areas ?? [];
                          final matches = areas.where((a) => a.id == id);
                          if (matches.isNotEmpty) {
                            context
                                .read<SendPrescriptionBloc>()
                                .add(SelectAreaEvent(matches.first));
                          }
                        },
                        onSavedAddressSelected: (govId, areaId) async {
                          final selected = await ChooseAddressBottomSheet.show(
                            context: context,
                            currentSelectedAddress: state.selectedSavedAddress,
                          );
                          if (selected != null && context.mounted) {
                            context
                                .read<SendPrescriptionBloc>()
                                .add(SelectSavedAddressEvent(selected));
                          }
                        },
                      ),
                      SizedBox(height: 20.h),

                      // 3. Recipient Pharmacies Section ("إرسال إلى")
                      Text(
                        context.translate(LocalizationKeys.sendTo),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonBlackTextColor,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // Trigger dropdown container
                      InkWell(
                        onTap: () {
                          SelectPharmaciesBottomSheet.show(
                            context: context,
                            availablePharmacies: state.availablePharmacies,
                            initialSelectedPharmacies: state.selectedPharmacies,
                            onConfirm: (selectedList) {
                              // Reset and replace
                              for (final p in state.selectedPharmacies) {
                                if (!selectedList.any((s) => s.id == p.id)) {
                                  context
                                      .read<SendPrescriptionBloc>()
                                      .add(RemovePharmacyEvent(p.id));
                                }
                              }
                              for (final p in selectedList) {
                                if (!state.selectedPharmacies
                                    .any((s) => s.id == p.id)) {
                                  context
                                      .read<SendPrescriptionBloc>()
                                      .add(ToggleSelectPharmacyEvent(p));
                                }
                              }
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(24.r),
                        child: Container(
                          height: 52.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: selectedPharmacies.isNotEmpty
                                ? AppColors.white
                                : AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(
                              color: AppColors.borderLight,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedPharmacies.isNotEmpty
                                    ? _getRecipientSummaryText(
                                        context,
                                        selectedPharmacies.length,
                                      )
                                    : (isLocationModeArea &&
                                            (state.selectedGovernorate == null ||
                                                state.selectedArea == null)
                                        ? context.translate(
                                            LocalizationKeys
                                                .chooseGovAndAreaFirst,
                                          )
                                        : context.translate(
                                            LocalizationKeys.selectPharmacies,
                                          )),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: selectedPharmacies.isNotEmpty
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: selectedPharmacies.isNotEmpty
                                      ? AppColors.buttonBlackTextColor
                                      : AppColors.textMuted,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 22.r,
                                color: AppColors.textMuted,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Selected Pharmacies Chips
                      if (selectedPharmacies.isNotEmpty) ...[
                        SizedBox(height: 10.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: selectedPharmacies.map((pharmacy) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.pharmacyChipBg,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<SendPrescriptionBloc>()
                                          .add(RemovePharmacyEvent(pharmacy.id));
                                    },
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 16.r,
                                      color: AppColors.pharmacyChipText,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    pharmacy.displayName,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.pharmacyChipText,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      SizedBox(height: 20.h),

                      // 4. Notes Section ("ملاحظات (اختياري)")
                      Text(
                        context.translate(LocalizationKeys.orderNotesOptional),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonBlackTextColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        height: 96.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: AppColors.borderLight,
                            width: 1.0,
                          ),
                        ),
                        child: TextField(
                          controller: _notesController,
                          maxLines: null,
                          onChanged: (val) {
                            context
                                .read<SendPrescriptionBloc>()
                                .add(UpdateOrderDetailsEvent(val));
                          },
                          decoration: InputDecoration(
                            hintText: context.translate(
                              LocalizationKeys.orderNotesHint,
                            ),
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textMuted,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),

              // Sticky Bottom Action CTA
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, -2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: state.status == SendPrescriptionStatus.submitting
                      ? const Center(child: LoaderWidget())
                      : SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: AppElevatedButton.withTitle(
                            title: _getSubmitButtonTitle(
                              context,
                              selectedPharmacies.length,
                            ),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            color: state.canSubmit
                                ? AppColors.colorPrimary
                                : AppColors.cardBorder,
                            textColor: state.canSubmit
                                ? AppColors.buttonWhiteTextColor
                                : AppColors.textMuted,
                            onPressed: state.canSubmit
                                ? () {
                                    context.read<SendPrescriptionBloc>().add(
                                          const SubmitPrescriptionOrderEvent(),
                                        );
                                  }
                                : null,
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

