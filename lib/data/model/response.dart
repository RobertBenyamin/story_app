import 'dart:convert';

Response responseFromJson(String str) => Response.fromJson(json.decode(str));

String responseToJson(Response data) => json.encode(data.toJson());

class Response {
  bool error;
  String message;

  Response({
    required this.error,
    required this.message,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}
