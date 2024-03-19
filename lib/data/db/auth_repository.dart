import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const String _tokenKey = 'token';
  static const String _userName = 'username';
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> login(String token, String username) async {
    await sharedPreferences.setString(_tokenKey, token);
    await sharedPreferences.setString(_userName, username);
  }

  Future<bool> isLoggedin() async {
    final token = sharedPreferences.getString(_tokenKey);
    return token != null;
  }

  Future<void> logout() async {
    await sharedPreferences.remove(_tokenKey);
    await sharedPreferences.remove(_userName);
  }

  Future<String?> getToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  Future<String?> getUserName() async {
    return sharedPreferences.getString(_userName);
  }
}
