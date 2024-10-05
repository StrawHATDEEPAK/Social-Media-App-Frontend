import 'dart:math';
import 'dart:ui';
import 'package:flutter/src/painting/gradient.dart' as gradient;
import 'package:flutter/material.dart';
import 'package:foxxi/constants.dart';
import 'package:foxxi/models/notification.dart';
import 'package:foxxi/models/story.dart';
import 'package:foxxi/providers/theme_provider.dart';
import 'package:foxxi/routing_constants.dart';
import 'package:foxxi/screens/chat.dart';
import 'package:foxxi/screens/follower_following_screen.dart';
import 'package:foxxi/screens/story_screen.dart';
import 'package:foxxi/services/notification_service.dart';
import 'package:foxxi/services/user_service.dart';
import 'package:foxxi/utils.dart';
import 'package:foxxi/widgets/follow_button.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:foxxi/services/story_service.dart';

import 'package:foxxi/models/user.dart';
import 'package:foxxi/providers/user_provider.dart';
import 'package:foxxi/services/post_service.dart';
import 'dart:developer' as dev;
import '../models/feed_post_model.dart';
import '../widgets/feed_post_card.dart';
import '../widgets/menu_button.dart';
import '../widgets/side_menu.dart';

class ProfileWidget extends StatefulWidget {
  static const String routeName = profileScreenRoute;
  final bool isMe;
  final String username;
  const ProfileWidget({
    Key? key,
    required this.isMe,
    required this.username,
  }) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget>
    with SingleTickerProviderStateMixin {
  bool? showProfileUpdate;
  bool isSideBarOpen = false;
  late SMIBool isMenuOpenInput;
  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;
  Future<List<FeedPostModel>?>? _userPost;
  List<FeedPostModel>? awaitedUserpost;
  final postService = PostService();
  final userService = UserService();
  final storyService = StoryService();
  final notificationService = NotificationService();
  User? user;
  bool? isMeCheck;

  int statusCodeForFollow = 0;
  bool isFollowed = false;
  String followAndUnfollow = 'Unfollow';
  List<Story> listOfStories = [];
  bool storyIcon = false;

  String? choiceChipsValue;
  final _unfocusNode = FocusNode();

  @override
  void dispose() {
    _animationController.dispose();
    _unfocusNode.dispose();
    super.dispose();
  }

  getFollowingUserStories() {
    if (widget.isMe == true || isMeCheck == true) {
      storyService
          .getUserStory(context: context, username: widget.username)
          ?.then((value) {
        // dev.log(value.toString(), name: 'Story Value User');
        if (value.isNotEmpty) {
          storyIcon = true;

          for (var story in value) {
            listOfStories.add(story);
          }
        }
        // dev.log(listOfStories.toString(), name: 'List of Stories : User');
      });
    } else {
      dev.log(
        'usernameList is Null',
      );
    }
  }

  @override
  void initState() {
    getUserData();
    getUserPosts();
    getFollowingUserStories();
    isMeCheck = UserProvider().user.username == widget.username ? true : false;

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(
        () {
          setState(() {});
        },
      );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  Future<void> getUserData() async {
    userService
        .getCurrentUserDatawithUsername(
            context: context, username: widget.username)
        ?.then((value) {
      user = value;
      if (user != null) {
        userService.getCurrentUserData(
            context: context,
            id: Provider.of<UserProvider>(context, listen: false).user.id);
      }
      isFollowedByUser();
    });
    if (mounted) {
      setState(() {});
    }
    return;
  }

  void getUserPosts() async {
    if (awaitedUserpost?.length == null) {
      _userPost = postService.getUserPosts(
          context: context, username: widget.username.toString());

      awaitedUserpost = await _userPost;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void isFollowedByUser() {
    for (var following
        in Provider.of<UserProvider>(context, listen: false).user.following!) {
      if (following['username'] == widget.username) {
        setState(() {
          isFollowed = true;
        });

        break;
      } else {
        setState(() {
          isFollowed = false;
        });
      }
    }

    // dev.log(isFollowed.toString(), name: 'Is User Followed By You ');
  }
// Future<void> refresh (){
//   getUserPosts();
//   isFollowedByUser();

// }
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    final userProvider = Provider.of<UserProvider>(context, listen: true).user;
    isMeCheck = userProvider.username == widget.username ? true : false;

    return RefreshIndicator(
      onRefresh: getUserData,
      child: Scaffold(
        extendBody: false,
        resizeToAvoidBottomInset: false,
        backgroundColor: isDark
            ? Colors.grey.shade900
            : const Color.fromARGB(255, 206, 239, 247),
        body: Stack(
          children: [
            AnimatedPositioned(
              width: 288,
              height: MediaQuery.of(context).size.height,
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              left: isSideBarOpen ? 0 : -288,
              top: 0,
              child: const SideMenu(),
            ),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(
                    1 * animation.value - 30 * (animation.value) * pi / 180),
              child: Transform.translate(
                offset: Offset(animation.value * 265, 0),
                child: Transform.scale(
                  scale: scalAnimation.value,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(24),
                    ),
                    child: GestureDetector(
                      onTap: () =>
                          FocusScope.of(context).requestFocus(_unfocusNode),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await Future.delayed(
                                            const Duration(milliseconds: 1000));
                                      },
                                      child: ClipRRect(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 2,
                                            sigmaY: 2,
                                          ),
                                          child: Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    0, 0),
                                            child: Image.network(
                                              widget.isMe
                                                  ? userProvider.coverImage
                                                      .toString()
                                                  : user == null
                                                      ? ''
                                                      : user!.coverImage
                                                          .toString(),
                                              width: double.infinity,
                                              height: 200,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                } else {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            9),
                                                    child: const CustomLoader(),
                                                  );
                                                }
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Column(
                                                  children: const [
                                                    SizedBox(
                                                      height: 40,
                                                    ),
                                                    Center(
                                                        child: Icon(
                                                      Icons.image,
                                                      size: 100,
                                                    ))
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 150, 0, 0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.grey.shade900
                                              : Colors.grey.shade100,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(0),
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(20, 20, 20, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    // padding: EdgeInsets.all(5),
                                                    decoration: storyIcon
                                                        ? BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            10)),
                                                            gradient: gradient
                                                                .LinearGradient(
                                                              colors: [
                                                                Colors
                                                                    .purpleAccent
                                                                    .shade200
                                                                    .withOpacity(
                                                                        0.7),
                                                                Colors.lightBlue
                                                                    .shade200
                                                                    .withOpacity(
                                                                        0.7),
                                                              ],
                                                              stops: const [
                                                                0,
                                                                1
                                                              ],
                                                              begin:
                                                                  const AlignmentDirectional(
                                                                      1, 0),
                                                              end:
                                                                  const AlignmentDirectional(
                                                                      -1, 0),
                                                              // color: Colors.purpleAccent.shade100.withOpacity(
                                                              // 0.3,
                                                            ),
                                                          )
                                                        : const BoxDecoration(),
                                                    child: GestureDetector(
                                                      onDoubleTap: (() {
                                                        if (widget.isMe ==
                                                                true ||
                                                            isMeCheck == true) {
                                                          if (listOfStories
                                                              .isNotEmpty) {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          StoryScreen(
                                                                            stories:
                                                                                listOfStories,
                                                                          )),
                                                            );
                                                          }
                                                        }
                                                      }),
                                                      child: Card(
                                                        elevation: 20,
                                                        shape:
                                                            const CircleBorder(),
                                                        // clipBehavior: Clip.antiAlias,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),),
                                                            color: Colors.white,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child:
                                                                  Image.network(
                                                                widget.isMe
                                                                    ? userProvider
                                                                        .image
                                                                    : user ==
                                                                            null
                                                                        ? ''
                                                                        : user!
                                                                            .image
                                                                            .toString(),
                                                                width: 50,
                                                                height: 50,
                                                                fit: BoxFit
                                                                    .cover,
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null) {
                                                                    return child;
                                                                  }
                                                                  return const Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            15.0),
                                                                    child:
                                                                        CustomLoader(),
                                                                  );
                                                                },
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return const Center(
                                                                      child: Icon(
                                                                          Icons
                                                                              .image,
                                                                          size:
                                                                              50));
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Stack(
                                                  //   children: [
                                                  //     Container(
                                                  //       width: 70,
                                                  //       height: 70,
                                                  //       clipBehavior:
                                                  //           Clip.antiAlias,
                                                  //       decoration:
                                                  //           const BoxDecoration(
                                                  //         shape: BoxShape.circle,
                                                  //       ),
                                                  //       child: GestureDetector(
                                                  //         onTap: () {
                                                  //           if (UserProvider()
                                                  //                   .user
                                                  //                   .following!
                                                  //                   .contains(widget
                                                  //                       .username) ||
                                                  //               isMeCheck ==
                                                  //                   true) {
                                                  //             if (listOfStories
                                                  //                 .isNotEmpty) {
                                                  //               if (context
                                                  //                   .mounted) {
                                                  //                 Navigator.push(
                                                  //                   context,
                                                  //                   MaterialPageRoute(
                                                  //                       builder:
                                                  //                           (context) =>
                                                  //                               StoryScreen(
                                                  //                                 stories: listOfStories,
                                                  //                               )),
                                                  //                 );
                                                  //               }
                                                  //             }
                                                  //           }
                                                  //           // List<Story> list =
                                                  //         },
                                                  //         child: Image.network(
                                                  //           widget.isMe
                                                  //               ? userProvider
                                                  //                   .image
                                                  //               : user == null
                                                  //                   ? ''
                                                  //                   : user!.image
                                                  //                       .toString(),
                                                  //           loadingBuilder: (context,
                                                  //               child,
                                                  //               loadingProgress) {
                                                  //             if (loadingProgress ==
                                                  //                 null) {
                                                  //               return child;
                                                  //             }
                                                  //             return const Padding(
                                                  //               padding:
                                                  //                   EdgeInsets
                                                  //                       .all(
                                                  //                           15.0),
                                                  //               child:
                                                  //                   CustomLoader(),
                                                  //             );
                                                  //           },
                                                  //           errorBuilder:
                                                  //               (context, error,
                                                  //                   stackTrace) {
                                                  //             return const Center(
                                                  //                 child: Icon(
                                                  //               Icons.image,
                                                  //               size: 100,
                                                  //             ));
                                                  //           },
                                                  //           fit: BoxFit.cover,
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                      5,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              child: Container(
                                                                width: 70,
                                                                height: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: isDark
                                                                      ? Colors
                                                                          .grey
                                                                          .shade600
                                                                      : Colors
                                                                          .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      awaitedUserpost?.length ==
                                                                              null
                                                                          ? '0'
                                                                          : awaitedUserpost!
                                                                              .length
                                                                              .toString(),
                                                                      style: TextStyle(
                                                                          color: isDark
                                                                              ? Colors.white
                                                                              : Colors.black,
                                                                          fontSize: 15),

                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      // style: FlutterFlowTheme
                                                                      //         .of(context)
                                                                      //     .bodyText1,
                                                                    ),
                                                                    Text(
                                                                      'Posts',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: isDark
                                                                              ? Colors.white
                                                                              : Colors.black,
                                                                          fontSize: 12),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => FollowerFollowingScreen(
                                                                          isMe: widget
                                                                              .isMe,
                                                                          username: user == null
                                                                              ? ''
                                                                              : user!.username),
                                                                    ));
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                        5,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child:
                                                                    Container(
                                                                  width: 70,
                                                                  height: 50,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: isDark
                                                                        ? Colors
                                                                            .grey
                                                                            .shade600
                                                                        : Colors
                                                                            .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        widget.isMe
                                                                            ? userProvider.followers!.isEmpty
                                                                                ? '0'
                                                                                : userProvider.followers!.length.toString()
                                                                            : user == null
                                                                                ? ''
                                                                                : user!.followers!.isEmpty
                                                                                    ? '0'
                                                                                    : user!.followers!.length.toString(),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            color: isDark
                                                                                ? Colors.white
                                                                                : Colors.black,
                                                                            fontSize: 15),
                                                                      ),
                                                                      Text(
                                                                        'Followers',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            color: isDark
                                                                                ? Colors.white
                                                                                : Colors.black,
                                                                            fontSize: 12),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => FollowerFollowingScreen(
                                                                          isMe: widget
                                                                              .isMe,
                                                                          username: user == null
                                                                              ? ''
                                                                              : user!.username),
                                                                    ));
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                        5,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child:
                                                                    Container(
                                                                  width: 70,
                                                                  height: 50,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: isDark
                                                                        ? Colors
                                                                            .grey
                                                                            .shade600
                                                                        : Colors
                                                                            .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        widget.isMe
                                                                            ? userProvider.following!.isEmpty
                                                                                ? '0'
                                                                                : userProvider.following!.length.toString()
                                                                            : user == null
                                                                                ? ''
                                                                                : user!.following!.isEmpty
                                                                                    ? '0'
                                                                                    : user!.following!.length.toString(),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color: isDark
                                                                              ? Colors.white
                                                                              : Colors.black,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        'Following',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            color: isDark
                                                                                ? Colors.white
                                                                                : Colors.black,
                                                                            fontSize: 12),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              20, 20, 20, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            widget.isMe
                                                                ? userProvider
                                                                    .name
                                                                    .toString()
                                                                : user == null
                                                                    ? ''
                                                                    : user!.name
                                                                        .toString(),
                                                            style: TextStyle(
                                                                color: isDark
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        5,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Icon(
                                                              Icons
                                                                  .verified_rounded,
                                                              size: 16,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              20, 0, 20, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            widget.isMe
                                                                ? '@${userProvider.username}'
                                                                : user == null
                                                                    ? ''
                                                                    : '@${user!.username}'
                                                                        .toString(),
                                                            style: TextStyle(
                                                                color: isDark
                                                                    ? Colors
                                                                        .grey
                                                                        .shade300
                                                                    : Colors
                                                                        .grey
                                                                        .shade700,
                                                                fontFamily:
                                                                    'InstagramSans'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                isMeCheck == true
                                                    ? const SizedBox()
                                                    : ElevatedButton(
                                                        child:
                                                            const Text('Chat'),
                                                        onPressed: () {
                                                          if (user != null) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => OneOneChatScreen(
                                                                      senderId:
                                                                          user!
                                                                              .id,
                                                                      senderUsername:
                                                                          user!
                                                                              .username),
                                                                ));
                                                          }
                                                        },
                                                      ),
                                                isMeCheck == true
                                                    ? const SizedBox()
                                                    : Padding(
                                                        padding: EdgeInsets.only(
                                                            right: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                7),
                                                        child: ElevatedButton(
                                                          child: isFollowed
                                                              ? const Text(
                                                                  'Unfollow')
                                                              : const Text(
                                                                  'Follow'),
                                                          onPressed: () {
                                                            userService
                                                                .followUser(
                                                                    context:
                                                                        context,
                                                                    username: user!
                                                                        .username)
                                                                .then((value) {
                                                              if (mounted) {
                                                                setState(() {
                                                                  isFollowed =
                                                                      !isFollowed;
                                                                });

                                                                if (value ==
                                                                    201) {
                                                                  dev.log(NotificationType
                                                                      .USER_FOLLOW
                                                                      .name);
                                                                  notificationService.addNotification(
                                                                      context:
                                                                          context,
                                                                      notification: NotificationModel(
                                                                          notification:
                                                                              'followed you',
                                                                          notificationType: NotificationType
                                                                              .USER_FOLLOW
                                                                              .name,
                                                                          userId: user!
                                                                              .id,
                                                                          username:
                                                                              userProvider.username));
                                                                }
                                                              }
                                                              userService
                                                                  .getCurrentUserData(
                                                                      context:
                                                                          context,
                                                                      id: userProvider
                                                                          .id);
                                                            });
                                                          },
                                                        ),
                                                        // child: FollowButton(
                                                        //   backgroundColor:
                                                        //       Colors.white,
                                                        //   borderColor: Colors.white,
                                                        //   textColor: Colors.black,
                                                        //   function: () {
                                                        //     userService
                                                        //         .followUser(
                                                        //             context:
                                                        //                 context,
                                                        //             username: user!
                                                        //                 .username)
                                                        //         .then((value) {
                                                        //       if (mounted) {
                                                        //         setState(() {});
                                                        //       }
                                                        //       userService
                                                        //           .getCurrentUserData(
                                                        //               context:
                                                        //                   context,
                                                        //               id: userProvider
                                                        //                   .id);
                                                        //     });
                                                        //   },
                                                        //   isFollowed: isFollowed,
                                                        // ),
                                                      ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(20, 10, 20, 25),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    widget.isMe
                                                        ? userProvider.bio
                                                            .toString()
                                                        : user == null
                                                            ? ''
                                                            : user!.bio
                                                                .toString(),
                                                    style: TextStyle(
                                                        color: isDark
                                                            ? Colors
                                                                .grey.shade500
                                                            : Colors
                                                                .grey.shade800,
                                                        fontFamily:
                                                            'Instagram'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            FutureBuilder<List<FeedPostModel>?>(
                                              future: _userPost,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            10, 10, 10, 50),
                                                    child: ListView.builder(
                                                      physics: isSideBarOpen
                                                          ? const AlwaysScrollableScrollPhysics()
                                                          : const ScrollPhysics(),
                                                      primary: false,
                                                      padding: EdgeInsets.zero,
                                                      reverse: true,
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          snapshot.data!.length,
                                                      itemBuilder:
                                                          ((context, index) {
                                                        return FeedCard(
                                                          post: snapshot
                                                              .data![index],
                                                          isImage: snapshot
                                                                      .data![
                                                                          index]
                                                                      .media
                                                                      ?.mediatype ==
                                                                  'image'
                                                              ? true
                                                              : false,
                                                          isVideo: snapshot
                                                                      .data![
                                                                          index]
                                                                      .media
                                                                      ?.mediatype ==
                                                                  'video'
                                                              ? true
                                                              : false,
                                                        );
                                                      }),
                                                    ),
                                                  );
                                                } else {
                                                  return const Center(
                                                      child: CustomLoader());
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              left: isSideBarOpen ? 220 : 0,
              top: 16,
              child: MenuBtn(
                press: () {
                  isMenuOpenInput.value = !isMenuOpenInput.value;

                  if (_animationController.value == 0) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }

                  setState(
                    () {
                      isSideBarOpen = !isSideBarOpen;
                    },
                  );
                },
                riveOnInit: (artboard) {
                  final controller = StateMachineController.fromArtboard(
                      artboard, "State Machine");

                  artboard.addController(controller!);

                  isMenuOpenInput =
                      controller.findInput<bool>("isOpen") as SMIBool;
                  isMenuOpenInput.value = true;
                },
              ),
            ),
          ],
        ),
        // bottomNavigationBar: Transform.translate(
        //   offset: Offset(0, 100 * animation.value),
        //   child: SafeArea(
        //     child: Container(
        //       padding:
        //           const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 12),
        //       margin: const EdgeInsets.symmetric(horizontal: 24),
        //       decoration: BoxDecoration(
        //         gradient: gradient.LinearGradient(
        //           colors: [
        //             Colors.lightBlue.shade700.withOpacity(0.4),
        //             Colors.purpleAccent.shade700.withOpacity(0.4),
        //           ],
        //           stops: [0, 1],
        //           begin: AlignmentDirectional(1, 0),
        //           end: AlignmentDirectional(-1, 0),
        //           // color: Colors.purpleAccent.shade100.withOpacity(
        //           // 0.3,
        //         ),
        //         // color: Colors.lightBlue.withOpacity(0.8),
        //         borderRadius: const BorderRadius.all(Radius.circular(24)),
        //         boxShadow: const [
        //           BoxShadow(
        //             color: Colors.lightBlue,
        //             offset: const Offset(0, 20),
        //             blurRadius: 20,
        //           ),
        //         ],
        //       ),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           ...List.generate(
        //             bottomNavItems.length,
        //             (index) {
        //               Menu navBar = bottomNavItems[index];
        //               return BtmNavItem(
        //                 navBar: navBar,
        //                 press: () {
        //                   RiveUtils.changeSMIBoolState(navBar.rive.status!);
        //                   updateSelectedBtmNav(navBar);
        //                 },
        //                 riveOnInit: (artboard) {
        //                   navBar.rive.status = RiveUtils.getRiveInput(artboard,
        //                       stateMachineName: navBar.rive.stateMachineName);
        //                 },
        //                 selectedNav: selectedBottonNav,
        //               );
        //             },
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        // bottomNavigationBar: AnimatedNotchBottomBar(
        //   pageController: _pageController,
        //   bottomBarItems: [
        //     const BottomBarItem(
        //       inActiveItem: Icon(
        //         Icons.home_filled,
        //         color: Colors.blueGrey,
        //       ),
        //       activeItem: Icon(
        //         Icons.home_filled,
        //         color: Colors.blueAccent,
        //       ),
        //       itemLabel: 'Page 1',
        //     ),
        //     const BottomBarItem(
        //       inActiveItem: Icon(
        //         Icons.star,
        //         color: Colors.blueGrey,
        //       ),
        //       activeItem: Icon(
        //         Icons.star,
        //         color: Colors.blueAccent,
        //       ),
        //       itemLabel: 'Page 2',
        //     ),
        //   ],
        //   onTap: (int value) {
        //     _pageController.animateToPage(
        //       value,
        //       duration: const Duration(milliseconds: 500),
        //       curve: Curves.easeIn,
        //     );
        //   },

        ///svg item
        // ),
      ),
    );
  }
}
