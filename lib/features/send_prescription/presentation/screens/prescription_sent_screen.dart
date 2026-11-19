import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:app_health/core/widgets/base_stateless_widget.dart';
import 'package:app_health/features/pharmacies_list/presentation/screens/pharmacies_list_screen.dart';
import 'package:app_health/features/send_prescription/data/models/send_prescription_response_model.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class PrescriptionSentScreen extends BaseStatelessWidget {
  final PrescriptionOrderModel order;

  const PrescriptionSentScreen({
    super.key,
    required this.order,
  });

  static const String routeName = '/prescription-sent';

  static void open(
    BuildContext context, {
    required PrescriptionOrderModel order,
  }) {
    context.push(
      routeName,
      extra: {'order': order},
    );
  }

  String _getSentSummaryTitle(BuildContext context, int count) {
    if (count == 1) {
      return context.translate(LocalizationKeys.sentToOnePharmacySummary);
    } else if (count == 2) {
      return context.translate(LocalizationKeys.sentToTwoPharmaciesSummary);
    }
    return context
        .translate(LocalizationKeys.sentToPharmaciesSummary)
        .replaceAll('{count}', count.toString());
  }

  @override
  Widget baseBuild(BuildContext context) {
    final pharmacies = order.pharmacies;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.translate(LocalizationKeys.sendOrder),
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Big Checkmark in circular tint container
                    Container(
                      width: 88.r,
                      height: 88.r,
                      decoration: const BoxDecoration(
                        color: AppColors.colorSecondary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 46.r,
                        color: AppColors.colorPrimary,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Success Title
                    Text(
                      context.translate(
                        LocalizationKeys.orderSentSuccessfully,
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.buttonBlackTextColor,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Subtitle
                    Text(
                      context.translate(
                        LocalizationKeys.waitingPharmaciesResponse,
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.labelSubtitle,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // Recipient Pharmacies Summary Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getSentSummaryTitle(context, pharmacies.length),
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.buttonBlackTextColor,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: pharmacies.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: 10.h),
                            itemBuilder: (context, index) {
                              final item = pharmacies[index];
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.displayName,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.buttonBlackTextColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.pendingWarningBg,
                                      borderRadius:
                                          BorderRadius.circular(16.r),
                                    ),
                                    child: Text(
                                      context.translate(
                                        LocalizationKeys.waitingForReply,
                                      ),
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.pendingWarningText,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Order Reference Card
                    if (order.orderNumber.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: AppColors.borderLight,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.translate(
                                LocalizationKeys.orderNumberLabel,
                              ),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.labelSubtitle,
                              ),
                            ),
                            Text(
                              order.orderNumber,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.colorPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Bottom CTA: Back to Pharmacies
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: AppElevatedButton.withTitle(
                  title: context.translate(LocalizationKeys.backToPharmacies),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  color: AppColors.colorPrimary,
                  textColor: AppColors.buttonWhiteTextColor,
                  onPressed: () {
                    context.go(PharmaciesListScreen.routeName);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

