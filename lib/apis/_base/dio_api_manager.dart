import 'dart:io';

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:app_health/apis/_base/request_form_data_interceptor.dart';
import 'package:app_health/apis/api_keys.dart';
import 'package:app_health/flavor_config/app_config_utils.dart';
import 'package:app_health/local_storage/local_storage_manager.dart';
import 'package:app_health/logic/user_manager.dart';
import 'package:app_health/utils/extensions/extension_string.dart';
import 'package:app_health/utils/locale/locale_cubit.dart';
import 'package:requests_inspector/requests_inspector.dart';

class DioApiManager {
  final String defaultLanguage = "ar-SA";
  final LocalStorageManager localStorageManager;
  final VoidCallback? logOutCallBack;

  //  dio instance to request token
  DioApiManager({required this.localStorageManager, this.logOutCallBack});
  final _logInterceptor = AwesomeDioInterceptor();

  final _requestsInspectorInterceptor = RequestsInspectorInterceptor();

  Dio get dioUnauthorized {
    return DioOptions.dioInstance(options)
      ..interceptors.clear()
      ..interceptors.addAll([
        _queuedInterceptorsWrapperUnauthorized,
        ...interceptors,
      ]);
  }

  Dio get dio {
    return DioOptions.dioInstance(options)
      ..interceptors.clear()
      ..interceptors.addAll([_queuedInterceptorsWrapper, ...interceptors]);
  }

  List<Interceptor> get interceptors {
    return [
      if (AppConfigUtils.showInspector) ...[_requestsInspectorInterceptor],
      if (AppConfigUtils.showNetworkLog) ...[
        _logInterceptor,
        RequestFormDataInterceptor(),
      ],
    ];
  }

  QueuedInterceptorsWrapper get _queuedInterceptorsWrapper {
    return QueuedInterceptorsWrapper(
      onError: _onError,
      onRequest: (request, handler) async {
        await _setLanguage(request);
        await _setToken(request);
        return handler.next(request);
      },
    );
  }

  QueuedInterceptorsWrapper get _queuedInterceptorsWrapperUnauthorized {
    return QueuedInterceptorsWrapper(
      onRequest: (request, handler) async {
        await _setLanguage(request);
        return handler.next(request);
      },
    );
  }

  Future<void> logOutNow() async {
    localStorageManager.clearData();
    logOutCallBack?.call();
  }

  Future<void> _setToken(RequestOptions request) async {
    final String? token = await localStorageManager.getAccessToken();
    GetIt.I<UserMangers>().setToken(token ?? "");

    if (token.isNotNullOrNotEmpty) {
      if (request.headers[ApiKeys.authorization] == null) {
        request.headers[ApiKeys.authorization] = '${ApiKeys.keyBearer} $token';
      } else {
        request.headers.remove(ApiKeys.authorization);
      }
    }
  }

  DioOptions get options => DioOptions();

  Options getOptionsWithToken(String? token) {
    final Options options = Options();
    options.headers = {
      ...DioOptions().headers,
      if (token != null && token.isNotEmpty)
        ApiKeys.authorization: '${ApiKeys.keyBearer} $token',
    };
    return options;
  }

  Future<bool> updateHeaders() async {
    DioOptions.token = await localStorageManager.getAccessToken();
    DioOptions.language = await localStorageManager.getLocale();
    return true;
  }

  Future<void> _setLanguage(RequestOptions request) async {
    final String language = LocaleApp.mapFromString(
      await localStorageManager.getLocale() ?? defaultLanguage,
    ).mapToPreferenceKey();
    if (request.headers[ApiKeys.locale] != language) {
      request.headers[ApiKeys.locale] = language;
    }
  }

  void _onError(DioException error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401) {
      try {
        // String accessToken = await preferenceManager.getAccessToken() ?? "";
        // String refreshToken = await preferenceManager.getRefreshToken() ?? "";
        // dio.post(ApiUrls.refreshToken, data: {
        //   ApiKeys.accessToken: accessToken,
        //   ApiKeys.refreshToken: refreshToken
        // }).then(
        //   (value) async {
        //     final newAccessToken = value.data[ApiKeys.accessToken];
        //     final newRefreshToken = value.data[ApiKeys.refreshToken];
        //     Map<String, dynamic> decodedToken =
        //         JwtDecoder.decode(newAccessToken);
        //     preferenceManager.setAccessAndRefreshToken(
        //         newAccessToken, newRefreshToken);
        //     preferenceManager.setUserId(decodedToken["id"]);
        //
        //     final requestOptions = error.requestOptions;
        //     requestOptions.headers[ApiKeys.authorization] =
        //         '${ApiKeys.bearer} $newAccessToken';
        //
        //     final response = await dio.request(
        //       requestOptions.path,
        //       options: Options(
        //         method: requestOptions.method,
        //         headers: requestOptions.headers,
        //       ),
        //       data: requestOptions.data,
        //       queryParameters: requestOptions.path.contains(ApiUrls.profileUrl)
        //           ? {ApiKeys.userId: decodedToken["id"]}
        //           : requestOptions.queryParameters,
        //     );
        //     return handler.resolve(response);
        //   },
        // );
        GetIt.I<UserMangers>().signOut();
      } catch (e) {
        return handler.reject(error);
      }
    }
    return handler.next(error);
  }
}

class DioOptions extends BaseOptions {
  @override
  Map<String, dynamic> get headers {
    final Map<String, dynamic> header = {};
    header.putIfAbsent(ApiKeys.locale, () => language);
    header.putIfAbsent(ApiKeys.accept, () => ApiKeys.applicationJson);
    header.putIfAbsent(
      ApiKeys.platform,
      () => Platform.isIOS ? ApiKeys.platformIos : ApiKeys.platformAndroid,
    );
    header.putIfAbsent("app-source", () => "mobile");

    return header;
  }

  @override
  String get baseUrl => AppConfigUtils.baseUrl;

  static String? token;
  static String? language;

  static Dio? dio;

  static Dio dioInstance(BaseOptions options) {
    dio ??= Dio(options);
    return dio!;
  }
}
