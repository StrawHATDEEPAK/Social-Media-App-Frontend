import 'dart:convert';

import 'package:foxxi/models/media.dart';
import 'package:foxxi/models/user.dart';

import 'comments.dart';

class Post {
  final String caption;
  final User? author;
  final List<String>? hashtags;
  final List<User>? likes;
  final List<Comment>? comments;

  final int? reposts;
  final Media? media;
  final String? gifLink;
  final String? twitterId;
  final List<String>? reports;
  final String? originalPostId;
  Post({
    required this.caption,
    this.author,
    this.hashtags,
    this.likes,
    this.comments,
    this.reposts,
    this.media,
    this.gifLink,
    this.twitterId,
    this.reports,
    this.originalPostId,
  });

  Map<String, dynamic> toMap() {
    return {
      'caption': caption,
      'author': author!.toMap(),
      'hashtags': hashtags,
      'likes': likes?.map((x) => x.toMap()).toList() ?? [],
      'comments': comments?.map((x) => x.toMap()).toList() ?? [],
      'reposts': reposts,
      'media': media?.toMap(),
      'gifLink': gifLink,
      'twitterId': twitterId,
      'reports': reports ?? [],
      'originalPostId': originalPostId,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      caption: map['caption'] ?? '',
      author: User.fromMap(map['author']),
      hashtags:
          map['hashtags'] == null ? [] : List<String>.from(map['hashtags']),
      likes: map['likes'] != null
          ? List<User>.from(map['likes']?.map((x) => User.fromMap(x)))
          : [],
      comments: map['comments'] != null
          ? List<Comment>.from(map['comments']?.map((x) => Comment.fromMap(x)))
          : [],
      reposts: map['reposts']?.toInt() ?? 0,
      media: map['media'] != null ? Media.fromMap(map['media']) : null,
      gifLink: map['gifLink'],
      twitterId: map['twitterId'] ?? '',
      reports: map['reports'] == null ? [] : List<String>.from(map['reports']),
      originalPostId: map['originalPostId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));
}


  // factory Post.fromMap(Map<String, dynamic> map) {
  //   return Post(
  //     caption: map['caption'] ?? '',
  //     author: User.fromMap(map['author']),
  //     hashtags:
  //         map['hashtags'] == null ? [] : List<String>.from(map['hashtags']),
  //     comments: map['comments'] == null
  //         ? []
  //         : List<Comment>.from(map['comments'].map((x) => Comment.fromMap(x))),
  //     likes: map['likes'] == null
  //         ? []
  //         : List<User>.from(map['likes'].map((x) => User.fromMap(x))),
  //     reposts: map['reposts'] ?? 0,
  //     media: Media.fromMap(map['media']),
  //     gifLink: map['gifLink'],
  //     twitterId: map['twitterId'] ?? '',
  //     reports: map['reports'] == null ? [] : List<String>.from(map['reports']),
  //     originalPostId: map['originalPostId'] ?? '',
  //   );
  // }