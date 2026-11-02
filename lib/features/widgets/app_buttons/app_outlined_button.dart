import 'package:flutter/material.dart';
import 'package:app_health/features/widgets/app_buttons/common_widget.dart';

class AppOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? textColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final double? borderRadius;
  final Color? backgroundColor;
  final double? width;
  final OutlinedBorder? outlinedBorder;

  const AppOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.backgroundColor,
    this.width,
    this.outlinedBorder,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        side: BorderSide(
          color: borderColor ?? Theme.of(context).primaryColor,
          width: 1,
        ),
        shape: outlinedBorder ?? buttonShape,
        padding: padding ?? buttonPadding,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
