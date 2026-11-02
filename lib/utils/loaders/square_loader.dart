import 'package:flutter/material.dart';
import 'package:app_health/utils/loaders/loader_widget.dart';

class SquareLoader extends StatelessWidget {
  const SquareLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const LoaderWidget(),
    );
  }
}
