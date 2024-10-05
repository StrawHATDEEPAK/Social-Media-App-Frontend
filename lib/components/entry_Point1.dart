// import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:foxxi/providers/theme_provider.dart';
import 'package:foxxi/providers/user_provider.dart';
import 'package:foxxi/screens/chatbot_screen.dart';
import 'package:foxxi/screens/news_screen.dart';
import 'package:foxxi/services/auth_service.dart';
import 'package:foxxi/services/message_service.dart';
import 'package:foxxi/services/notification_service.dart';
import 'package:foxxi/services/story_service.dart';
import 'package:foxxi/services/user_service.dart';
// import 'package:flutter_svg/flutter_svg.dart';

import 'package:foxxi/widgets/add_post.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:foxxi/routing_constants.dart';

import '../services/post_service.dart';
import 'models/bottom_bar_item_model.dart';
import 'notch_bottom_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    super.key,
  });
  static const String routeName = bottomNavBarScreenRoute;
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  String? userId;
  final _pageController = PageController(initialPage: 0);
  AuthService authService = AuthService();
  PostService postService = PostService();
  StoryService storyService = StoryService();
  MessageService messageService = MessageService();
  UserService userService = UserService();
  NotificationService notificationService = NotificationService();
  int maxCount = 5;
  String id = '';

  /// widget list
  void getData(String id) {
    userService.getCurrentUserData(context: context, id: id);
    postService.getAllPost(context: context);
    // postService.getTrendingPosts(context: context);
    // messageService.getAssociatedUsers(context: context);
  }

  void getUserId() {
    authService.getCurrentUserId(context: context).then((value) {
      setState(() {
        id = value;
      });

      getData(id);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true).user;

    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    final List<Widget> bottomBarPages = [
      const FeedScreen(),
      ProfileWidget(
        username: userProvider.username,
        isMe: true,
      ),
      const SizedBox.shrink(),
      const ChatBotScreen(),
      NewsScreen(),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(bottomBarPages.length, (index) {
          {
            return bottomBarPages[index];
          }
        }),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              pageController: _pageController,
              color: isDark ? Colors.black : Colors.white,
              notchColor: isDark ? Colors.black54 : Colors.white,
              showLabel: false,
              bottomBarItems: [
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_outlined,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home_rounded,
                    color: Colors.blueAccent,
                  ),
                ),

                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.account_circle_outlined,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.account_circle,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 1',
                ),
                BottomBarItem(
                  inActiveItem: IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      showMaterialModalBottomSheet(
                          backgroundColor:
                              isDark ? Colors.grey.shade900 : Colors.white,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25))),
                          context: context,
                          builder: (context) => SizedBox(
                                  child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 20),
                                    child: Text(
                                      'Upload Post',
                                      style: TextStyle(
                                          fontFamily: 'InstagramSans',
                                          fontSize: 20,
                                          color: isDark
                                              ? Colors.grey.shade100
                                              : Colors.black),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(8),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(30)),
                                              border: Border.all(
                                                  width: 5,
                                                  color: const Color(0xffff4e00)
                                                      .withOpacity(0.4))),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddPost(
                                                              IsImage: true),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.photo,
                                                  color:
                                                      Colors.lightBlue.shade100,
                                                  size: 35,
                                                ),
                                              ),
                                              Text(
                                                'Image',
                                                style: TextStyle(
                                                    fontFamily: 'InstagramSans',
                                                    color: isDark
                                                        ? Colors.grey.shade100
                                                        : Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(8),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(30)),
                                              border: Border.all(
                                                  width: 5,
                                                  color: const Color(0xffff4e00)
                                                      .withOpacity(0.4))),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddPost(
                                                              IsImage: false),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons
                                                      .video_collection_rounded,
                                                  color:
                                                      Colors.lightBlue.shade100,
                                                  size: 35,
                                                ),
                                              ),
                                              Text(
                                                'Video',
                                                style: TextStyle(
                                                    fontFamily: 'InstagramSans',
                                                    color: isDark
                                                        ? Colors.grey.shade100
                                                        : Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )));
                    },
                    icon: const Icon(Icons.add),
                    color: Colors.blueGrey,
                  ),
                  activeItem: const Icon(
                    Icons.add,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 1',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.connect_without_contact_outlined,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.connect_without_contact_rounded,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 2',
                ),

                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.newspaper_outlined,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.newspaper_rounded,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 2',
                ),

                ///svg example
                // BottomBarItem(
                //   inActiveItem: SvgPicture.asset(
                //     'assets/search_icon.svg',
                //     color: Colors.blueGrey,
                //   ),
                //   activeItem: SvgPicture.asset(
                //     'assets/search_icon.svg',
                //     color: Colors.white,
                //   ),
                //   itemLabel: 'Page 3',
                // ),
                // const BottomBarItem(
                //   inActiveItem: Icon(
                //     Icons.settings,
                //     color: Colors.blueGrey,
                //   ),
                //   activeItem: Icon(
                //     Icons.settings,
                //     color: Colors.pink,
                //   ),
                //   itemLabel: 'Page 4',
                // ),
                // const BottomBarItem(
                //   inActiveItem: Icon(
                //     Icons.person,
                //     color: Colors.blueGrey,
                //   ),
                //   activeItem: Icon(
                //     Icons.person,
                //     color: Colors.yellow,
                //   ),
                //   itemLabel: 'Page 5',
                // ),
              ],
              onTap: (index) {
                /// control your animation using page controller
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
            )
          : null,
    );
  }
}
