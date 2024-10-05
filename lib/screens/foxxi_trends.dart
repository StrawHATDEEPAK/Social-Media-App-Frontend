import 'package:flutter/material.dart';
import 'package:foxxi/models/foxxi_trends_post_model.dart';
import 'package:foxxi/providers/theme_provider.dart';
import 'package:foxxi/routing_constants.dart';
import 'package:foxxi/services/post_service.dart';
import 'package:foxxi/utils.dart';
import 'package:foxxi/widgets/foxxi_trends_card.dart';
import 'dart:developer' as dev;

import 'package:provider/provider.dart';

class FoxxiTrendScreen extends StatefulWidget {
  const FoxxiTrendScreen({super.key});
  static const String routeName = foxxiTrendsScreenRoute;
  @override
  State<FoxxiTrendScreen> createState() => _FoxxiTrendScreenState();
}

class _FoxxiTrendScreenState extends State<FoxxiTrendScreen> {
  Future<List<FoxxiTrendsPost>>? postList;
  PostService postService = PostService();
  @override
  void initState() {
    super.initState();
    postList = postService.getTwitterTrends(context: context);
  }

  @override
  Widget build(BuildContext context) {
                final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
                        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,

      body: Column(
        children: [
          FutureBuilder<List<FoxxiTrendsPost>?>(
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
                      itemBuilder: (context, index) => FoxxiTrendCard(
                          caption: snapshot.data![index].text,
                          createdAt: snapshot.data![index].createdAt)),
                );
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
