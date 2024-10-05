import 'dart:convert';

class FoxxiTrendsPost {
  final String text;
  final String createdAt;
  FoxxiTrendsPost({
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'createdAt': createdAt,
    };
  }

  factory FoxxiTrendsPost.fromMap(Map<String, dynamic> map) {
    return FoxxiTrendsPost(
      text: map['text'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FoxxiTrendsPost.fromJson(String source) =>
      FoxxiTrendsPost.fromMap(json.decode(source));
}
