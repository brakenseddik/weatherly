import 'package:dio/dio.dart';

class Constants {
  static final dioOptions = BaseOptions(
      baseUrl: 'http://api.weatherapi.com/v1',
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 5));
}
