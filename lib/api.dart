import 'dart:convert';
import 'package:dio/adapter_browser.dart';
import 'package:dio/browser_imp.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

import 'user.dart'; 


final api = Api();

class Api {

  static const API = 'http://zumaran.tech/skdl';
  Dio dio;
  final cookieJar = CookieJar();

  Api() {
    if (kIsWeb) {
      dio = DioForBrowser();
      final adapter = BrowserHttpClientAdapter();
      adapter.withCredentials = true;
      dio.httpClientAdapter = adapter;
    }
    else {
      dio = Dio();
      dio.interceptors.add(CookieManager(cookieJar));
    }
  }

  Future<R> _sendRequest<R extends ApiResponse>(
      Future<Response> requestFunction(), R onSuccess(Response response), R onError(String errorMsg)) async {
    try {
      final response = await requestFunction();
      return Future.value(onSuccess.call(response));
    } catch(e) {
      if (e is DioError)
        return Future.value(onError.call('${e.message} ${e.toString()}'));
      else
        return Future.value(onError.call('something unexpected happened'));
    }
  }

  Future<SignUpResponse> signUp(String email, String password, String passwordConfirm, {String name}) async {
    return _sendRequest(
            () => dio.post(
                '$API/user/signup',
                options: Options(
                  contentType: Headers.jsonContentType,
                  validateStatus: (status) => status < 500,
                ),
                data: {
                  'name': name?? email.split('@')[0],
                  'email': email,
                  'password': password,
                  'passwordConfirm': passwordConfirm
                }
            ),
            (response) => SignUpResponse(response.statusCode, response.data),
            (errorMsg) => SignUpResponse.error(errorMsg));
  }

  Future<LoginResponse> login(LoginCredentials user) async {
    return _sendRequest(
            () => dio.post(
              '$API/user/signin', 
              options: Options(
                followRedirects: false, 
                contentType: Headers.formUrlEncodedContentType, 
                validateStatus: (status) => status < 500,
              ), 
              data: {
                'email': user.email,
                'password': user.password
              }
            ), 
            (response) => LoginResponse(response.statusCode), 
            (errorMsg) => LoginResponse.error(errorMsg));
  }

  logout() => dio.get('$API/user/signout');

//===================================================================

  addUserTag(UserTag tag) async {
    final response = await dio.post(
        '$API/home/tag/add',
        options: Options(
          contentType: Headers.jsonContentType,
          validateStatus: (status) => status < 500,
        ),
        data: jsonEncode(tag)
    );
  }

  UserCalendar getUserCalendar() {
    return UserCalendar([UserMonth(Month.June, [
      UserWeek([
        UserDay(Day.Monday, 1, [
          Event('wtf'), Event('xd')
        ]),
        UserDay(Day.Tuesday, 2, [
          Event('tues'), Event('ddd')
        ]),
        UserDay(Day.Wednesday, 3, [
          Event('ww'), Event('ww')
        ]),
        UserDay(Day.Thursday, 4, [
          Event('tt'), Event('ddd')
        ]),
        UserDay(Day.Friday, 5, [
          Event('fff'), Event('ddd')
        ]),
        UserDay(Day.Saturday, 6, [
          Event('ssss'), Event('ddd')
        ]),
        UserDay(Day.Sunday, 7, [
          Event('sunday'), Event('ddd')
        ]),
      ]),
      UserWeek([
        UserDay(Day.Monday, 8, [
          Event('wtf'), Event('xd')
        ]),
        UserDay(Day.Tuesday, 9, [
          Event('tues'), Event('ddd')
        ]),
        UserDay(Day.Wednesday, 10, [
          Event('ww'), Event('ww')
        ]),
        UserDay(Day.Thursday, 11, [
          Event('tt'), Event('ddd')
        ]),
        UserDay(Day.Friday, 12, [
          Event('fff'), Event('ddd')
        ]),
        UserDay(Day.Saturday, 13, [
          Event('ssss'), Event('ddd')
        ]),
        UserDay(Day.Sunday, 14, [
          Event('sunday'), Event('ddd')
        ]),
      ]),
      UserWeek([
        UserDay(Day.Monday, 15, [
          Event('wtf'), Event('xd')
        ]),
        UserDay(Day.Tuesday, 16, [
          Event('tues'), Event('ddd')
        ]),
        UserDay(Day.Wednesday, 17, [
          Event('ww'), Event('ww')
        ]),
        UserDay(Day.Thursday, 18, [
          Event('tt'), Event('ddd')
        ]),
        UserDay(Day.Friday, 19, [
          Event('fff'), Event('ddd')
        ]),
        UserDay(Day.Saturday, 20, [
          Event('ssss'), Event('ddd')
        ]),
        UserDay(Day.Sunday, 21, [
          Event('sunday'), Event('ddd')
        ]),
      ]),
      UserWeek([
        UserDay(Day.Monday, 22, [
          Event('wtf'), Event('xd')
        ]),
        UserDay(Day.Tuesday, 23, [
          Event('tues'), Event('ddd')
        ]),
        UserDay(Day.Wednesday, 24, [
          Event('ww'), Event('ww')
        ]),
        UserDay(Day.Thursday, 25, [
          Event('tt'), Event('ddd')
        ]),
        UserDay(Day.Friday, 26, [
          Event('fff'), Event('ddd')
        ]),
        UserDay(Day.Saturday, 27, [
          Event('ssss'), Event('ddd')
        ]),
        UserDay(Day.Sunday, 28, [
          Event('sunday'), Event('ddd')
        ]),
      ]),
      UserWeek([
        UserDay(Day.Monday, 29, [
          Event('wtf'), Event('xd')
        ]),
        UserDay(Day.Tuesday, 30, [
          Event('tues'), Event('ddd')
        ]),
        UserDay(Day.Wednesday, 1, [
          Event('ww'), Event('ww')
        ]),
        UserDay(Day.Thursday, 2, [
          Event('tt'), Event('ddd')
        ]),
        UserDay(Day.Friday, 3, [
          Event('fff'), Event('ddd')
        ]),
        UserDay(Day.Saturday, 4, [
          Event('ssss'), Event('ddd')
        ]),
        UserDay(Day.Sunday, 5, [
          Event('sunday'), Event('ddd')
        ]),
      ]),
    ])]);
  }

  Future<String> profile() async {
    final response = await dio.get('$API/home/settings');
    return response.data.toString();
  }

  Future<String> home() async {
    final response = await dio.get('$API/home');
    return response.data.toString();
  }

}

//=====================================================================

class ApiResponse {
  final int status;
  String msg = 'No message available';

  ApiResponse(this.status);
  ApiResponse.error(this.msg, [this.status = 404]);

  bool isSuccessful() => status == 200;
}

class LoginResponse extends ApiResponse {
  LoginResponse.error(String msg) : super.error('An error occurred $msg');
  LoginResponse(int status) : super(status) {
    switch (status) {
      case 200: msg = "login successful"; break;
      case 401: msg = 'invalid credentials'; break;
    }
  }
}

class SignUpResponse extends ApiResponse {
  SignUpResponse.error(String msg) : super.error('an error occurred $msg');
  SignUpResponse(int status, dynamic data) : super(status) {
    switch (status) {
      case 201: msg = "signed up successfully"; break;
      case 400: msg = 'try again: ${data['error']}'; break;
    }
  }

  @override
  bool isSuccessful() => status == 201;
}

