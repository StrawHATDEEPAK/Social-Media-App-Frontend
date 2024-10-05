import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:foxxi/models/story.dart';
import 'package:foxxi/providers/user_provider.dart';
import 'package:foxxi/screens/story_screen.dart';
import 'package:foxxi/services/story_service.dart';

// import '../screen/post_story.dart';
import '../providers/theme_provider.dart';
import '../utils.dart';
import 'add_story.dart';

class StoryBar extends StatefulWidget {
  const StoryBar({super.key});

  @override
  State<StoryBar> createState() => _StoryBarState();
}

class _StoryBarState extends State<StoryBar> with TickerProviderStateMixin {
  StoryService storyService = StoryService();
  List<dynamic>? usernameList;
  List<List<Story>?> listOfStories = [];

  /// Init
  @override
  void initState() {
    super.initState();
    getFollowingUserStories();
  }

  void getFollowingUserStories() {
    usernameList =
        Provider.of<UserProvider>(context, listen: false).user.following;
    if (usernameList != null) {
      for (var username in usernameList!) {
        dev.log(username['username'].toString());
        storyService
            .getUserStory(context: context, username: username['username'])
            ?.then((value) {
          dev.log(value.toString(), name: 'Story Value');
          if (value.isNotEmpty) {
            setState(() {
              listOfStories.add(value);
            });
          }
          dev.log(listOfStories.toString(), name: 'List of Stories');
        });
      }
    } else {
      dev.log(
        'usernameList is Null',
      );
    }
  }

  /// Dispose
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    final userProvider = Provider.of<UserProvider>(context, listen: true).user;

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        // color: Colors.grey.withOpacity(0.30),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // decoration: BoxDecoration(border: Border.all()),
              padding: const EdgeInsets.only(left: 7),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Card(
                          elevation: 20,
                          shape: const CircleBorder(),
                          // clipBehavior: Clip.antiAlias,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              // decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),),
                              color: Colors.white,
                              child: GestureDetector(
                                onTap: (() {
                                  showMaterialModalBottomSheet(
                                      backgroundColor: isDark
                                          ? Colors.grey.shade900
                                          : Colors.grey.shade100,
                                      elevation: 2,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(30))),
                                      context: context,
                                      builder: (context) => SizedBox(
                                              child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 20),
                                                child: Text(
                                                  'Add Story',
                                                  style: TextStyle(
                                                      color: isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontFamily:
                                                          'InstagramSans',
                                                      fontSize: 20),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          30)),
                                                          border: Border.all(
                                                            width: 5,
                                                            color: const Color(
                                                                    0xffff4e00)
                                                                .withOpacity(
                                                                    0.4),
                                                          )),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      const AddStory(
                                                                          isImage:
                                                                              true),
                                                                ),
                                                              );
                                                            },
                                                            icon: Icon(
                                                              Icons.photo,
                                                              color: Colors
                                                                  .lightBlue
                                                                  .shade100,
                                                              size: 35,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Image',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'InstagramSans',
                                                                color: isDark
                                                                    ? Colors
                                                                        .grey
                                                                        .shade100
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          30)),
                                                          border: Border.all(
                                                            width: 5,
                                                            color: const Color(
                                                                    0xffff4e00)
                                                                .withOpacity(
                                                                    0.4),
                                                          )),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      const AddStory(
                                                                          isImage:
                                                                              false),
                                                                ),
                                                              );
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .video_collection_rounded,
                                                              color: Colors
                                                                  .lightBlue
                                                                  .shade100,
                                                              size: 35,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Video',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'InstagramSans',
                                                                color: isDark
                                                                    ? Colors
                                                                        .grey
                                                                        .shade100
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )));
                                }),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    userProvider.image.toString(),
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const SizedBox(
                                      width: 50,
                                      height: 50,
                                    ),
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                color: Colors.blue, shape: BoxShape.circle),
                            child: const Text(
                              "+",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Your Story',
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ),
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: listOfStories.isEmpty ? 0 : listOfStories.length,
                  itemBuilder: (context, index) {
                    return Container(
                      // decoration: BoxDecoration(border: Border.all()),
                      padding: const EdgeInsets.all(3),
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              // padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xffff4e00).withOpacity(0.4),
                                    const Color(0xffec9f05).withOpacity(0.4),
                                  ],
                                  stops: const [0, 1],
                                  begin: const AlignmentDirectional(1, 0),
                                  end: const AlignmentDirectional(-1, 0),
                                  // color: Colors.purpleAccent.shade100.withOpacity(
                                  // 0.3,
                                ),
                              ),
                              child: InkWell(
                                onTap: (() async {
                                  setState(() {
                                    listOfStories[index]![0].isSeen = true;
                                  });

                                  if (listOfStories.isNotEmpty) {
                                    if (context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => StoryScreen(
                                                  stories:
                                                      listOfStories[index]!,
                                                )),
                                      );
                                    }
                                  }
                                }),
                                child: Card(
                                  elevation: 20,
                                  shape: const CircleBorder(),
                                  // clipBehavior: Clip.antiAlias,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),),
                                      color: Colors.white,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          listOfStories[index]![0].author.image,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return const Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: CustomLoader(),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Center(
                                                child: Icon(
                                              Icons.image,
                                              size: 100,
                                            ));
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  listOfStories[index]![0].author.username),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}

class StoryPage extends StatelessWidget {
  final int? index;
  final String? storyImage;
  final String? profileImage;
  final String? userName;
  const StoryPage(
      {super.key,
      this.index,
      this.userName,
      this.storyImage,
      this.profileImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  profileImage.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    userName.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: const Text(
                    "2023 Jan 23",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.network(
            storyImage.toString(),
            // fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
