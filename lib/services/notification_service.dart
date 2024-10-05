import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foxxi/env.dart';
import 'package:foxxi/http_error_handle.dart';
import 'package:foxxi/models/notification.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

const _storage = FlutterSecureStorage();

class NotificationService {
  void addNotification(
      {required BuildContext context,
      required NotificationModel notification}) async {
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      final res = await http.post(Uri.parse('$url/api/notification/create'),
          body: notification.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          });

      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              dev.log('Notification Added !');
            });
      }
    } catch (e) {
      dev.log(e.toString(),
          name: 'NotificationService - Add NotificationError');
    }
  }

  Future<int> deleteNotification({
    required BuildContext context,
  }) async {
    int statusCode = 0;
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      final res = await http.delete(Uri.parse('$url/api/notification/delete'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          });

      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              statusCode = res.statusCode;
              dev.log('Notification Deleted!');
            });
      }
    } catch (e) {
      dev.log(e.toString(),
          name: 'NotificationService - Delete NotificationError');
    }
    return statusCode;
  }

  Future<List<NotificationModel>> getNotification({
    required BuildContext context,
  }) async {
    List<NotificationModel> notificationList = [];
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      final res = await http.get(Uri.parse('$url/api/notification/get'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          });

      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              final data = jsonDecode(res.body)['data'];
              dev.log(jsonEncode(data), name: 'NotificationData');

              for (var notification in data) {
                notificationList
                    .add(NotificationModel.fromJson(jsonEncode(notification)));
              }
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'NotificationService -Get NotificationError');
    }
    return notificationList;
  }
}
