import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foxxi/env.dart';
import 'package:http/http.dart' as http;

import 'package:foxxi/http_error_handle.dart';
import 'package:foxxi/screens/login_screen.dart';
import 'package:foxxi/screens/preference_screen.dart';
import 'package:foxxi/utils.dart';

import '../components/entry_Point1.dart';

const _storage = FlutterSecureStorage();

class AuthService {
  Future<int> signUp({
    required BuildContext context,
    required String username,
    required String name,
    required String password,
    required String email,
  }) async {
    int statusCode = 0;
    try {
      http.Response res = await http.post(Uri.parse('$url/api/users/signup'),
          body: jsonEncode({
            'email': email,
            'password': password,
            'username': username,
            'name': name
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            await _storage.write(
                key: "cookies", value: jsonDecode(res.body)['jwt'].toString());
            dev.log('cookies saved', name: 'JWT');
            statusCode = res.statusCode;
            // ignore: use_build_context_synchronously
            showSnackBar(
              context,
              'Account created!',
            );

            if (context.mounted) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PreferenceScreen(),
                  ));
            }
          });

      if (res.statusCode != 200 || res.statusCode != 201) {
        if (context.mounted) {
          showSnackBar(context, res.body);
        }
      }
    } catch (e) {
      dev.log(e.toString(), name: "SignUpErrorCatch");
      showSnackBar(context, e.toString());
    }
    return statusCode;
  }

  Future<int> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    int statusCode = 0;
    try {
      http.Response res = await http.post(
        Uri.parse('$url/api/users/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          // Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          statusCode = res.statusCode;
          _storage
              .write(
                  key: "cookies", value: jsonDecode(res.body)['jwt'].toString())
              .then((value) {
            if (context.mounted) {
              showSnackBar(context, 'Login Successfull');

              Navigator.pushNamed(
                context,
                BottomNavBar.routeName,
              );
            }
          });
          dev.log(res.body, name: 'login JWT');
        },
      );

      if (res.statusCode == 400) {
        if (context.mounted) {
          showSnackBar(context, 'Invalid Credentials');
        }
      }
    } catch (e) {
      dev.log(e.toString(), name: "LoginInErrorCatch");
    }
    return statusCode;
  }

  void emailVerification({
    required BuildContext context,
    required String email,
  }) async {
    try {
      http.Response res = await http.post(
          Uri.parse('$url/api/verification/generate'),
          body: jsonEncode(
            {'email': email},
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });

      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Verification Code Sent');
          });
    } catch (e) {
      dev.log(e.toString(), name: "Email Verification Error");
      if (context.mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  Future<bool> verifyCodeSent({
    required BuildContext context,
    required String email,
    required String code,
  }) async {
    bool isVerified = false;
    try {
      http.Response res = await http.post(
          Uri.parse('$url/api/verification/compare'),
          body: jsonEncode(
            {'email': email, 'code': code},
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });

      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'OTP Verified');
            isVerified = true;
          });
    } catch (e) {
      dev.log(e.toString(), name: "OTP Verification");
      showSnackBar(context, e.toString());
    }
    return isVerified;
  }

  Future<int> resetPassword(
      {required BuildContext context,
      required String email,
      required String password}) async {
    int statusCode = 0;
    try {
      http.Response res = await http.put(
          Uri.parse('$url/api/users/resetpassword'),
          body: jsonEncode({'email': email, 'password': password}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });

      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            statusCode = res.statusCode;
            showSnackBar(context, 'Password Reset Successfull ');
          });
    } catch (e) {
      dev.log(e.toString(), name: "Reset Password Error Log");
      showSnackBar(context, e.toString());
    }
    return statusCode;
  }

  Future<String> getCurrentUserId({
    required BuildContext context,
  }) async {
    String id = '';
    try {
      var jwt = await _storage.read(key: 'cookies');
      final foxxijwt = 'foxxi_jwt=$jwt;';
      dev.log(foxxijwt, name: "Reading JWT");
      final res = await http.get(Uri.parse('$url/api/users/currentuser'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'cookies': foxxijwt
          });

      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            dev.log('GetCurrentUserCalled');
            dev.log(jsonDecode(res.body)['currentUser']['id'].toString());
            id = jsonDecode(res.body)['currentUser']['id'].toString();
          });
    } catch (e) {
      dev.log(e.toString(), name: 'Get Current User Error');
    }
    return id;
  }

  void signOut({required BuildContext context}) async {
    // more to dos
    try {
      await http.post(Uri.parse('$url/api/users/signout'));
      await _storage.delete(key: 'cookies');
      await _storage.delete(key: 'PRIVATE_KEY');
      dev.log('SIGN OUT');
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginScreen.routeName,
          (route) => false,
        );
      }
    } catch (e) {
      dev.log(e.toString(), name: 'SIGN OUT');
    }
  }
}
