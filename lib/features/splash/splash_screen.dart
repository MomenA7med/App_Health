import 'dart:async';

import 'package:app_health/features/login/presentation/screen/login_screen.dart';
import 'package:app_health/features/medical_specialties/presentation/screen/medical_specialties_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:app_health/features/widgets/logo_widget.dart';
import 'package:app_health/local_storage/local_storage_manager.dart';
import 'package:app_health/logic/user_manager.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/status_bar/statusbar_controller.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/splash";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var localStorageManager = GetIt.I<LocalStorageManager>();

  @override
  void initState() {
    super.initState();
    setStatusBarColor(
      color: AppColors.splashBackground,
      brightness: Brightness.dark,
    );
    _startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[_backgroundWidget(), _logoWidget()]);
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _logoWidget() {
    return Container(
      padding: const EdgeInsets.all(50),
      child: Center(child: LogoWidget()),
    );
  }

  Widget _backgroundWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.splashBackground,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  /// time to switch screen
  Future<Timer> _startTime() async {
    const duration = Duration(milliseconds: 2000);
    return Timer(duration, _navigationPage);
  }

  /// navigate to next screen
  Future<void> _navigationPage() async {
    bool isLoggedIn = await localStorageManager.isLoggedIn();

    if (isLoggedIn) {
      GetIt.I<UserMangers>().fetchUserInfoFromLocal();
      return _openHomeScreen();
    } else {
      return _openLoginScreen();
    }
  }

  Future<void> _openLoginScreen() async {
    LoginScreen.open(context: context);
  }

  Future<void> _openHomeScreen() async {
    MedicalSpecialtiesScreen.open(context: context);
  }
}
