import 'package:flutter/material.dart';
import 'package:app_health/core/extensions/extension_theme.dart';
import 'package:app_health/res/app_colors.dart';

class LabelWithAsterisk extends StatelessWidget {
  final String text;
  final String? subtitle;
  final bool showAsterisk;

  const LabelWithAsterisk({
    super.key,
    required this.text,
    this.subtitle,
    this.showAsterisk = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text,
            style: context.bodyMedium.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subtitle != null) ...[
            TextSpan(
              text: " ",
              style: context.bodyMedium.copyWith(fontSize: 12),
            ),
            TextSpan(
              text: subtitle,
              style: TextStyle(
                color: AppColors.labelSubtitle,
                fontSize: 10,
                fontFamily: 'Noto Kufi Arabic',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ],
          if (showAsterisk)
            TextSpan(
              children: [
                TextSpan(
                  text: ' *',
                  style: context.bodyMedium.copyWith(
                    color: AppColors.formFieldAsterisk,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
