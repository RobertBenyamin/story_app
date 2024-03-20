import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/data/model/user.dart';
import 'package:story_app/utils/result_state.dart';
import 'package:story_app/data/db/auth_repository.dart';

import '../data/api/api_services.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository authRepository;
  final ApiServices apiService;

  late LoginResult _loginResult;
  ResultState _state = ResultState.noData;
  String _message = '';
  bool _isLoggedIn = false;

  LoginResult get loginResult => _loginResult;
  ResultState get state => _state;
  String get message => _message;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider({required this.authRepository, required this.apiService}) {
    fetchLoginStatus();
  }

  Future<void> fetchLoginStatus() async {
    _isLoggedIn = await authRepository.isLoggedin();
    notifyListeners();
  }

  Future<dynamic> register(String name, String email, String password) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final response =
          await apiService.register(http.Client(), name, email, password);
      if (response.error) {
        _state = ResultState.error;
        _message = response.message;
      } else {
        _state = ResultState.hasData;
        _message = response.message;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Register failed';
    }
    fetchLoginStatus();
  }

  Future<dynamic> login(String email, String password) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final user = await apiService.login(http.Client(), email, password);
      if (user.error) {
        _state = ResultState.error;
        _message = user.message;
      } else {
        _loginResult = user.loginResult;
        await authRepository.login(_loginResult.token, _loginResult.name);
        _state = ResultState.hasData;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Login failed';
    }
    fetchLoginStatus();
  }

  Future<void> logout() async {
    await authRepository.logout();
    fetchLoginStatus();
  }
}
