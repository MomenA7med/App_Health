import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class PharmacyInsuranceTabWidget extends StatelessWidget {
  final List<InsuranceCompanyModel> insuranceCompanies;

  const PharmacyInsuranceTabWidget({
    super.key,
    required this.insuranceCompanies,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title: "شركات التأمين المقبولة"
          Text(
            context.translate(LocalizationKeys.acceptedInsuranceCompanies),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.buttonBlackTextColor,
            ),
          ),
          SizedBox(height: 16.h),

          if (insuranceCompanies.isEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              alignment: Alignment.center,
              child: Text(
                context.translate(LocalizationKeys.noAcceptedInsurance),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: insuranceCompanies.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final company = insuranceCompanies[index];
                final logo = company.logoUrl?.trim();

                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.borderLight,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Text Info (Arabic & English name)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              company.nameAr,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.buttonBlackTextColor,
                              ),
                            ),
                            if (company.nameEn.isNotEmpty) ...[
                              SizedBox(height: 2.h),
                              Text(
                                company.nameEn,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Logo Container
                      Container(
                        width: 52.r,
                        height: 52.r,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.borderSubtle,
                            width: 1.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: logo != null && logo.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: logo,
                                  fit: BoxFit.contain,
                                  placeholder: (_, __) => Center(
                                    child: Icon(
                                      Icons.health_and_safety_rounded,
                                      size: 26.r,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  errorWidget: (_, __, ___) => Center(
                                    child: Icon(
                                      Icons.health_and_safety_rounded,
                                      size: 26.r,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.health_and_safety_rounded,
                                    size: 26.r,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

