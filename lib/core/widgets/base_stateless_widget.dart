import 'package:flutter/material.dart';
import 'package:app_health/core/platform_manager.dart';

export 'package:app_health/core/extensions/extension_localization.dart';
export 'package:app_health/core/extensions/extension_theme.dart';
export 'package:app_health/core/extensions/screen_sizer_extension.dart';

// ignore: must_be_immutable
abstract class BaseStatelessWidget extends StatelessWidget
    with PlatformManager {
  const BaseStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return baseBuild(context);
  }

  Widget baseBuild(BuildContext context);
}
