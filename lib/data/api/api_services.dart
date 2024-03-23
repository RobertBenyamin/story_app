import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../model/user.dart';
import '../model/response.dart';
import '../model/story_list.dart';
import '../model/story_detail.dart';

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

  Future<dynamic> register(
      http.Client client, String name, String email, String password) async {
    final response = await client.post(
      Uri.parse('${baseUrl}register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
    return Response.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> getStoryList(http.Client client, String token) async {
    final response = await client.get(
      Uri.parse('${baseUrl}stories'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return StoryList.fromJson(jsonDecode(response.body));
    } else {
      return Response.fromJson(jsonDecode(response.body));
    }
  }

  Future<dynamic> getStoryDetail(
      http.Client client, String token, String id) async {
    final response = await client.get(
      Uri.parse('${baseUrl}stories/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return StoryDetail.fromJson(jsonDecode(response.body));
    } else {
      return Response.fromJson(jsonDecode(response.body));
    }
  }

  Future<Response> addStory(
    String token,
    String description,
    List<int> bytes,
    String fileName,
  ) async {
    final uri = Uri.parse('${baseUrl}stories');
    var request = http.MultipartRequest('POST', uri);

    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );
    final Map<String, String> fields = {
      "description": description,
    };
    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token",
    };

    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 201) {
      return Response.fromJson(jsonDecode(responseData));
    } else {
      throw Exception("Upload file error");
    }
  }
}
