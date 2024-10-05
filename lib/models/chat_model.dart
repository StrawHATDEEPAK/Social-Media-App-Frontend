import 'dart:convert';

class ChatModel {
  final String message;
  final bool fromSelf;
  ChatModel({
    required this.message,
    required this.fromSelf,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'fromSelf': fromSelf,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      message: map['message'] ?? '',
      fromSelf: map['fromSelf'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source));
}
