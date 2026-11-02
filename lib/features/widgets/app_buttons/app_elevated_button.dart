import 'package:flutter/material.dart';
import 'package:app_health/features/widgets/app_buttons/common_widget.dart';
import 'package:app_health/res/app_colors.dart';

class AppElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget label;
  final Color? color;
  final EdgeInsets? padding;
  final OutlinedBorder? shape;
  final double? width;
  final Color? borderColor;
  final double? borderRadius;

  const AppElevatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.color,
    this.padding,
    this.shape,
    this.width,
    this.borderColor,
    this.borderRadius,
  });

  factory AppElevatedButton.withTitle({
    Key? key,
    VoidCallback? onPressed,
    EdgeInsets? padding,
    Color textColor = AppColors.buttonWhiteTextColor,
    Color? color,
    required String title,
    double? width,
    Color? borderColor,
    double? fontSize,
    FontWeight? fontWeight,
    OutlinedBorder? shape,
  }) {
    return AppElevatedButton(
      key: key,
      padding: padding,
      color: color,
      width: width,
      borderColor: borderColor,
      label: labelTextWidget(
        title,
        textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      onPressed: onPressed,
      shape: shape,
    );
  }

  factory AppElevatedButton.withTitleAndIcon({
    Key? key,
    VoidCallback? onPressed,
    Color? color,
    MainAxisAlignment? mainAxisAlignment,
    bool iconFirst = true,
    EdgeInsets? padding,
    required Widget icon,
    required String title,
  }) {
    return AppElevatedButton(
      key: key,
      onPressed: onPressed,
      padding: padding,
      label: labelIconWidget(
        title,
        icon,
        color,
        iconFirst,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: padding ?? buttonPadding,
        shape: shape ?? buttonShape,
        backgroundColor: color ?? AppColors.buttonBackground,
      ),
      onPressed: onPressed,
      child: label,
    );
  }
}
