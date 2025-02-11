import 'package:dio/dio.dart';
import 'package:zelio_social/services/dio_exceptions.dart';
import 'package:zelio_social/services/dio_instance.dart';
import 'package:zelio_social/services/local_storage_service.dart';
import 'package:zelio_social/services/token_service.dart';
import 'package:zelio_social/social/auth/model/login_model.dart';

class LoginServices {
final LocalStorageService _localStorageService;
  LoginServices(this._localStorageService);

  Future<Loginuser> postLogin(
      {required String username,
      required String password}) async {
    try {
      final response = await DioSingleton.instance.dio.post('users/login', data: {
        "password": password,
        "username": username
      });
      final body = response.data;
      final content = body["data"];
      final user = User.fromJson(content["user"]);
      TokenService.instance.setToken(TokenModel.fromMap(content));
     await _localStorageService.saveUser(user);
      return Loginuser.fromJson(body["data"]);
    } on DioException catch (e) {
      print("login error: $e");
      throw DioExceptions.fromDioError(e);
    }
  }

  void logoutUser() {
    _localStorageService.clearSession();
    TokenService.instance.clearToken();
  }
}