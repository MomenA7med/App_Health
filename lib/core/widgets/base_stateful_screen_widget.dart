import 'package:flutter/material.dart';
import 'package:app_health/core/loading_manager.dart';
import 'package:app_health/core/widgets/base_stateful_widget.dart';

export 'package:app_health/core/extensions/extension_localization.dart';
export 'package:app_health/core/extensions/extension_theme.dart';
export 'package:app_health/core/extensions/screen_sizer_extension.dart';

abstract class BaseStatefulScreenWidget extends BaseStatefulWidget {
  const BaseStatefulScreenWidget({super.key});

  @override
  BaseScreenState baseCreateState() => baseScreenCreateState();

  BaseScreenState baseScreenCreateState();
}

abstract class BaseScreenState<W extends BaseStatefulScreenWidget>
    extends BaseState<W>
    with LoadingManager {
  @override
  Widget baseBuild(BuildContext context) {
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [baseScreenBuild(context), loadingManagerWidget()],
      ),
    );
  }

  void changeState() {
    setState(() {});
  }

  @override
  void runChangeState() {
    changeState();
  }

  @override
  BuildContext provideContext() {
    return context;
  }

  Widget baseScreenBuild(BuildContext context);
}
