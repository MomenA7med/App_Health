import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/send_prescription/presentation/screens/capture_prescription_screen.dart';
import 'package:app_health/features/send_prescription/presentation/screens/send_prescription_screen.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class ReviewPrescriptionScreen extends StatefulWidget {
  final String imagePath;
  final List<String>? imagePaths;
  final String? preselectedPharmacyId;
  final ImagePicker? imagePicker;

  const ReviewPrescriptionScreen({
    super.key,
    required this.imagePath,
    this.imagePaths,
    this.preselectedPharmacyId,
    this.imagePicker,
  });

  static const String routeName = '/review-prescription';

  static Future<T?> open<T>(
    BuildContext context, {
    required String imagePath,
    List<String>? imagePaths,
    String? preselectedPharmacyId,
  }) {
    return context.push<T>(
      routeName,
      extra: {
        'imagePath': imagePath,
        'imagePaths': imagePaths,
        'preselectedPharmacyId': preselectedPharmacyId,
      },
    );
  }

  @override
  State<ReviewPrescriptionScreen> createState() =>
      _ReviewPrescriptionScreenState();
}

class _ReviewPrescriptionScreenState extends State<ReviewPrescriptionScreen> {
  late List<String> _images;
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    if (widget.imagePaths != null && widget.imagePaths!.isNotEmpty) {
      _images = List<String>.from(widget.imagePaths!);
    } else if (widget.imagePath.isNotEmpty) {
      _images = [widget.imagePath];
    } else {
      _images = [];
    }
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onRetake() async {
    final result = await context.push<List<String>>(
      CapturePrescriptionScreen.routeName,
      extra: {
        'preselectedPharmacyId': widget.preselectedPharmacyId,
        'isAddingPhoto': true,
      },
    );
    if (result != null && result.isNotEmpty && mounted) {
      setState(() {
        _images = result;
        _currentIndex = 0;
      });
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
  }

  Future<void> _onAddPhoto() async {
    final result = await context.push<List<String>>(
      CapturePrescriptionScreen.routeName,
      extra: {
        'preselectedPharmacyId': widget.preselectedPharmacyId,
        'existingImagePaths': _images,
        'isAddingPhoto': true,
      },
    );
    if (result != null && result.isNotEmpty && mounted) {
      setState(() {
        _images = result;
        _currentIndex = _images.length - 1;
      });
      if (_images.length > 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              _images.length - 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    }
  }

  String _getImageCountText(BuildContext context) {
    final count = _images.length;
    if (count <= 1) {
      return context.translate(LocalizationKeys.oneImageAttached);
    } else if (count == 2) {
      return context.translate(LocalizationKeys.twoImagesAttached);
    } else {
      return context
          .translate(LocalizationKeys.imagesAttachedCount)
          .replaceAll('{count}', count.toString());
    }
  }

  Widget _buildImagePreview(String path) {
    final bool hasFile = path.isNotEmpty && File(path).existsSync();
    if (hasFile) {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 72.r,
            color: AppColors.colorPrimary,
          ),
          SizedBox(height: 12.h),
          Text(
            context.translate(LocalizationKeys.attachedPrescription),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.buttonBlackTextColor,
            ),
          ),
        ],
      ),
    );
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
          context.translate(LocalizationKeys.reviewPrescription),
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
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.translate(
                        LocalizationKeys.ensurePrescriptionClarity,
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.buttonBlackTextColor,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Document Preview Card
                    Container(
                      width: double.infinity,
                      height: 380.h,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 1.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.r),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            if (_images.isEmpty)
                              _buildImagePreview('')
                            else if (_images.length == 1)
                              _buildImagePreview(_images.first)
                            else
                              PageView.builder(
                                controller: _pageController,
                                itemCount: _images.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return _buildImagePreview(_images[index]);
                                },
                              ),

                            // Dots indicator if multiple images
                            if (_images.length > 1)
                              Positioned(
                                bottom: 16.h,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.black.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(_images.length, (i) {
                                      final bool isActive = i == _currentIndex;
                                      return Container(
                                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                                        width: isActive ? 16.w : 6.w,
                                        height: 6.h,
                                        decoration: BoxDecoration(
                                          color: isActive
                                              ? AppColors.white
                                              : AppColors.white.withValues(alpha: 0.5),
                                          borderRadius: BorderRadius.circular(3.r),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Image count row
                    Row(
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 20.r,
                          color: AppColors.labelSubtitle,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _getImageCountText(context),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.labelSubtitle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Actions: Retake & Add photo
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _onRetake,
                            borderRadius: BorderRadius.circular(24.r),
                            child: Container(
                              height: 48.h,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: AppColors.borderLight,
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    size: 19.r,
                                    color: AppColors.colorPrimary,
                                  ),
                                  SizedBox(width: 8.w),
                                  Flexible(
                                    child: Text(
                                      context.translate(
                                        LocalizationKeys.retakePhoto,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.colorPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: InkWell(
                            onTap: _onAddPhoto,
                            borderRadius: BorderRadius.circular(24.r),
                            child: Container(
                              height: 48.h,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: AppColors.borderLight,
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 19.r,
                                    color: AppColors.colorPrimary,
                                  ),
                                  SizedBox(width: 8.w),
                                  Flexible(
                                    child: Text(
                                      context.translate(
                                        LocalizationKeys.addPhoto,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.colorPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom CTA: Continue
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: AppElevatedButton.withTitle(
                  title: context.translate(LocalizationKeys.continueAction),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  color: AppColors.colorPrimary,
                  textColor: AppColors.buttonWhiteTextColor,
                  onPressed: () {
                    final primaryPath =
                        _images.isNotEmpty ? _images.first : widget.imagePath;
                    SendPrescriptionScreen.open(
                      context,
                      imagePath: primaryPath,
                      imagePaths: _images,
                      preselectedPharmacyId: widget.preselectedPharmacyId,
                    );
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

