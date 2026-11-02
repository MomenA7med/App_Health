import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum AndroidStore { googlePlayStore, apkPure }

class AppVersionChecker {
  /// Select The marketplace of your app
  /// default will be `AndroidStore.GooglePlayStore`
  final AndroidStore androidStore;
  final dio = Dio();
  AppVersionChecker({this.androidStore = AndroidStore.googlePlayStore});

  /// return `Current App Version Number` if update is available
  Future<String> get currentAppVersion async {
    var info = (await PackageInfo.fromPlatform());
    return "${info.version} (${info.buildNumber})";
  }

  Future<String> get currentBuildAppNumber async =>
      (await PackageInfo.fromPlatform()).buildNumber;

  Future<AppCheckerResult> checkUpdate({String? minAcceptedVersion}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final packageName = packageInfo.packageName;

    if (Platform.isAndroid) {
      switch (androidStore) {
        case AndroidStore.apkPure:
          return _checkMinAcceptedVersion(
            await _checkApkPureStore(currentVersion, packageName),
            minAcceptedVersion,
          );

        default:
          return _checkMinAcceptedVersion(
            await _checkPlayStore(currentVersion, packageName),
            minAcceptedVersion,
          );
      }
    } else if (Platform.isIOS) {
      return _checkMinAcceptedVersion(
        await _checkAppleStore(currentVersion, packageName),
        minAcceptedVersion,
      );
    } else {
      return AppCheckerResult(
        currentVersion,
        null,
        "",
        'The target platform "${Platform.operatingSystem}" is not yet supported by this package.',
      );
    }
  }

  AppCheckerResult _checkMinAcceptedVersion(
    AppCheckerResult storeCheckingInfo,
    String? minAcceptedVersion,
  ) {
    if (minAcceptedVersion == null) {
      return storeCheckingInfo;
    } else {
      storeCheckingInfo.mustUpdate =
          storeCheckingInfo.newVersion == minAcceptedVersion
              ? true
              : AppCheckerResult.shouldUpdate(
                storeCheckingInfo.currentVersion,
                minAcceptedVersion,
              );
      return storeCheckingInfo;
    }
  }

  Future<AppCheckerResult> _checkAppleStore(
    String currentVersion,
    String packageName,
  ) async {
    String? errorMsg;
    String? newVersion;
    String? url;
    var uri = Uri.https("itunes.apple.com", "/lookup", {
      "bundleId": packageName,
    });
    try {
      final response = await dio.getUri(uri);
      if (response.statusCode != 200) {
        errorMsg =
            "Can't find an app in the Apple Store with the id: $packageName";
      } else {
        final jsonObj = jsonDecode(response.data);
        final List results = jsonObj['results'];
        if (results.isEmpty) {
          errorMsg =
              "Can't find an app in the Apple Store with the id: $packageName";
        } else {
          newVersion = jsonObj['results'][0]['version'];
          url = jsonObj['results'][0]['trackViewUrl'];
        }
      }
    } catch (e) {
      errorMsg = "$e";
    }
    return AppCheckerResult(currentVersion, newVersion, url, errorMsg);
  }

  Future<AppCheckerResult> _checkPlayStore(
    String currentVersion,
    String packageName,
  ) async {
    String? errorMsg;
    String? newVersion;
    String? url;
    final uri = Uri.https("play.google.com", "/store/apps/details", {
      "id": packageName,
    });
    try {
      final response = await dio.getUri(uri);
      if (response.statusCode != 200) {
        errorMsg =
            "Can't find an app in the Google Play Store with the id: $packageName";
      } else {
        newVersion = RegExp(
          r',\[\[\["([0-9,\.]*)"]],',
        ).firstMatch(response.data)!.group(1);
        url = uri.toString();
      }
    } catch (e) {
      errorMsg = "$e";
    }
    return AppCheckerResult(currentVersion, newVersion, url, errorMsg);
  }

  Future<AppCheckerResult> _checkApkPureStore(
    String currentVersion,
    String packageName,
  ) async {
    String? errorMsg;
    String? newVersion;
    String? url;
    Uri uri = Uri.https("apkpure.com", "$packageName/$packageName");
    try {
      final response = await dio.getUri(uri);
      if (response.statusCode != 200) {
        errorMsg =
            "Can't find an app in the ApkPure Store with the id: $packageName";
      } else {
        newVersion =
            RegExp(
              r'<div class="details-sdk"><span itemprop="version">(.*?)<\/span>for Android<\/div>',
            ).firstMatch(response.data)!.group(1)!.trim();
        url = uri.toString();
      }
    } catch (e) {
      errorMsg = "$e";
    }
    return AppCheckerResult(currentVersion, newVersion, url, errorMsg);
  }

  /// This checks the version status, then displays a platform-specific alert
  /// with buttons to dismiss the update alert, or go to the app store.
  showAlertIfNecessary({required BuildContext context}) async {
    final AppCheckerResult versionStatus = await checkUpdate();
    if (versionStatus.canUpdate) {
      // ignore: use_build_context_synchronously
      showUpdateDialog(context: context, appCheckerResult: versionStatus);
    }
  }

  /// Shows the user a platform-specific alert about the app update. The user
  /// can dismiss the alert or proceed to the app store.
  ///
  /// To change the appearance and behavior of the update dialog, you can
  /// optionally provide [dialogTitle], [dialogContent], [updateButtonText],
  /// [dismissButtonText], and [dismissAction] parameters.
  void showUpdateDialog({
    required BuildContext context,
    required AppCheckerResult appCheckerResult,
    String dialogTitle = 'Update Available',
    String? dialogContent,
    String updateButtonText = 'Update',
    bool allowDismissal = true,
    String dismissButtonText = 'Skip',
    TextStyle? dialogTitleStyle,
    TextStyle? dialogContentStyle,
    VoidCallback? dismissAction,
  }) async {
    final dialogTitleWidget = Text(dialogTitle, style: dialogTitleStyle);
    final dialogContentWidget = Text(
      dialogContent ??
          'You can now update this app from ${appCheckerResult.currentVersion} to ${appCheckerResult.newVersion}',
      style: dialogContentStyle,
    );

    final updateButtonTextWidget = Text(updateButtonText);
    updateAction() {
      launchAppStore(appCheckerResult.appURL!);
      if (allowDismissal) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    List<Widget> actions = [
      Platform.isAndroid
          ? TextButton(onPressed: updateAction, child: updateButtonTextWidget)
          : CupertinoDialogAction(
            onPressed: updateAction,
            child: updateButtonTextWidget,
          ),
    ];

    if (allowDismissal) {
      final dismissButtonTextWidget = Text(dismissButtonText);
      dismissAction =
          dismissAction ??
          () => Navigator.of(context, rootNavigator: true).pop();
      actions.add(
        Platform.isAndroid
            ? TextButton(
              onPressed: dismissAction,
              child: dismissButtonTextWidget,
            )
            : CupertinoDialogAction(
              onPressed: dismissAction,
              child: dismissButtonTextWidget,
            ),
      );
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: allowDismissal,
          child:
              Platform.isAndroid
                  ? AlertDialog(
                    title: dialogTitleWidget,
                    content: dialogContentWidget,
                    actions: actions,
                  )
                  : CupertinoAlertDialog(
                    title: dialogTitleWidget,
                    content: dialogContentWidget,
                    actions: actions,
                  ),
        );
      },
    );
  }

  /// Launches the Apple App Store or Google Play Store page for the app.
  Future<void> launchAppStore(String appStoreLink) async {
    debugPrint(appStoreLink);
    if (await canLaunchUrlString(appStoreLink)) {
      await launchUrlString(appStoreLink, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch appStoreLink: $appStoreLink';
    }
  }
}

class AppCheckerResult {
  /// return current app version
  final String currentVersion;

  /// return the new app version
  final String? newVersion;

  /// return the app url
  final String? appURL;

  /// return error message if found else it will return `null`
  final String? errorMessage;

  /// return `true` if update is available
  bool mustUpdate = false;

  AppCheckerResult(
    this.currentVersion,
    this.newVersion,
    this.appURL,
    this.errorMessage,
  );

  /// return `true` if update is available
  bool get canUpdate =>
      shouldUpdate(currentVersion, (newVersion ?? currentVersion));

  static bool shouldUpdate(String versionA, String versionB) {
    final versionNumbersA =
        versionA.split(".").map((e) => int.tryParse(e) ?? 0).toList();
    final versionNumbersB =
        versionB.split(".").map((e) => int.tryParse(e) ?? 0).toList();

    final int versionASize = versionNumbersA.length;
    final int versionBSize = versionNumbersB.length;
    int maxSize = math.max(versionASize, versionBSize);

    for (int i = 0; i < maxSize; i++) {
      if ((i < versionASize ? versionNumbersA[i] : 0) >
          (i < versionBSize ? versionNumbersB[i] : 0)) {
        return false;
      } else if ((i < versionASize ? versionNumbersA[i] : 0) <
          (i < versionBSize ? versionNumbersB[i] : 0)) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return "Current Version: $currentVersion\nNew Version: $newVersion\nApp URL: $appURL\ncan update: $canUpdate\nerror: $errorMessage";
  }
}
