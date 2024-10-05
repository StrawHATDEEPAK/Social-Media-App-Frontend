import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:foxxi/constants.dart';
import 'package:foxxi/models/notification.dart';
import 'package:foxxi/screens/profile_screen.dart';
import 'package:foxxi/services/user_service.dart';
import 'package:foxxi/utils.dart';
import 'package:foxxi/widgets/follow_button.dart';
import 'package:provider/provider.dart';

import 'package:foxxi/models/user.dart';
import 'package:foxxi/providers/user_provider.dart';

import '../providers/theme_provider.dart';

class FollowerScreen extends StatefulWidget {
  final String username;
  final bool isMe;
  const FollowerScreen({
    Key? key,
    required this.username,
    required this.isMe,
  }) : super(key: key);

  @override
  State<FollowerScreen> createState() => _FollowerScreenState();
}

class _FollowerScreenState extends State<FollowerScreen> {
  User? user;

  UserService userService = UserService();
  List<bool> isFollowed = [];
  void getUserData() {
    userService
        .getCurrentUserDatawithUsername(
            context: context, username: widget.username)
        ?.then((value) {
      user = value;
      setBoollistLeng();
    });
    setState(() {});
  }

  void setBoollistLeng() {
    if (user?.followers?.length != null) {
      // ignore: unused_local_variable
      for (var i in user!.followers!) {
        isFollowed.add(false);
      }
      dev.log(isFollowed.toString());
    }
    updateBoolList();
  }

  void updateBoolList() {
    int index = 0;
    if (Provider.of<UserProvider>(context, listen: false).user.following !=
        null) {
      dev.log('Finding isFollowed');
      if (user?.followers != null) {
        for (var user in user!.followers!) {
          for (var users in Provider.of<UserProvider>(context, listen: false)
              .user
              .following!) {
            if (user['id'] == users['id']) {
              setState(() {
                isFollowed[index] = true;
              });
              dev.log('found');
              break;
            } else {
              setState(() {
                isFollowed[index] = false;
              });
            }
          }
          index++;
        }
      }
    }
    dev.log(isFollowed.toString());
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    final userProvider = Provider.of<UserProvider>(context, listen: true).user;

    if (user?.followers != null) {
      dev.log(user!.followers.toString());
      return ListView.builder(
        itemCount: user?.followers?.length ?? 0,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileWidget(
                      isMe: false,
                      username: user?.followers![index]['username']),
                ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(user?.followers![index]['image'])),
                  title: Text(user?.followers![index]['name'],style: TextStyle(color: isDark?Colors.white:Colors.black),),
                  subtitle: Text('@${user?.followers![index]['username']}',style: TextStyle(color: isDark?Colors.grey.shade400:Colors.grey.shade600),),
                ),
              ),
              userProvider.username == user!.followers![index]['username']
                  ? Container()
                  : FollowButton(
                      isFollowed: isFollowed[index],
                      backgroundColor: Colors.white,
                      borderColor: Colors.white,
                      textColor: Colors.black,
                      function: () {
                        setState(() {});
                        userService
                            .followUser(
                                context: context,
                                username: user!.followers![index]['username'])
                            .then((value) {
                          if (value == 201) {
                            setState(() {
                              isFollowed[index] = true;
                            });

                            dev.log(NotificationType.USER_FOLLOW.name);
                            notificationService.addNotification(
                                context: context,
                                notification: NotificationModel(
                                    notification: 'followed you',
                                    notificationType:
                                        NotificationType.USER_FOLLOW.name,
                                    userId: userProvider.id,
                                    username: user!.username));
                          }

                          if (value == 200) {
                            setState(() {
                              isFollowed[index] = false;
                            });

                            userService.getCurrentUserData(
                                context: context, id: userProvider.id);
                          }
                        });
                      }),
            ],
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
