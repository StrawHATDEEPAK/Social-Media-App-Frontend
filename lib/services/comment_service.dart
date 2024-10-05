import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foxxi/http_error_handle.dart';
import 'package:foxxi/models/comments.dart';
import 'package:foxxi/services/notification_service.dart';
import 'package:foxxi/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

import 'package:foxxi/env.dart';

const _storage = FlutterSecureStorage();
NotificationService notificationService = NotificationService();

class CommentService {
  Future<List<Comment>> getCommentByPostId(
      {required BuildContext context,
      required String id,
      String? parentId,
      bool? isReply}) async {
    List<Comment> comments = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$url/api/post/$id'),
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            final data = jsonDecode(res.body)['comments'];
            dev.log(jsonEncode(data), name: 'Comments List');

            for (var comment in data) {
              comments.add(Comment.fromJson(jsonEncode(comment)));
            }
          });
    } catch (e) {
      dev.log(e.toString(), name: 'Comment By Id Error');
      showSnackBar(context, e.toString());
    }
    return comments;
  }

  Future<int> addComment(
      {required BuildContext context,
      required String postId,
      required String caption}) async {
    int statusCode = 0;
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http.post(Uri.parse('$url/api/comments/create'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          },
          body: jsonEncode({'postId': postId, 'caption': caption}));
      if (context.mounted) {
        httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              statusCode = res.statusCode;
              showSnackBar(context, "Comment Added");
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'CommentService : Create Comment Error');
    }
    return statusCode;
  }

  Future<int> addCommentReply(
      {required BuildContext context,
      required String postId,
      required String caption,
      required bool isReply,
      required String parentId}) async {
    int statusCode = 0;
    try {
      dev.log('comment reply service called');
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http.post(Uri.parse('$url/api/comments/reply'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          },
          body: jsonEncode({
            'postId': postId,
            'caption': caption,
            'parentId': parentId,
            'isReply': isReply
          }));

      dev.log(res.statusCode.toString());

      if (context.mounted) {
        httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              statusCode = res.statusCode;
              dev.log('comment reply added');
              showSnackBar(context, "Reply Added");
            });
      }
    } catch (e) {
      dev.log(e.toString(),
          name: 'CommentService : Create Comment Reply Error');
    }
    return statusCode;
  }

  Future<int> deleteComment(
      {required BuildContext context, required String id}) async {
    int statusCode = 0;
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http.delete(
        Uri.parse('$url/api/comments/delete/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'cookies': foxxijwt
        },
      );
      if (context.mounted) {
        httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              statusCode = res.statusCode;
              showSnackBar(context, 'Comment Deleted ');
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'CommentService : Delete Comment Error');
    }
    return statusCode;
  }

  Future<int> updateComment(
      {required BuildContext context,
      required String id,
      required String caption}) async {
    int statusCode = 0;
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http.post(Uri.parse('$url/api/comments/update'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          },
          body: jsonEncode({'id': id, 'caption': caption}));
      if (context.mounted) {
        httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              statusCode = res.statusCode;
              dev.log('Comment Updated');
              showSnackBar(context, 'Comment Updated!');
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'CommentService : Update Comment Error');
    }
    return statusCode;
  }
}
