import 'package:flutter/material.dart';
import 'package:app_health/core/widgets/base_stateful_widget.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionText extends StatelessWidget {
  final TextStyle? style;
  const AppVersionText({super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: currentAppVersion,
      builder: (context, snapshot) {
        return Text(
          snapshot.hasData
              ? "${context.translate(LocalizationKeys.version)} : ${snapshot.data}"
              : "",
          style: style ?? context.bodyMedium.copyWith(fontSize: 12),
        );
      },
    );
  }

  Future<String> get currentAppVersion async {
    var info = (await PackageInfo.fromPlatform());
    return "${info.version}+${info.buildNumber}";
  }
}
