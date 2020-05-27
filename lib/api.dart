
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';


class Api {

  final dio = Dio();
  final cookieJar = CookieJar();
  static const API = 'http://vialineperu.com:8080/schedule-0.0.1-SNAPSHOT';

  Api() {
    dio.interceptors.add(CookieManager(cookieJar));
  }

  Future<Response<dynamic>> login(String email, String password) async {
    print(cookieJar.loadForRequest(Uri.parse('$API/home')));

    return dio.post(
        '$API/user/signin',
        options: Options(
          followRedirects: true,
          contentType: Headers.formUrlEncodedContentType,
          validateStatus: (status) => status < 500,
        ),
        data: {
          'email': email,
          'password': password
        }
    );
  }

  Future<String> home() async {
    final response = await dio.get('$API/home');
    return response.data.toString();
  }
}

final api = Api();

