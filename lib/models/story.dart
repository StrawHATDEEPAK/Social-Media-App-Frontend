import 'dart:convert';

import 'package:foxxi/models/media.dart';
import 'package:foxxi/models/user.dart';

class Story {
  final String id;
  final String caption;
  final User author;
  final Media? media;
  bool? isSeen;
  Story({
    required this.id,
    required this.caption,
    required this.author,
    this.media,
    this.isSeen = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caption': caption,
      'author': author.toMap(),
      'media': media?.toMap(),
      'isSeen': isSeen,
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      id: map['id'] ?? '',
      caption: map['caption'] ?? '',
      author: User.fromMap(map['author']),
      media: map['media'] != null ? Media.fromMap(map['media']) : null,
      isSeen: map['isSeen'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Story.fromJson(String source) => Story.fromMap(json.decode(source));
}
