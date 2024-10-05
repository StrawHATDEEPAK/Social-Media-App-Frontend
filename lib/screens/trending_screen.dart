import 'package:flutter/material.dart';
import 'package:foxxi/models/feed_post_model.dart';
import 'package:foxxi/providers/theme_provider.dart';
import 'package:foxxi/routing_constants.dart';
import 'package:foxxi/services/post_service.dart';
import 'package:foxxi/utils.dart';
import 'package:foxxi/widgets/feed_post_card.dart';
import 'dart:developer' as dev;

import 'package:provider/provider.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});
  static const String routeName = trendingScreenRoute;
  @override
  State<TrendingScreen> createState() => _FoxxiTrendScreenState();
}

class _FoxxiTrendScreenState extends State<TrendingScreen> {
  Future<List<FeedPostModel>>? postList;
  PostService postService = PostService();
  @override
  void initState() {
    super.initState();
    postList = postService.getTrendingPosts(context: context);
  }

  @override
  Widget build(BuildContext context) {
            final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
                  backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,

      appBar: AppBar(title: const Text('Trending')),
      body: Column(
        children: [
          FutureBuilder<List<FeedPostModel>?>(
            future: postList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                dev.log(snapshot.data!.toString(), name: 'Snapshot Data');
                return Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data?.length == null
                            ? 0
                            : snapshot.data!.length,
                        itemBuilder: (context, index) => FeedCard(
                              post: snapshot.data![index],
                              isImage: snapshot.data![index].media?.mediatype ==
                                      'image'
                                  ? true
                                  : false,
                              isVideo: snapshot.data![index].media?.mediatype ==
                                      'video'
                                  ? true
                                  : false,
                            )));
              } else {
                return const Center(
                  child: CustomLoader(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
