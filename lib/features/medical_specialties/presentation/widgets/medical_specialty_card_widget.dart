import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/medical_specialties/data/models/medical_specialties_response_model.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class MedicalSpecialtyCardWidget extends StatelessWidget {
  final MedicalSpecialtyModel specialty;
  final VoidCallback? onTap;

  const MedicalSpecialtyCardWidget({
    super.key,
    required this.specialty,
    this.onTap,
  });

  IconData _getFallbackIcon(String nameEn, String nameAr) {
    final String lowerEn = nameEn.toLowerCase();
    final String lowerAr = nameAr.toLowerCase();

    if (lowerEn.contains('dent') || lowerAr.contains('أسنان')) {
      return Icons.sentiment_satisfied_alt_outlined;
    } else if (lowerEn.contains('internal') || lowerAr.contains('باطن')) {
      return Icons.monitor_heart_outlined;
    } else if (lowerEn.contains('ortho') || lowerAr.contains('عظام')) {
      return Icons.accessibility_new_outlined;
    } else if (lowerEn.contains('pediatric') || lowerAr.contains('أطفال')) {
      return Icons.person_outline;
    } else if (lowerEn.contains('ent') || lowerAr.contains('أنف')) {
      return Icons.hearing_outlined;
    } else if (lowerEn.contains('derma') || lowerAr.contains('جلد')) {
      return Icons.shield_outlined;
    } else if (lowerEn.contains('gynec') ||
        lowerAr.contains('نساء') ||
        lowerAr.contains('توليد')) {
      return Icons.favorite_border;
    } else if (lowerEn.contains('ophthal') || lowerAr.contains('عيون')) {
      return Icons.remove_red_eye_outlined;
    }
    return Icons.medical_services_outlined;
  }

  Widget _buildIcon() {
    if (specialty.imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: specialty.imageUrl,
        width: 30.w,
        height: 30.h,
        fit: BoxFit.contain,
        placeholder: (context, url) => Icon(
          _getFallbackIcon(specialty.nameEn, specialty.nameAr),
          size: 30.r,
          color: AppColors.colorPrimary,
        ),
        errorWidget: (context, url, error) => Icon(
          _getFallbackIcon(specialty.nameEn, specialty.nameAr),
          size: 30.r,
          color: AppColors.colorPrimary,
        ),
      );
    }
    return Icon(
      _getFallbackIcon(specialty.nameEn, specialty.nameAr),
      size: 30.r,
      color: AppColors.colorPrimary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            SizedBox(height: 10.h),
            Text(
              specialty.getName(context),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.buttonBlackTextColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              context.translate(LocalizationKeys.viewDoctors),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.labelSubtitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
