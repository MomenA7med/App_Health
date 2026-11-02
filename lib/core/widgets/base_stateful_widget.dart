import 'package:flutter/material.dart';
import 'package:app_health/core/platform_manager.dart';

export 'package:app_health/core/extensions/extension_localization.dart';
export 'package:app_health/core/extensions/extension_theme.dart';
export 'package:app_health/core/extensions/screen_sizer_extension.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({super.key});

  @override
  // ignore: no_logic_in_create_state
  BaseState createState() => baseCreateState();

  BaseState baseCreateState();
}

abstract class BaseState<W extends BaseStatefulWidget> extends State<W>
    with PlatformManager {
  @override
  Widget build(BuildContext context) {
    return baseBuild(context);
  }

  Widget baseBuild(BuildContext context);
}
