import 'dart:convert';

import 'story.dart';

StoryList storyListFromJson(String str) => StoryList.fromJson(json.decode(str));

String storyListToJson(StoryList data) => json.encode(data.toJson());

class StoryList {
  bool error;
  String message;
  List<Story> listStory;

  StoryList({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoryList.fromJson(Map<String, dynamic> json) => StoryList(
        error: json["error"],
        message: json["message"],
        listStory:
            List<Story>.from(json["listStory"].map((x) => Story.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "listStory": List<dynamic>.from(listStory.map((x) => x.toJson())),
      };
}
