import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:app_health/apis/api_keys.dart';
import 'package:app_health/flavor_config/base_flavor_config.dart';
import 'package:app_health/flavor_config/environment_variables_keys.dart';

class DevelopmentFlavorConfig implements BaseFlavorConfig {
  @override
  void setFlavorConfig() {
    FlavorConfig(
      name: "development",
      color: Colors.red,
      variables: environmentVariables,
    );
  }

  @override
  Map<String, dynamic> get environmentVariables => {
    EnvironmentVariablesKeys.showInspector.name: enableLog,
    EnvironmentVariablesKeys.notificationTopicName.name:
        ApiKeys.devNotificationTopicName,
    EnvironmentVariablesKeys.showBlocLog.name: enableLog,
    EnvironmentVariablesKeys.showNetworkLog.name: enableLog,
    EnvironmentVariablesKeys.showRoutingLog.name: enableLog,
    EnvironmentVariablesKeys.color.name: Colors.red,
    EnvironmentVariablesKeys.showTestOrganization.name: true,
  };

  bool get enableLog => true;
}
