// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:foxxi/models/user.dart';

class Comment {
  final String id;
  final String caption;
  final User author;
  final String postId;
  final bool isReply;
  final String parentId;
  Comment({
    required this.id,
    required this.caption,
    required this.author,
    required this.postId,
    required this.isReply,
    required this.parentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caption': caption,
      'author': author.toMap(),
      'postId': postId,
      'isReply': isReply,
      'parentId': parentId,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      caption: map['caption'] ?? '',
      author: User.fromMap(map['author']),
      postId: map['postId'] ?? '',
      isReply: map['isReply'],
      parentId: map['parentId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));
}
