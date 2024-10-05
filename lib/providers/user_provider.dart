import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foxxi/models/user.dart';
import 'package:foxxi/services/user_service.dart';

final userService = UserService();

class UserProvider with ChangeNotifier {
  User _user = User(
      id: '',
      email: '',
      username: '',
      name: '',
      password: '',
      walletAddress: '',
      hasClaimed: false,
      image: '',
      coverImage: '',
      bio: '',
      followers: [],
      following: [],
      hashtagsfollowed: [],
      posts: [],
      twitterUsername: '',
      accountWallet: '',
      reports: [],
      preferences: [],
      isBanned: false,
      stories: false);

  User get user => _user;

  void setUser(String userData) {
    final data = jsonDecode(userData);
    _user = User.fromJson((jsonEncode(data)));

    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
