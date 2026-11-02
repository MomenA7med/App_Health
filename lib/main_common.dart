import 'package:app_health/preferences/preferences_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/app_router.dart';
import 'package:app_health/flavor_config/app_config_utils.dart';
import 'package:app_health/flavor_config/base_flavor_config.dart';
import 'package:app_health/local_storage/local_storage_manager.dart';
import 'package:app_health/logic/user_manager.dart';
import 'package:app_health/my_app.dart';
import 'package:app_health/utils/bloc_observer/app_bloc_observer.dart';
import 'package:requests_inspector/requests_inspector.dart';

void mainCommon(BaseFlavorConfig flavorConfig) async {
  flavorConfig.setFlavorConfig();

  /// to fix Orientation problem
  WidgetsFlutterBinding.ensureInitialized();

  // if (isReleaseMode()) {
  //   FlutterError.onError = (errorDetails) {
  //     FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  //   };
  //   // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  //   PlatformDispatcher.instance.onError = (error, stack) {
  //     FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //     return true;
  //   };
  // }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) async {
    /// setup GetIt Instances ...
    GetIt.I.registerLazySingleton<LocalStorageManager>(
      () => LocalStorageManager(),
    );
    GetIt.I.registerLazySingleton<UserMangers>(
      () => UserMangers(GetIt.I<LocalStorageManager>()),
    );
    GetIt.I.registerLazySingleton<PreferencesManager>(
      () => PreferencesManager(),
    );
    GetIt.I.registerLazySingleton<DioApiManager>(
      () => DioApiManager(
        localStorageManager: GetIt.I<LocalStorageManager>(),
        logOutCallBack: () {
          // AppRouter.mainNavigatorKey.currentContext?.go(LoginScreen.routeName);
        },
      ),
    );

    if (AppConfigUtils.showBlocLog) {
      Bloc.observer = AppBlocObserver();
    }
    runApp(
      AppConfigUtils.onProduction
          ? RequestsInspector(
              enabled: !AppConfigUtils.showInspector,
              navigatorKey: AppRouter.mainNavigatorKey,
              showInspectorOn: ShowInspectorOn.Both,
              child: const MyApp(),
            )
          : Directionality(
              textDirection: TextDirection.rtl,
              child: Banner(
                message: AppConfigUtils.environment.name,
                color: AppConfigUtils.color,
                location: BannerLocation.topEnd,
                child: RequestsInspector(
                  enabled: !AppConfigUtils.showInspector,
                  navigatorKey: AppRouter.mainNavigatorKey,
                  showInspectorOn: ShowInspectorOn.Both,
                  child: const MyApp(),
                ),
              ),
            ),
    );
  });
}
