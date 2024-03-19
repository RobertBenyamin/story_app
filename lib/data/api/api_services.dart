import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/response.dart';
import '../model/user.dart';

class ApiServices {
  static const String baseUrl = 'https://story-api.dicoding.dev/v1/';

  Future<dynamic> login(
      http.Client client, String email, String password) async {
    final response = await client.post(
      Uri.parse('${baseUrl}login'),
      body: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      return Response.fromJson(jsonDecode(response.body));
    }
  }
}