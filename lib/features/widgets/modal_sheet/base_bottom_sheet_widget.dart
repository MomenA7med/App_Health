import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/widgets/base_stateless_widget.dart';
import 'package:app_health/res/app_colors.dart';

//ignore:must_be_immutable
class BaseBottomSheetWidget extends BaseStatelessWidget {
  const BaseBottomSheetWidget({
    super.key,
    required this.child,
    this.onCloseCallBack,
    required this.shape,
    this.padding,
  });
  final Widget child;
  final ShapeBorder? shape;
  final VoidCallback? onCloseCallBack;
  final EdgeInsetsGeometry? padding;

  @override
  Widget baseBuild(BuildContext context) {
    return Card(
      color: AppColors.modalBottomSheetBackground,
      margin: EdgeInsets.zero,
      shape: shape,
      child: Padding(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: AppColors.modalBottomSheetDivider,
                height: 3.h,
                width: 75.w,
              ),
              SizedBox(height: 3.h),
              // Align(
              //   alignment: AlignmentDirectional.centerEnd,
              //   child: InkWell(
              //     onTap: () => _closeClicked(context),
              //     child: CircleAvatar(
              //       backgroundColor: AppColors.modalBottomSheetDivider,
              //       radius: 12,
              //       child: const Icon(
              //         Icons.close,
              //         size: 15,
              //         color: AppColors.modalBottomSheetCloseIcon,
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
