import 'dart:convert';

import 'package:foxxi/models/user.dart';

import 'media.dart';

class FeedPostModel {
  final String id;
  final String caption;
  final User author;
  final List<String>? hashtags;
  final List<dynamic>? likes;
  final List<dynamic>? comments;
  String createdAt;
  String updatedAt;

  final int reposts;
  final Media? media;
  final String? gifLink;
  final String twitterId;
  final List<String>? reports;
  final String originalPostId;

  FeedPostModel({
    required this.id,
    required this.caption,
    required this.author,
    this.hashtags,
    this.likes,
    this.comments,
    required this.createdAt,
    required this.updatedAt,
    required this.reposts,
    this.media,
    this.gifLink,
    required this.twitterId,
    this.reports,
    required this.originalPostId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caption': caption,
      'author': author.toMap(),
      'hashtags': hashtags,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'reposts': reposts,
      'media': media?.toMap(),
      'gifLink': gifLink,
      'twitterId': twitterId,
      'reports': reports,
      'originalPostId': originalPostId,
    };
  }

  factory FeedPostModel.fromMap(Map<String, dynamic> map) {
    return FeedPostModel(
      id: map['id'] ?? '',
      caption: map['caption'] ?? '',
      author: User.fromMap(map['author']),
      hashtags: List<String>.from(map['hashtags']),
      likes: List<dynamic>.from(map['likes']),
      comments: List<dynamic>.from(map['comments']),
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
      reposts: map['reposts']?.toInt() ?? 0,
      media: map['media'] != null ? Media.fromMap(map['media']) : null,
      gifLink: map['gifLink'],
      twitterId: map['twitterId'] ?? '',
      reports: List<String>.from(map['reports']),
      originalPostId: map['originalPostId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedPostModel.fromJson(String source) =>
      FeedPostModel.fromMap(json.decode(source));
}
