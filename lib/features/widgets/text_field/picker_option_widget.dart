import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_health/core/widgets/base_stateless_widget.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class PickerOptionWidget extends BaseStatelessWidget {
  final VoidCallback? documentClickedCallBack;
  final VoidCallback cameraClickedCallBack;
  final VoidCallback galleryClickedCallBack;
  const PickerOptionWidget({
    this.documentClickedCallBack,
    required this.cameraClickedCallBack,
    required this.galleryClickedCallBack,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          _pickerTypeWidget(
            context.translate(LocalizationKeys.takePicture),
            AppAssetPaths.cameraIcon,
            cameraClickedCallBack,
            context,
          ),
          if (documentClickedCallBack != null)
            _pickerTypeWidget(
              context.translate(LocalizationKeys.files),
              AppAssetPaths.filesIcon,
              documentClickedCallBack!,
              context,
            ),
          _pickerTypeWidget(
            context.translate(LocalizationKeys.gallery),
            AppAssetPaths.galleryIcon,
            galleryClickedCallBack,
            context,
          ),
        ],
      ),
    );
  }

  Widget _pickerTypeWidget(
    String title,
    String path,
    VoidCallback callback,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          callback();
        },
        splashColor: AppColors.transparentColor,
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: AppColors.formImageSourceBorder,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                SvgPicture.asset(path),
                const SizedBox(width: 15),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.labelMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
