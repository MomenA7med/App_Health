import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class PrescriptionAttachmentCardWidget extends StatelessWidget {
  final String? imagePath;
  final List<String>? imagePaths;
  final VoidCallback onRemove;

  const PrescriptionAttachmentCardWidget({
    super.key,
    this.imagePath,
    this.imagePaths,
    required this.onRemove,
  });

  Widget _buildSingleThumbnail(String path, {double width = 48, double height = 60}) {
    final bool hasFile = path.isNotEmpty && File(path).existsSync();
    return Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderLight, width: 1.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: hasFile
            ? Image.file(
                File(path),
                fit: BoxFit.cover,
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: (width * 0.6).w,
                      height: 2.h,
                      color: AppColors.borderLight,
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      width: (width * 0.5).w,
                      height: 2.h,
                      color: AppColors.borderLight,
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      width: (width * 0.4).w,
                      height: 2.h,
                      color: AppColors.borderLight,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveImages = (imagePaths != null && imagePaths!.isNotEmpty)
        ? imagePaths!
        : (imagePath != null && imagePath!.isNotEmpty ? [imagePath!] : <String>[]);

    final int count = effectiveImages.length;
    final String countLabel;
    if (count <= 1) {
      countLabel = context.translate(LocalizationKeys.oneImageAttached);
    } else if (count == 2) {
      countLabel = context.translate(LocalizationKeys.twoImagesAttached);
    } else {
      countLabel = context
          .translate(LocalizationKeys.imagesAttachedCount)
          .replaceAll('{count}', count.toString());
    }

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.borderLight, width: 1.0),
      ),
      child: Row(
        children: [
          // Remove button
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(18.r),
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderLight, width: 1.0),
              ),
              child: Icon(
                Icons.close_rounded,
                size: 18.r,
                color: AppColors.textBody,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Attachment Text Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.translate(LocalizationKeys.attachedPrescription),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.buttonBlackTextColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '$countLabel · ${context.translate(LocalizationKeys.readyToSend)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.labelSubtitle,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),

          // Prescription Thumbnail(s) / Preview
          if (count > 1)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSingleThumbnail(effectiveImages[0], width: 34, height: 46),
                SizedBox(width: 6.w),
                _buildSingleThumbnail(effectiveImages[1], width: 34, height: 46),
              ],
            )
          else
            _buildSingleThumbnail(
              effectiveImages.isNotEmpty ? effectiveImages.first : (imagePath ?? ''),
            ),
        ],
      ),
    );
  }
}

