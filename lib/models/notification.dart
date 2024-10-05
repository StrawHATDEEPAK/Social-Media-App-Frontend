import 'dart:convert';

class NotificationModel {
  final String notification;
  final String notificationType;
  final String userId;
  final String? postId;
  final String username;
  NotificationModel({
    required this.notification,
    required this.notificationType,
    required this.userId,
    this.postId,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'notification': notification,
      'notificationType': notificationType,
      'userId': userId,
      'postId': postId,
      'username': username,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notification: map['notification'] ?? '',
      notificationType: map['notificationType'] ?? '',
      userId: map['userId'] ?? '',
      postId: map['postId'],
      username: map['username'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));
}
