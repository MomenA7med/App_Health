import 'package:flutter/material.dart';
import 'package:app_health/res/app_colors.dart';

Widget labelTextWidget(
  String title,
  Color? textColor, {
  double? fontSize,
  FontWeight? fontWeight,
  bool textWithUnderLine = false,
}) {
  return Text(
    title,
    style: TextStyle(
      color: textColor,
      fontWeight: fontWeight,
      fontSize: fontSize,
      decoration: textWithUnderLine ? TextDecoration.underline : null,
    ),
  );
}

Widget labelIconWidget(
  String title,
  Widget icon,
  Color? color,
  bool iconFirst, {
  bool textWithUnderLine = false,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
}) {
  color ??= AppColors.white;
  return Row(
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: MainAxisSize.min,
    children: [
      iconFirst
          ? icon
          : labelTextWidget(title, color, textWithUnderLine: textWithUnderLine),
      SizedBox(width: 10),
      iconFirst
          ? labelTextWidget(title, color, textWithUnderLine: textWithUnderLine)
          : icon,
    ],
  );
}

RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(100),
);
EdgeInsets buttonPadding = const EdgeInsets.symmetric(
  horizontal: 15,
  vertical: 12,
);
