import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:app_health/apis/api_keys.dart';
import 'package:app_health/flavor_config/base_flavor_config.dart';
import 'package:app_health/flavor_config/environment_variables_keys.dart';
import 'package:app_health/utils/build_type/build_type.dart';

class ProductionFlavorConfig implements BaseFlavorConfig {
  @override
  setFlavorConfig() {
    FlavorConfig(
      name: "production",
      color: Colors.green,
      variables: environmentVariables,
    );
  }

  @override
  Map<String, dynamic> get environmentVariables => {
    EnvironmentVariablesKeys.showInspector.name: enableLog,
    EnvironmentVariablesKeys.notificationTopicName.name:
        ApiKeys.productionNotificationTopicName,
    EnvironmentVariablesKeys.showInspector.name: enableLog,
    EnvironmentVariablesKeys.showBlocLog.name: enableLog,
    EnvironmentVariablesKeys.showNetworkLog.name: enableLog,
    EnvironmentVariablesKeys.showRoutingLog.name: enableLog,
    EnvironmentVariablesKeys.color.name: Colors.green,
    EnvironmentVariablesKeys.showTestOrganization.name: false,
  };

  final enableLog = isDebugMode();
}
