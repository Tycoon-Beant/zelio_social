import 'package:dio/dio.dart';
import 'package:zelio_social/services/dio_exceptions.dart';
import 'package:zelio_social/services/dio_instance.dart';
import 'package:zelio_social/social/auth/model/login_model.dart';

class SignupServices {
  SignupServices();

  Future<User> postSignup(
      {required String username,
      required String email,
      required String password}) async {
    try {
      final response = await DioSingleton.instance.dio.post('users/register', data: {
        "email": email,
        "password": password,
        "role": "USER",
        "username": username
      });
      final body = response.data;
      return User.fromJson(body["data"]);
    } on DioException catch (e) {
      print("signup error : $e");
      throw DioExceptions.fromDioError(e);
    }
  }
}
