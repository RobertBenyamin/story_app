import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/utils/result_state.dart';
import 'package:story_app/data/db/auth_repository.dart';

import '../data/api/api_services.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository authRepository;
  final ApiServices apiService;

  ResultState _state = ResultState.noData;
  String _message = '';
  bool _isLoggedIn = false;
  late String _userName;
  late String _userId;
  late String _token;

  ResultState get state => _state;
  String get message => _message;
  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userId => _userId;
  String get token => _token;

  AuthProvider({required this.authRepository, required this.apiService}) {
    fetchLoginStatus();
  }

  void resetState() {
    _state = ResultState.noData;
    _message = '';
    notifyListeners();
  }

  Future<void> fetchLoginStatus() async {
    _isLoggedIn = await authRepository.isLoggedin();
    _userName = await authRepository.getUserName() ?? '';
    _userId = await authRepository.getUserId() ?? '';
    _token = await authRepository.getToken() ?? '';
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
        await authRepository.login(user.loginResult.name,
            user.loginResult.userId, user.loginResult.token);
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
