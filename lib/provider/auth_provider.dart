import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/data/model/user.dart';
import 'package:story_app/utils/result_state.dart';

import '../data/api/api_services.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository authRepository;
  final ApiServices apiService;

  late LoginResult _loginResult;
  late ResultState _state;
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
