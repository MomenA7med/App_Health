import 'package:flutter/material.dart';
import 'package:app_health/features/widgets/app_buttons/common_widget.dart';

class AppTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  final EdgeInsets? padding;

  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: padding ?? buttonPadding,
        shape: buttonShape,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
