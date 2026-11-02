import 'package:flutter/material.dart';
import 'package:app_health/res/app_colors.dart';

class DotIndicator extends StatelessWidget {
  final int currentPage;
  final int numPages;

  const DotIndicator({
    super.key,
    required this.currentPage,
    required this.numPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        numPages,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: CircleAvatar(
            radius: 4,
            backgroundColor: currentPage == index
                ? AppColors.dotsIndicator
                : AppColors.dotsIndicatorActive,
          ),
        ),
      ),
    );
  }
}
