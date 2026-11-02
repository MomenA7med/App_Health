import 'package:flutter/material.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/utils/empty/empty_widgets.dart';
import 'package:app_health/utils/loaders/full_screen_loader_widget.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

mixin LoadingManager {
  void runChangeState();

  BuildContext provideContext();

  String? message;
  bool isLoading = false;
  bool withBackground = true;
  bool isLoadingWithMessage = false;
  bool isLoadingNow() => isLoading || isLoadingWithMessage;

  void showLoading({bool withBackground = true}) async {
    if (!isLoading) {
      isLoading = true;
      this.withBackground = withBackground;
      runChangeState();
    }
  }

  void hideLoading() async {
    if (isLoading) {
      isLoading = false;
      runChangeState();
    }
  }

  void showMessageLoading({String? message}) async {
    this.message = message ?? plzWaitMsg();
    if (!isLoadingWithMessage) {
      isLoadingWithMessage = true;
      runChangeState();
    }
  }

  void hideMessageLoading() async {
    if (isLoadingWithMessage) {
      isLoadingWithMessage = false;
      runChangeState();
    }
  }

  void hideAnyLoading() {
    hideLoading();
    hideMessageLoading();
  }

  Widget loadingManagerWidget() {
    if (isLoading) {
      return customLoadingWidget();
    } else if (isLoadingWithMessage) {
      return customLoadingMessageWidget(message!);
    } else {
      return const EmptyWidget();
    }
  }

  /// use this method if you want to change the default loading widget
  Widget customLoadingWidget() {
    return FullScreenLoaderWidget();
  }

  /// use this method if you want to change the default loading widget with
  /// it's message
  /// [message] --> refer to the message that you want to display
  /// that already submitted using [showMessageLoading]
  Widget customLoadingMessageWidget(String message) {
    return FullScreenLoaderWidget.message(message);
  }

  String plzWaitMsg() => provideContext().translate(LocalizationKeys.plzWait);
}
