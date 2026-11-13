import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/res/app_colors.dart';

class AppFavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final Color? borderColor;
  final Color activeColor;
  final Color inactiveColor;
  final List<BoxShadow>? boxShadow;

  const AppFavoriteButton({
    super.key,
    required this.isFavorite,
    this.onTap,
    this.size = 38,
    this.iconSize = 20,
    this.backgroundColor = AppColors.white,
    this.borderColor = AppColors.borderLight,
    this.activeColor = AppColors.errorRed,
    this.inactiveColor = AppColors.textMuted,
    this.boxShadow,
  });

  factory AppFavoriteButton.translucent({
    Key? key,
    required bool isFavorite,
    VoidCallback? onTap,
    double size = 36,
    double iconSize = 20,
    Color? backgroundColor,
    Color? borderColor,
    Color activeColor = AppColors.errorRed,
    Color inactiveColor = AppColors.white,
    List<BoxShadow>? boxShadow,
  }) {
    return AppFavoriteButton(
      key: key,
      isFavorite: isFavorite,
      onTap: onTap,
      size: size,
      iconSize: iconSize,
      backgroundColor: backgroundColor ?? AppColors.white.withValues(alpha: 0.85),
      borderColor: borderColor,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      boxShadow: boxShadow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size.r,
        height: size.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1.0)
              : null,
          boxShadow: boxShadow,
        ),
        child: Icon(
          isFavorite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          size: iconSize.r,
          color: isFavorite ? activeColor : inactiveColor,
        ),
      ),
    );
  }
}
