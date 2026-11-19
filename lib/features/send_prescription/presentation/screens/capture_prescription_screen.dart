import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/send_prescription/presentation/screens/review_prescription_screen.dart';
import 'package:app_health/features/send_prescription/presentation/screens/send_prescription_screen.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class CapturePrescriptionScreen extends StatefulWidget {
  final String? preselectedPharmacyId;
  final List<String>? existingImagePaths;
  final bool isAddingPhoto;
  final ImagePicker? imagePicker;
  final CameraController? cameraController;

  const CapturePrescriptionScreen({
    super.key,
    this.preselectedPharmacyId,
    this.existingImagePaths,
    this.isAddingPhoto = false,
    this.imagePicker,
    this.cameraController,
  });

  static const String routeName = '/capture-prescription';

  static void open(
    BuildContext context, {
    String? preselectedPharmacyId,
    List<String>? existingImagePaths,
    bool isAddingPhoto = false,
  }) {
    context.push(
      routeName,
      extra: {
        'preselectedPharmacyId': preselectedPharmacyId,
        'existingImagePaths': existingImagePaths,
        'isAddingPhoto': isAddingPhoto,
      },
    );
  }

  @override
  State<CapturePrescriptionScreen> createState() =>
      _CapturePrescriptionScreenState();
}

class _CapturePrescriptionScreenState extends State<CapturePrescriptionScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isInitializing = false;
  bool _isTakingPhoto = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.cameraController != null) {
      _controller = widget.cameraController;
    } else {
      _initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (widget.cameraController == null) {
      _controller?.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed) {
      if (ModalRoute.of(context)?.isCurrent == true) {
        _initCamera();
      }
    }
  }

  Future<void> _stopCamera() async {
    final controller = _controller;
    _controller = null;
    if (controller != null) {
      try {
        await controller.dispose();
      } catch (e) {
        debugPrint('Error disposing camera: $e');
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initCamera() async {
    if (_isInitializing) return;
    _isInitializing = true;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) setState(() => _isInitializing = false);
        return;
      }

      final rearCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        rearCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller.initialize();
      if (mounted) {
        setState(() {
          _controller = controller;
          _isInitializing = false;
        });
      } else {
        await controller.dispose();
      }
    } catch (e) {
      debugPrint('Error initializing in-frame camera: $e');
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  Future<void> _onCapture() async {
    if (_isTakingPhoto) return;
    _isTakingPhoto = true;
    try {
      String? capturedPath;
      if (_controller != null && _controller!.value.isInitialized) {
        final XFile photo = await _controller!.takePicture();
        capturedPath = photo.path;
      } else {
        // Fallback using image_picker (e.g. simulator without camera hardware)
        final picker = widget.imagePicker ?? ImagePicker();
        final XFile? photo = await picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.rear,
        );
        capturedPath = photo?.path;
      }

      if (capturedPath != null && mounted) {
        final List<String> updatedImages = [
          ...?widget.existingImagePaths,
          capturedPath,
        ];

        await _stopCamera();

        if (!mounted) return;

        if (widget.isAddingPhoto) {
          Navigator.of(context).pop(updatedImages);
        } else {
          await ReviewPrescriptionScreen.open(
            context,
            imagePath: updatedImages.first,
            imagePaths: updatedImages,
            preselectedPharmacyId: widget.preselectedPharmacyId,
          );
          if (mounted) {
            _initCamera();
          }
        }
      }
    } catch (e) {
      debugPrint('Error taking photo: $e');
    } finally {
      if (mounted) {
        setState(() => _isTakingPhoto = false);
      }
    }
  }

  Future<void> _onOpenGallery() async {
    try {
      final picker = widget.imagePicker ?? ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty && mounted) {
        final paths = images.map((f) => f.path).toList();
        final List<String> updatedImages = [
          ...?widget.existingImagePaths,
          ...paths,
        ];

        await _stopCamera();

        if (!mounted) return;

        if (widget.isAddingPhoto) {
          Navigator.of(context).pop(updatedImages);
        } else {
          await ReviewPrescriptionScreen.open(
            context,
            imagePath: updatedImages.first,
            imagePaths: updatedImages,
            preselectedPharmacyId: widget.preselectedPharmacyId,
          );
          if (mounted) {
            _initCamera();
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking images from gallery: $e');
    }
  }

  Future<void> _onContinueWithoutPrescription() async {
    await _stopCamera();
    if (!mounted) return;
    await SendPrescriptionScreen.open(
      context,
      isWithoutPrescription: true,
      preselectedPharmacyId: widget.preselectedPharmacyId,
    );
    if (mounted) {
      _initCamera();
    }
  }

  Widget _buildCorner({required bool isTop, required bool isLeft}) {
    return Container(
      width: 24.w,
      height: 24.h,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: AppColors.colorPrimary, width: 2.5)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: AppColors.colorPrimary, width: 2.5)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: AppColors.colorPrimary, width: 2.5)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: AppColors.colorPrimary, width: 2.5)
              : BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isCameraActive =
        _controller != null && _controller!.value.isInitialized;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.translate(LocalizationKeys.capturePrescription),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Text(
                context.translate(LocalizationKeys.prescriptionCaptureHint),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.labelSubtitle,
                ),
              ),
            ),

            // Camera Viewfinder Box (with live camera preview inside)
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: GestureDetector(
                  onTap: _onCapture,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: AppColors.borderLight,
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22.r),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 1. Live camera preview inside the box
                          if (isCameraActive)
                            SizedBox.expand(
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: _controller!.value.previewSize?.height ??
                                      1,
                                  height:
                                      _controller!.value.previewSize?.width ??
                                          1,
                                  child: CameraPreview(_controller!),
                                ),
                              ),
                            )
                          else
                            Container(
                              color: AppColors.cardBackground,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.document_scanner_rounded,
                                      size: 64.r,
                                      color: AppColors.textMuted,
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      context.translate(
                                        LocalizationKeys.takePrescriptionPhoto,
                                      ),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.labelSubtitle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // 2. Viewfinder corner marks
                          Positioned(
                            top: 24.h,
                            left: 24.w,
                            child: _buildCorner(isTop: true, isLeft: true),
                          ),
                          Positioned(
                            top: 24.h,
                            right: 24.w,
                            child: _buildCorner(isTop: true, isLeft: false),
                          ),
                          Positioned(
                            bottom: 24.h,
                            left: 24.w,
                            child: _buildCorner(isTop: false, isLeft: true),
                          ),
                          Positioned(
                            bottom: 24.h,
                            right: 24.w,
                            child: _buildCorner(isTop: false, isLeft: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Camera Controls Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Open Gallery
                  InkWell(
                    onTap: _onOpenGallery,
                    borderRadius: BorderRadius.circular(24.r),
                    child: Container(
                      width: 48.r,
                      height: 48.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 1.0,
                        ),
                      ),
                      padding: EdgeInsets.all(12.r),
                      child: SvgPicture.asset(
                        AppAssetPaths.galleryIcon,
                        colorFilter: const ColorFilter.mode(
                          AppColors.colorPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),

                  // Center Big Capture Button
                  GestureDetector(
                    onTap: _onCapture,
                    child: Container(
                      width: 76.r,
                      height: 76.r,
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.colorPrimary,
                          width: 3.0,
                        ),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.colorPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: _isTakingPhoto
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Icon(
                                Icons.camera_alt_rounded,
                                size: 32.r,
                                color: AppColors.white,
                              ),
                      ),
                    ),
                  ),

                  // Spacer to balance
                  SizedBox(width: 48.r),
                ],
              ),
            ),

            // Bottom CTA: Continue without prescription
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: InkWell(
                onTap: _onContinueWithoutPrescription,
                borderRadius: BorderRadius.circular(24.r),
                child: Container(
                  height: 48.h,
                  alignment: Alignment.center,
                  child: Text(
                    context.translate(
                      LocalizationKeys.continueWithoutPrescription,
                    ),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

