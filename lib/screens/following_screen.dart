import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:foxxi/screens/profile_screen.dart';
import 'package:foxxi/services/user_service.dart';
import 'package:foxxi/utils.dart';
import 'package:provider/provider.dart';

import 'package:foxxi/models/user.dart';
import 'package:foxxi/providers/user_provider.dart';

class FollowingScreen extends StatefulWidget {
  final String username;
  final bool isMe;
  const FollowingScreen({
    Key? key,
    required this.username,
    required this.isMe,
  }) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowerScreenState();
}

class _FollowerScreenState extends State<FollowingScreen> {
  User? user;
  var userData;
  UserService userService = UserService();
  void getUserData() async {
    if (widget.isMe == false) {
      user = await userService.getCurrentUserDatawithUsername(
          context: context, username: widget.username);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true).user;

    if (widget.isMe) {
      setState(() {
        userData = userProvider;
      });
    } else {
      setState(() {
        userData = user;
      });
    }
    if (userData?.following != null) {
      dev.log(userData.following.toString());
      return ListView.builder(
        itemCount: userData?.following?.length ?? 0,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileWidget(
                      isMe: false,
                      username: userData?.following[index]['username']),
                ));
          },
          child: ListTile(
            leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(userData?.following[index]['image'])),
            title: Text(userData?.following[index]['name']),
            subtitle: Text('@${userData?.following[index]['username']}'),
          ),
        ),
      );
    } else {
      return const Center(
        child: CustomLoader(),
      );
    }
  }
}
