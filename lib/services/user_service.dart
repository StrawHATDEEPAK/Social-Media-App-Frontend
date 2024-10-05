import 'dart:convert';
import 'dart:developer' as dev;
import 'package:foxxi/http_error_handle.dart';
import 'package:foxxi/models/user.dart';
import 'package:foxxi/providers/user_provider.dart';
import 'package:foxxi/services/notification_service.dart';
import 'package:foxxi/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foxxi/env.dart';
import 'package:provider/provider.dart';

const _storage = FlutterSecureStorage();
NotificationService notificationService = NotificationService();

class UserService {
  void getCurrentUserData(
      {required BuildContext context, required String id}) async {
    try {
      http.Response res = await http.get(
          Uri.parse('$url/api/users/otheruser/id/$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      // dev.log(res.body.toString(), name: 'UserDAta');

      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              Provider.of<UserProvider>(context, listen: false)
                  .setUser(res.body);
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'GetUserDataError');
    }
  }

  Future<User?>? getCurrentUserDatawithUsername(
      {required BuildContext context, required String username}) async {
    dynamic user;
    try {
      http.Response res = await http.get(
          Uri.parse('$url/api/users/otheruser/$username'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      // dev.log(res.body.toString(), name: 'UserDAta by using username');
      dev.log(username, name: 'UserService = username');
      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              user = User.fromJson(res.body);
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'GetUserDataError - username');
    }
    return user;
  }

  Future<int> followUser(
      {required BuildContext context, required String username}) async {
    int statusCode = 0;
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      final res = await http.put(Uri.parse('$url/api/follow/users'),
          body: jsonEncode({'username': username}),
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
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'UserService: UserFollow Error');
    }
    return statusCode;
  }

  Future<List<User>?>? searchUser(
      {required BuildContext context, required String searchWord}) async {
    List<User>? listOfUsers = [];
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http.get(
          Uri.parse('$url/api/users/search/$searchWord'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          });
      if (context.mounted) {
        httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              // dev.log(searchWord, name: 'SearchWord');
              dev.log(res.body.toString(), name: 'User Search Log');
              final data = jsonDecode(res.body);
              if (data != null) {
                for (var users in data) {
                  listOfUsers.add(User.fromJson(jsonEncode(users)));
                }
              }
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'user Service : Search User Error');
    }
    return listOfUsers;
  }

  void updateProfileImage(
      {required BuildContext context, required String image}) async {
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      final res = await http.put(Uri.parse('$url/api/users/imageupdate'),
          body: jsonEncode({'image': image}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          });

      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              showSnackBar(context, 'Profile Pic Updated');
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'UserService: Update Profile Pic Error');
    }
  }

  Future<int> updateProfile(
      {required BuildContext context,
      String? imagePath,
      String? coverImagePath,
      String? username,
      String? name,
      String? bio,
      String? walletAddress}) async {
    int statusCode = 0;
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      Map<String, String> header = {'cookies': foxxijwt};

      final request =
          http.MultipartRequest('PUT', Uri.parse('$url/api/users/update'));
      request.headers.addAll(header);
      if (username != null) {
        request.fields['username'] = username;
      }
      if (name != null) {
        request.fields['name'] = name;
      }
      if (bio != null) {
        dev.log('Bio Update', name: 'Profile Update: Request');

        request.fields['bio'] = bio;
      }
      if (walletAddress != null) {
        request.fields['walletAddress'] = walletAddress;
      }

      if (imagePath != null) {
        dev.log('Image Update', name: 'Profile Update: Request');
        request.files.add(
          await http.MultipartFile.fromPath('image', imagePath),
        );
        if (coverImagePath != null) {
          request.files.add(
              await http.MultipartFile.fromPath('coverImage', coverImagePath));
        }
      }
      final res = await request.send();

      dev.log(res.toString(), name: 'Profile Update');
      if (res.statusCode == 200) {
        statusCode = res.statusCode;
        dev.log('Profile Updated ', name: 'Profile Status');
      }
      if (res.statusCode == 500) {
        dev.log('Profile Update Error', name: 'Profile Update Error');
      }
    } catch (e) {
      dev.log(e.toString(), name: 'UserService: Update Profile  Error');
    }
    return statusCode;
  }

  Future<int> addPreferences(
      {required BuildContext context,
      required List<String> preferences}) async {
    int stattusCode = 0;
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      final res = await http.put(Uri.parse('$url/api/preferences/add'),
          body: jsonEncode(preferences),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          });

      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              stattusCode = res.statusCode;
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'Preference Add Error');
      showSnackBar(context, e.toString());
    }
    return stattusCode;
  }

  Future<int> updatePassword({
    required BuildContext context,
    required String oldPassword,
    required String newPassword,
  }) async {
    int statusCode = 0;
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      final res = await http.put(Uri.parse('$url/api/users/updatepassword'),
          body: jsonEncode(
              {'oldPassword': oldPassword, 'newPassword': newPassword}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          });

      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              showSnackBar(context, 'Password Updated ');
              statusCode = 0;
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'Update Password Error');
      showSnackBar(context, e.toString());
    }
    return statusCode;
  }

  void reportUser({
    required String id,
    required BuildContext context,
  }) async {
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      http.Response res = await http.put(Uri.parse('$url/api/users/report'),
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
              dev.log('User $id Reported');
              showSnackBar(context, 'User Reported');
            });
      }
    } catch (e) {
      dev.log(e.toString(), name: 'User Service : Report User Error');
    }
  }

  void requestAirdrop(
      {required BuildContext context,
      required String email,
      required String walletAddress,
      String? message}) async {
    try {
      http.Response res = await http.post(Uri.parse('$url/api/airdrop/request'),
          body: jsonEncode({
            'email': email,
            'walletAddress': walletAddress,
            'message': message
          }));

      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              showSnackBar(context,
                  'Airdrop request sent. You will soon receive the foxxi tokens.');
            });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      dev.log(e.toString(), name: 'User Service - AirDrop Request Error');
    }
  }
}
