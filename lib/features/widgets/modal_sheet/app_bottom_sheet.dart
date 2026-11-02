import 'package:flutter/material.dart';
import 'package:app_health/features/widgets/modal_sheet/base_bottom_sheet_widget.dart';
import 'package:app_health/res/app_colors.dart';

class AppBottomSheet {
  static void openAppBottomSheet({
    required BuildContext context,
    required Widget child,
    ShapeBorder shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    bool? isScrollControlled,
    bool withPadding = true,
    VoidCallback? onCloseCallBack,
    EdgeInsetsGeometry? padding,
  }) async {
    await showModalBottomSheet(
      barrierColor: AppColors.modalBottomSheetBarrier.withValues(alpha: 0.5),
      context: context,
      isScrollControlled: isScrollControlled ?? false,
      shape: shape,
      builder: (context) => Padding(
        padding: withPadding
            ? EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
            : EdgeInsets.zero,
        child: BaseBottomSheetWidget(
          onCloseCallBack: onCloseCallBack,
          shape: shape,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
