import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const String _userName = 'username';
  static const String _userId = 'userId';
  static const String _tokenKey = 'token';
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> login(String username, String userId, String token) async {
    await sharedPreferences.setString(_userName, username);
    await sharedPreferences.setString(_userId, token);
    await sharedPreferences.setString(_tokenKey, token);
  }

  Future<bool> isLoggedin() async {
    final token = sharedPreferences.getString(_tokenKey);
    return token != null;
  }

  Future<void> logout() async {
    await sharedPreferences.remove(_userName);
    await sharedPreferences.remove(_userId);
    await sharedPreferences.remove(_tokenKey);
  }

  Future<String?> getToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  Future<String?> getUserName() async {
    return sharedPreferences.getString(_userName);
  }

  Future<String?> getUserId() async {
    return sharedPreferences.getString(_userId);
  }
}
