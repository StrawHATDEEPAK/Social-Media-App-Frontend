// import 'dart:js_util';
import 'package:foxxi/env.dart';
import 'package:foxxi/providers/theme_provider.dart';
import 'package:foxxi/utils.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:foxxi/models/news.dart';
import 'package:foxxi/widgets/news_card.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

// void _getData(String? query) async {
//     _news = (await ApiService().getNews(query));
//     Future.delayed(const Duration(seconds: 5)).then((value) => setState(() {}));
//   }

class NewsScreen extends StatefulWidget {
  SwipeableCardSectionController cardController =
      SwipeableCardSectionController();

  NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

// Future<void> testing() async {
//   var queryParameters = {
//     'q': 'Tesla',
//   };
//   var headers = {'x-api-key': 'fwoKTG51ZvcZrGlaZYinW4Nhdp36YUQLfFibRMCwuI4'};
//   var url = Uri.https('api.newscatcherapi.com', '/v2/search', queryParameters);
//   var response = await http.get(url, headers: headers);

//   if (response.statusCode == 200) {
//     final jsonResponse = convert.jsonDecode(response.body);
//     print('$jsonResponse');
//   } else {
//     print('Reponse error with code ${response.statusCode}');
//   }
// }

class ApiService {
  Future<News?> getNews(String? query) async {
    var queryParameters = {
      'q': query,
      'lang': 'en',
    };
    var headers = {'x-api-key': newsCatcherApi};
    var url =
        Uri.https('api.newscatcherapi.com', '/v2/search', queryParameters);
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      News? news = newsFromJson(response.body);

      return news;
    } else {
      debugPrint('Reponse error with code ${response.statusCode}');
    }
    return null;
  }
}

class _NewsScreenState extends State<NewsScreen> {
  String? query = 'trending';
  late Future<News?> _news;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _news = ApiService().getNews(query);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    Colors.lightBlue.shade100.withOpacity(0.2),
                    Colors.purpleAccent.shade100.withOpacity(0.2),
                  ]
                : [
                    Colors.lightBlue.shade100.withOpacity(0.9),
                    Colors.purpleAccent.shade100.withOpacity(0.9),
                  ],
          ),
        ),
        child: FutureBuilder<News?>(
          future: _news,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return Row(
                children: [
                  SwipeableCardsSection(
                    cardController: widget.cardController,
                    context: context,
                    items: [
                      NewsCard(
                        title: snapshot.data!.articles[0].title,
                        photo: snapshot.data!.articles[0].media,
                        description: snapshot.data!.articles[0].summary,
                      ),
                      NewsCard(
                        title: snapshot.data!.articles[1].title,
                        photo: snapshot.data!.articles[1].media,
                        description: snapshot.data!.articles[1].summary,
                      ),
                      NewsCard(
                        title: snapshot.data!.articles[2].title,
                        photo: snapshot.data!.articles[2].media,
                        description: snapshot.data!.articles[2].summary,
                      ),
                    ],
                    onCardSwiped: (dir, index, wid) {
                      widget.cardController.addItem(
                        NewsCard(
                          title: snapshot.data!.articles[index + 3].title,
                          photo: snapshot.data!.articles[index + 3].media,
                          description:
                              snapshot.data!.articles[index + 3].summary,
                        ),
                      );
                    },
                    enableSwipeUp: true,
                    enableSwipeDown: true,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Center(
              child: CustomLoader(),
            );
          }),
        ),
      ),
    );
  }
}
