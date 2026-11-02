import 'package:flutter/material.dart';
import 'package:app_health/res/app_colors.dart';

class PaginationLoaderWidget extends StatelessWidget {
  final bool isLoading;

  const PaginationLoaderWidget({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.bounceInOut,
      padding: const EdgeInsets.all(10),
      height: isLoading ? 55.0 : 0,
      color: isLoading
          ? Theme.of(context).cardColor
          : AppColors.transparentColor,
      duration: const Duration(milliseconds: 300),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
