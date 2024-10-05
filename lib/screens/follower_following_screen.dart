import 'package:flutter/material.dart';
import 'package:foxxi/screens/followers_screen.dart';
import 'package:foxxi/screens/following_screen.dart';
import 'package:foxxi/services/user_service.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class FollowerFollowingScreen extends StatefulWidget {
  final String username;

  final bool isMe;
  const FollowerFollowingScreen(
      {super.key, required this.isMe, required this.username});
  @override
  State<FollowerFollowingScreen> createState() =>
      _FollowerFollowingScreenState();
}

class _FollowerFollowingScreenState extends State<FollowerFollowingScreen> {
  final controller = PageController(
    initialPage: 0,
  );
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.purpleAccent.shade100.withOpacity(0.4),
              child: IconButton(
                // iconSize: 20,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  // size: 15,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          backgroundColor: isDark ? Colors.black : Colors.white,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Followers',
                  style: TextStyle(
                      color: isDark ? Colors.white : Colors.grey.shade900),
                ),
                Text(
                  'Following',
                  style: TextStyle(
                      color: isDark ? Colors.white : Colors.grey.shade900),
                )
              ],
            ),
            Expanded(
              child: PageView(
                controller: controller,
                pageSnapping: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  FollowerScreen(
                    isMe: widget.isMe,
                    username: widget.username,
                  ),
                  FollowingScreen(username: widget.username, isMe: widget.isMe)
                ],
              ),
            ),
          ],
        ));
  }
}
