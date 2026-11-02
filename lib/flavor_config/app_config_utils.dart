import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:app_health/flavor_config/app_environment_variables.dart';

import 'env_enum.dart';
import 'environment_variables_keys.dart';

class AppConfigUtils {
  static FlavorConfig get flavorConfigInstance {
    return FlavorConfig.instance;
  }

  static Environment get environment {
    switch (flavorConfigInstance.name) {
      case "development":
        return Environment.development;
      case "qc":
        return Environment.qc;
      case "staging":
        return Environment.staging;
      case "production":
        return Environment.production;

      default:
        return Environment.development;
    }
  }

  static String get baseUrl {
    return AppEnvironmentVariables.baseUrl;
  }

  static String get notificationTopicName {
    return flavorConfigInstance.variables[EnvironmentVariablesKeys
        .notificationTopicName
        .name];
  }

  static bool get showInspector {
    return flavorConfigInstance.variables[EnvironmentVariablesKeys
        .showInspector
        .name];
  }

  static bool get showBlocLog {
    return flavorConfigInstance.variables[EnvironmentVariablesKeys
        .showBlocLog
        .name];
  }

  static bool get showNetworkLog {
    return flavorConfigInstance.variables[EnvironmentVariablesKeys
        .showNetworkLog
        .name];
  }

  static bool get showRoutingLog {
    return flavorConfigInstance.variables[EnvironmentVariablesKeys
        .showRoutingLog
        .name];
  }

  static Color get color {
    return flavorConfigInstance.variables[EnvironmentVariablesKeys.color.name];
  }

  static bool get showTestOrganization {
    return flavorConfigInstance.variables[EnvironmentVariablesKeys
        .showTestOrganization
        .name];
  }

  static bool get onProduction => environment == Environment.production;
  static bool get onDevelopment => environment == Environment.development;
  static bool get onQc => environment == Environment.qc;
  static bool get onStaging => environment == Environment.staging;
}
