import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/result_state.dart';
import '../data/api/api_services.dart';
import '../data/model/story_list.dart';

class StoryListProvider extends ChangeNotifier {
  final ApiServices apiService;

  StoryListProvider({required this.apiService});

  ResultState _state = ResultState.noData;
  String _message = '';
  late StoryList _storyList;

  ResultState get state => _state;
  String get message => _message;
  StoryList get storyList => _storyList;

  Future<dynamic> fetchStoryList(String token) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final storyList = await apiService.getStoryList(http.Client(), token);
      if (storyList.error) {
        _state = ResultState.error;
        _message = storyList.message;
      } else {
        _state = ResultState.hasData;
        _storyList = storyList;
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
