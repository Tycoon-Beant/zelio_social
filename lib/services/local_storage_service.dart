import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../social/auth/model/login_model.dart';

class LocalStorageService {
  final _storage = FlutterSecureStorage();
  final SharedPreferences _pref ;
  LocalStorageService(this._pref);

  Future saveToken(String token) async {
    await _storage.write(key: "token", value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: "token");
  }
  Future<bool> clearSession() async{
    return _pref.clear();
  }

  Future<void> setAddressId(String addressId) async {
  await _pref.setString( "addressId", addressId);
  }

  String? getAddressId()  {
    return _pref.getString("addressId");
  }
  
  Future<void> clearAddress() async{
    await _pref.remove("addressId");
  }

  Future<void> saveUser(User user) async{
    await _pref.setString("user", jsonEncode(user.toJson()));
  }

  User? getUser() {
    final userJson = _pref.getString("user");
    if(userJson != null){
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  
}
