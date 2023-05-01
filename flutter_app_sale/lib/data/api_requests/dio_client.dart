import 'package:dio/dio.dart';
import 'package:flutter_app_sale/common/constants/api_url.dart';
import 'package:flutter_app_sale/common/constants/share_preference_key.dart';
import 'package:flutter_app_sale/common/helpers/app_share_prefs.dart';

class DioClient {
  Dio? _dio;
  static final BaseOptions _options = BaseOptions(
    baseUrl: ApiURL.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  );

  static final DioClient instance = DioClient._internal();

  DioClient._internal() {
    if (_dio == null) {
      _dio = Dio(_options);
      _dio!.interceptors.add(LogInterceptor(requestBody: true));
      _dio!.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        String token = AppSharePreferences.getString(SharePreferenceKey.token);
        options.headers["Authorization"] = "Bearer $token";
        return handler.next(options);
      }));
    }
  }

  Dio get dio => _dio!;
}
