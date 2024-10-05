import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foxxi/models/user.dart';
import 'package:foxxi/utils.dart';
import 'package:http/http.dart' as http;
import 'package:foxxi/env.dart';
import 'dart:convert';
import 'package:foxxi/http_error_handle.dart';

import '../models/story.dart';

class StoryService {
  final _storage = const FlutterSecureStorage();

  void createStories(
      {required BuildContext context,
      required String caption,
      String? imageFilePath,
      String? videoFilePath}) async {
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      Map<String, String> header = {'cookies': foxxijwt};

      final request =
          http.MultipartRequest('POST', Uri.parse('$url/api/story/create'));
      request.headers.addAll(header);
      request.fields['caption'] = caption;

      if (imageFilePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath('media', imageFilePath),
        );
      }
      if (videoFilePath != null) {
        request.files
            .add(await http.MultipartFile.fromPath('media', videoFilePath));
      }
      final res = await request.send();
      if (res.statusCode == 201) {
        dev.log('Story Created Successfully ', name: 'Story Create Status');
        if (context.mounted) {
          showSnackBar(context, 'Story Created');
        }
      }
      if (res.statusCode == 500) {
        dev.log('Story Upload Error', name: 'Story Create Error');
      }
    } catch (e) {
      dev.log(e.toString(), name: 'Story Service : Create Story Error');
    }
  }

  Future<List<User>?> getFollowingUserWithStories(
      {required BuildContext context}) async {
    List<User> userWitStoryList = [];
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http.get(Uri.parse('$url/api/story/getstories'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          });
      dev.log(res.body.toString(), name: 'User with story');
      dev.log('story service called');
      if (context.mounted) {
        httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              final data = jsonDecode(res.body);

              for (var users in data) {
                userWitStoryList.add(
                  User.fromJson(
                    jsonEncode(users),
                  ),
                );
              }
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'StoryService - Get Following User Error');
    }
    return userWitStoryList;
  }

  Future<List<Story>>? getUserStory(
      {required BuildContext context, required String username}) async {
    List<Story> userStoryList = [];
    try {
      final res = await http.get(Uri.parse('$url/api/story/$username'));

      if (context.mounted) {
        httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              dev.log(res.body.toString(), name: 'Getusers log');
              final data = jsonDecode(res.body);
              for (var stories in data) {
                userStoryList.add(Story.fromJson(jsonEncode(stories)));
              }
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'Story Service : getusers Error');
    }
    return userStoryList;
  }
}
