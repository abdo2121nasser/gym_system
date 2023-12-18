import 'package:dio/dio.dart';

class DioHelper {

  static Dio? dio;

  static init(){
    dio=Dio(
        BaseOptions(
          baseUrl: 'https://exercisedb.p.rapidapi.com/',
          receiveDataWhenStatusError: true,
        )
    );
  }

  static Future<Response> getData(
      {
        required String url,
        Map<String,dynamic> ?query,
        String? token,
      }
      )
  async {
    dio!.options.headers = {
      'X-RapidAPI-Key':'678ea85411mshe8f4d4587f795e4p1bd240jsn98a6aad3c44e',
      'X-RapidAPI-Host':'exercisedb.p.rapidapi.com'
    };
    return await dio!.get(url,queryParameters:query );
  }





  static Future<Response> postData(
      {
        required String url,
        Map<String, dynamic>? query,
        required Map<String, dynamic> data,
        String? token,
      }
      ) {

    dio!.options.headers = {
      'Authorization':'Bearer $token',
    };
    return dio!.post(url, queryParameters: query, data: data);
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
  }) async {

    dio!.options.headers = {
      'Authorization':'Bearer $token',
    };
    return dio!.put(url, queryParameters: query, data: data);

  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    dio!.options.headers = {
      'Authorization': 'Bearer $token',
    };

    return await dio!.delete(url, queryParameters: query, data: data);
  }





}