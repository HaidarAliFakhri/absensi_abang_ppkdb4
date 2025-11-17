import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://appabsensi.mobileprojp.com/", // GANTI!
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  ApiClient() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("API REQUEST: ${options.method} ${options.path}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("API RESPONSE: ${response.statusCode}");
          return handler.next(response);
        },
        onError: (e, handler) {
          print("API ERROR: ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }
}

final api = ApiClient().dio;
