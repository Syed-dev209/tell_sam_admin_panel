import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:tell_sam_admin_panel/constants/network_constants.dart';

class DioService {
  static Dio dio =
      Dio(BaseOptions(headers: APIS.header, baseUrl: APIS.baseUrl));

  static Future<Response> get(String endPoint, {dynamic queryParams}) async {
    try {
      log("=======================");
      log(endPoint);
      log(queryParams.toString());
      var response = await dio.get(endPoint, queryParameters: queryParams);
      log(response.data.toString());
      log("=======================");
      return response;
    } on DioError catch (e) {
      log(e.toString());
      log("=======================");
      if (e.response?.data != null) {
        throw (e.response!.data['message']);
      }
      throw ('Something went wrong');
    }
  }

  static Future<Response> post(String endPoint,
      {Map<String, dynamic>? body}) async {
    try {
      log("=======================");
      print(endPoint);
      print(body.toString());
      var response = await dio.post(endPoint, data: body);
      print(response.data.toString());
      log("=======================");
      return response;
    } on DioError catch (e) {
      print(e.toString());
      log("=======================");
      if (e.response?.data != null) {
        throw (e.response!.data['message']);
      }
      throw ('Something went wrong');
    }
  }
}
