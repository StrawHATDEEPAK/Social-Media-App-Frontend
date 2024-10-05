import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:foxxi/env.dart';
import 'package:foxxi/http_error_handle.dart';
import 'package:foxxi/models/comments.dart';
import 'package:foxxi/models/feed_post_model.dart';
import 'package:foxxi/models/foxxi_trends_post_model.dart';
import 'package:foxxi/services/notification_service.dart';
import 'package:foxxi/utils.dart';

const _storage = FlutterSecureStorage();
final NotificationService notificationService = NotificationService();

class PostService {
  Future<List<FeedPostModel>> getAllPost(
      {required BuildContext context}) async {
    List<FeedPostModel> list = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$url/api/posts'),
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            // dev.log(res.body.toString(), name: 'Post Res Body');

            final data = jsonDecode(res.body);
            for (var post in data) {
              list.add(FeedPostModel.fromJson(jsonEncode((post))));
            }
            // list = (data as List)
            //     .map((i) => FeedPostModel.fromJson(i.toString()))
            //     .toList();
          });
    } catch (e) {
      dev.log(e.toString(), name: 'Get All Post Error');
      if (context.mounted) {
        showSnackBar(context, e.toString());
      }
    }
    return list;
  }

  Future<List<Comment>> getReplyComments(
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

  Future<List<FeedPostModel>> getTrendingPosts(
      {required BuildContext context}) async {
    List<FeedPostModel> trendingPostList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$url/api/posts/trending'),
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            final data = jsonDecode(res.body);
            for (var posts in data) {
              trendingPostList.add(FeedPostModel.fromJson(jsonEncode(posts)));
            }
          });

      // ignore: use_build_context_synchronously
    } catch (e) {
      dev.log(e.toString(), name: 'Get All Post Error');
      showSnackBar(context, e.toString());
    }
    return trendingPostList;
  }

  Future<List<FeedPostModel>> getUserFeed(
      {required BuildContext context}) async {
    List<FeedPostModel> userFeedList = [];
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http.get(
          Uri.parse('$url/api/users/currentuser'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          });

      if (context.mounted) {
        httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              dev.log(res.body.toString(), name: 'User Feed data');
              final data = jsonDecode(res.body)['currentUser'];

              for (var posts in data) {
                userFeedList.add(FeedPostModel.fromJson(jsonEncode(posts)));
              }
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'PostService - Get UserFeed Error');
    }
    return userFeedList;
  }

  Future<List<FeedPostModel>?> getUserPosts(
      {required BuildContext context, required String username}) async {
    List<FeedPostModel> userFeedList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$url/api/posts/$username'),
      );

      if (context.mounted) {
        httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              dev.log(res.body.toString(), name: 'User Post');
              final data = jsonDecode(res.body);

              for (var posts in data) {
                userFeedList.add(FeedPostModel.fromJson(jsonEncode(posts)));
              }
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'PostService - Get UserPost Error');
    }
    return userFeedList;
  }

  Future<List<FeedPostModel>> getPostByPreference(
      {required BuildContext context}) async {
    List<FeedPostModel> preferencePostList = [];
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http.post(Uri.parse('$url/api/post/preference'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          });

      if (context.mounted) {
        httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              final data = jsonDecode(res.body);
              preferencePostList = (data as List)
                  .map((i) => FeedPostModel.fromJson(jsonEncode(i)))
                  .toList();
            });
      }
    } catch (e) {
      dev.log(e.toString(),
          name: 'Post Service : Get Post By Preference Error');
    }
    return preferencePostList;
  }

  Future<List<FoxxiTrendsPost>> getTwitterTrends(
      {required BuildContext context}) async {
    List<FoxxiTrendsPost> twittertrendsList = [];
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http.get(Uri.parse('$url/api/tweets/trending'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          });

      if (context.mounted) {
        httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              final data = jsonDecode(res.body);
              dev.log(data.toString(), name: 'Twitter Trends');
              for (var posts in data) {
                twittertrendsList
                    .add(FoxxiTrendsPost.fromJson(jsonEncode(posts)));
              }
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'Post Service : TwitterTrends Error');
    }

    return twittertrendsList;
  }

  Future<FeedPostModel?> getPostById(
      {required BuildContext context, required String id}) async {
    FeedPostModel? post;
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http.get(Uri.parse('$url/api/post/$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          });
      if (context.mounted) {
        httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              dev.log(res.body.toString(), name: 'Post Search Log');
              final data = jsonDecode(res.body);
              if (data != null) {
                post = FeedPostModel.fromJson(jsonEncode(data));
              }
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'Post Service - Get Post By Id');
    }
    return post;
  }

  Future<List<FeedPostModel>?> searchPost({
    required BuildContext context,
    required String searchWord,
  }) async {
    List<FeedPostModel> postList = [];
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http.get(
          Uri.parse('$url/api/post/search/$searchWord'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          });
      if (context.mounted) {
        httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              dev.log(res.body.toString(), name: 'Post Search Log');
              final data = jsonDecode(res.body);
              if (data != null) {
                for (var posts in data) {
                  postList.add(FeedPostModel.fromJson(jsonEncode(posts)));
                }
              }
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'Post Service : Search Post Error');
    }
    return postList;
  }

  Future<int> createPost({
    required BuildContext context,
    required String caption,
    String? imageFilePath,
    String? videoFilePath,
  }) async {
    int statusCode = 0;
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      Map<String, String> header = {'cookies': foxxijwt};

      final request =
          http.MultipartRequest('POST', Uri.parse('$url/api/posts/create'));
      request.headers.addAll(header);
      request.fields['caption'] = caption;

      if (imageFilePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath('media', imageFilePath),
        );
      }

      if (videoFilePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath('media', videoFilePath),
        );
      }

      final res = await request.send();

      if (res.statusCode == 201) {
        statusCode = 201;
        if (context.mounted) {
          showSnackBar(context, 'Post Uploaded');
        }
        dev.log('Post Uploaded! ', name: 'Create Post Successfull');
      }
      if (res.statusCode == 500) {
        statusCode = 500;
        dev.log('Post Upload Error', name: 'Create Post: Error');
      }
    } catch (e) {
      dev.log(e.toString(), name: 'Post Service : Create Post Error');
    }
    return statusCode;
  }

  Future<int> deletePost({
    required BuildContext context,
    required String id,
  }) async {
    int statusCode = 0;
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http.delete(
          Uri.parse('$url/api/posts/delete/$id'),
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
              dev.log('Post Deleted id:$id', name: 'Post Service: Delete Post');

              showSnackBar(context, 'Post Deleted');
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'Post Service : Delete Post Error');
    }
    return statusCode;
  }

  Future<int> reportPost({
    required String id,
    required BuildContext context,
  }) async {
    int statusCode = 0;
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http.put(Uri.parse('$url/api/posts/report'),
          body: jsonEncode({'postId': id}),
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
              dev.log('Post $id Reported');
              showSnackBar(context, 'Post Reported');
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'Post Service : Report Post Error');
    }
    return statusCode;
  }

  Future<int> updatePost({
    required BuildContext context,
    required String id,
    required String caption,
    required List<String> hashtags,
  }) async {
    int statusCode = 0;
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http.put(Uri.parse('$url/api/posts/edit/$id'),
          body: jsonEncode({
            'caption': caption,
            'hashtags': hashtags,
          }),
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
              showSnackBar(context, 'Post Updated ');
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'Post Service : Update Post Error');
    }
    return statusCode;
  }

  Future<int> likePost({
    required BuildContext context,
    required String id,
  }) async {
    int statusCode = 0;
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http.put(Uri.parse('$url/api/like'),
          body: jsonEncode({'id': id}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          });

      if (context.mounted) {
        httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              dev.log('Post liked id:$id', name: 'Post Service: Like Post');
              statusCode = res.statusCode;
              // dev.log(res.body.toString());
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'Post Service : Like Post Error');
    }
    return statusCode;
  }

  Future<int> repostPost({
    required BuildContext context,
    required String id,
  }) async {
    int statusCode = 0;
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      final res = await http.post(Uri.parse('$url/api/reposts/create'),
          body: jsonEncode({'postId': id}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          });

      if (context.mounted) {
        httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              statusCode = res.statusCode;
              dev.log('Post Repost id:$id', name: 'Post Service: Repost Post');
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'Post Service : Repost Post Error');
    }
    return statusCode;
  }

  void importUserTweets({required BuildContext context}) async {
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http
          .post(Uri.parse('$url/api/tweets'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'cookies': foxxijwt,
      });
      if (context.mounted) {
        httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              showSnackBar(context,
                  'Imported Tweets From Twitter Account Successfully!');
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'Post Service : Import User Tweets Error');
    }
  }
}
