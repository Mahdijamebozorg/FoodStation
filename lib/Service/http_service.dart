import 'dart:developer';
import 'package:dio/dio.dart';

class HttpService {
  static Dio dio = Dio(BaseOptions());
  static Map<String, dynamic> headers = {
    'Accept': 'application/json',
  };

  static Future<Response<dynamic>?> getMehod(String url,
      {Map<String, dynamic>? data, String? token}) async {
    log('url: $url');
    log('data: ${data.toString()}');
    log('headers: ${headers.toString()}');

    final res = await dio
        .get(
      url,
      options: Options(
        responseType: ResponseType.json,
        method: "GET",
        headers: token == null ? headers : headers
          ..putIfAbsent('authorization', () => 'Bearer $token'),
      ),
      data: data,
    )
        .then((response) {
      log(response.toString());
      return response;
    });
    return res;
  }

  static Future<Response<dynamic>?> postMehod(
      String url, Map<String, dynamic> data,
      {String? token}) async {
    log('url: $url');
    log('data: ${data.toString()}');
    log('headers: ${headers.toString()}');

    final res = await dio
        .post(
      url,
      options: Options(
        method: 'POST',
        headers: token == null ? headers : headers
          ..putIfAbsent('authorization', () => 'Bearer $token'),
      ),
      data: data,
    )
        .then((response) {
      log(response.toString());
      return response;
    });
    return res;
  }

  static Future<Response<dynamic>?> delMehod(
      String url, Map<String, dynamic> data,
      {String? token}) async {
    log('url: $url');
    log('data: ${data.toString()}');
    log('headers: ${headers.toString()}');

    final res = await dio
        .delete(
      url,
      options: Options(
        responseType: ResponseType.json,
        method: "DEL",
        headers: token == null ? headers : headers
          ..putIfAbsent('authorization', () => 'Bearer $token'),
      ),
      data: data,
    )
        .then((response) {
      log(response.toString());
      return response;
    });
    return res;
  }

  static bool cmpFirstLetter({required int code, required int num}) {
    return code.toString()[0] == num.toString();
  }
}
