import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/result_state.dart';
import '../data/api/api_services.dart';
import '../data/model/story_detail.dart';

class StoryDetailProvider extends ChangeNotifier {
  final ApiServices apiService;

  StoryDetailProvider({required this.apiService});

  ResultState _state = ResultState.noData;
  String _message = '';
  late StoryDetail _storyDetail;

  ResultState get state => _state;
  String get message => _message;
  StoryDetail get storyDetail => _storyDetail;

  Future<dynamic> fetchStoryDetail(String token, String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final storyDetail =
          await apiService.getStoryDetail(http.Client(), token, id);
      if (storyDetail.error) {
        _state = ResultState.error;
        _message = storyDetail.message;
      } else {
        _state = ResultState.hasData;
        _storyDetail = storyDetail;
      }
    } on SocketException {
      _state = ResultState.error;
      _message = 'No Internet Connection';
    } catch (e) {
      _state = ResultState.error;
      _message = 'Failed to load data';
    }
    notifyListeners();
  }
}
