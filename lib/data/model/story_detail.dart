import 'dart:convert';

import 'story.dart';

StoryDetail storyDetailFromJson(String str) =>
    StoryDetail.fromJson(json.decode(str));

String storyDetailToJson(StoryDetail data) => json.encode(data.toJson());

class StoryDetail {
  bool error;
  String message;
  Story story;

  StoryDetail({
    required this.error,
    required this.message,
    required this.story,
  });

  factory StoryDetail.fromJson(Map<String, dynamic> json) => StoryDetail(
        error: json["error"],
        message: json["message"],
        story: Story.fromJson(json["story"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "story": story.toJson(),
      };
}
