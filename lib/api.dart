import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';


final api = Api();

class Api {

  static const API = 'http://vialineperu.com:8080/schedule-0.0.1-SNAPSHOT';
  final dio = Dio();
  final cookieJar = CookieJar();

  Api() {
    dio.interceptors.add(CookieManager(cookieJar));
  }

  Future<SignUpResponse> signUp(String email, String password, String passwordConfirm, {String name}) async {
    final response = await dio.post(
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
    );

    return SignUpResponse(response.statusCode, response.data);
  }

  Future<LoginResponse> login(String email, String password) async {
    final response = await dio.post(
        '$API/user/signin',
        options: Options(
          followRedirects: false,
          contentType: Headers.formUrlEncodedContentType,
          validateStatus: (status) => status < 500,
        ),
        data: {
          'email': email,
          'password': password
        }
    );

    return LoginResponse(response.statusCode);
  }

  Future<String> home() async {
    final response = await dio.get('$API/home');
    return response.data.toString();
  }

  logout() => dio.get('$API/user/signout');

}

//=====================================================================

class ApiResponse {
  final int status;

  ApiResponse(this.status);

  bool isSuccessful() => status == 200;
}

class LoginResponse extends ApiResponse {
  String msg;

  LoginResponse(int status) : super(status) {
    switch (status) {
      case 200: msg = "login successful";
        break;
      case 401: msg = 'invalid credentials';
        break;
      default: msg = 'an error ocurred';
    }
  }
}

class SignUpResponse extends ApiResponse {
  String msg;

  SignUpResponse(int status, dynamic data) : super(status) {
    switch (status) {
      case 201: msg = "signed up successfully"; break;
      case 400: {
        msg = 'try again: ${data['error']}';
        break;
      }
      default: msg = 'an error ocurred $status: ${data['error']}';
    }
  }

  @override
  bool isSuccessful() => status == 201;
}

