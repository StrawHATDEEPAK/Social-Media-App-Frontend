import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:foxxi/models/feed_post_model.dart';
import 'package:foxxi/models/user.dart';
import 'package:foxxi/providers/theme_provider.dart';
import 'package:foxxi/providers/user_provider.dart';
import 'package:foxxi/screens/profile_screen.dart';
import 'package:foxxi/services/post_service.dart';
import 'package:foxxi/services/user_service.dart';
import 'package:foxxi/utils.dart';
import 'package:foxxi/widgets/feed_post_card.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  PostService postService = PostService();

  UserService userService = UserService();
  Future<List<FeedPostModel>?>? postList;
  Future<List<User>?>? listOfUsers;

  final TextEditingController _searchBarTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context, listen: true).isDarkMode;
    final userProvider = Provider.of<UserProvider>(context).user;
    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: AnimSearchBar(
                      width: MediaQuery.of(context).size.width - 30,
                      textController: _searchBarTextController,
                      onSuffixTap: () {
                        if (_searchBarTextController.text.isNotEmpty) {
                          setState(() {
                            _searchBarTextController.clear();
                          });
                        }
                      },
                      onSubmitted: (searchWord) {
                        setState(() {
                          if (searchWord.startsWith('@')) {
                            postList = null;
                            listOfUsers = userService.searchUser(
                                context: context,
                                searchWord: searchWord.replaceFirst('@', ''));
                          } else if (searchWord.startsWith('#')) {
                            listOfUsers = null;
                            postList = postService.searchPost(
                                context: context,
                                searchWord: searchWord.replaceFirst('#', ''));
                          } else {
                            postList = null;
                            listOfUsers = userService.searchUser(
                                context: context, searchWord: searchWord);
                          }
                        });
                      }),
                ),
              ],
            ),
            postList != null
                ? FutureBuilder<List<FeedPostModel>?>(
                    future: postList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data?.length == null
                                ? 0
                                : snapshot.data!.length,
                            itemBuilder: (context, index) => FeedCard(
                                post: snapshot.data![index],
                                isImage:
                                    snapshot.data![index].media?.mediatype ==
                                            'image'
                                        ? true
                                        : false,
                                isVideo:
                                    snapshot.data![index].media?.mediatype ==
                                            'video'
                                        ? true
                                        : false),
                          ),
                        );
                      } else {
                        return const Center(
                          child: CustomLoader(),
                        );
                      }
                    },
                  )
                : listOfUsers != null
                    ? FutureBuilder<List<User>?>(
                        future: listOfUsers,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data?.length == null
                                    ? 0
                                    : snapshot.data!.length,
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileWidget(
                                              isMe: snapshot.data![index]
                                                          .username ==
                                                      userProvider.name
                                                  ? true
                                                  : false,
                                              username: snapshot
                                                  .data![index].username),
                                        ));
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            snapshot.data![index].image)),
                                    title: Text(
                                      snapshot.data![index].name,
                                      style: TextStyle(color:isDark?Colors.white:Colors.grey.shade900),
                                    ),
                                    subtitle: Text(
                                      '@${snapshot.data![index].username}',style: TextStyle(color: isDark?Colors.grey.shade500:Colors.grey.shade400),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CustomLoader(),
                            );
                          }
                        },
                      )
                    : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
