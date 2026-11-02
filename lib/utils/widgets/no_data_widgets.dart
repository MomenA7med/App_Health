import 'package:flutter/material.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class NoDataWidget extends StatelessWidget {
  final String? message;

  const NoDataWidget({this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message ?? context.translate(LocalizationKeys.noData)),
    );
  }
}
