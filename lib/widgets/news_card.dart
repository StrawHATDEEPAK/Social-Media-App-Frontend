import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:foxxi/providers/theme_provider.dart';

// ignore: use_key_in_widget_constructors
class NewsCard extends StatefulWidget {
  String? title;
  String? description;
  String? photo;
  NewsCard({
    Key? key,
    this.title,
    this.description,
    this.photo,
  }) : super(key: key);

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.12,
      width: MediaQuery.of(context).size.height * 0.12,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OneFullNewsPage(
                    title: widget.title,
                    description: widget.description,
                    photo: widget.photo,
                  ),
                )),
            child: Hero(
              tag: 'test-${widget.photo}',
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      filterQuality: FilterQuality.low,
                      image: NetworkImage(widget.photo.toString()),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4), BlendMode.darken)),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  border: Border.all(
                      color: Colors.grey.shade100.withOpacity(0.4), width: 5),
                ),
              ),
            ),
          ),
          SizedBox(
            // height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width - 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Hero(
                  tag: 'test-${widget.title}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        widget.title.toString(),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            backgroundColor:
                                Colors.grey.shade100.withOpacity(0.2),
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Unbounded',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Hero(
                  tag: 'test-${widget.description}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.description.toString(),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OneFullNewsPage extends StatelessWidget {
  String? title;
  String? description;
  String? photo;
  OneFullNewsPage({
    Key? key,
    this.title,
    this.description,
    this.photo,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Row(
                children: [
                  Container(
                      padding: const EdgeInsets.all(16),
                      height: 100,
                      // width: MediaQuery.of(context).size.width * 0.1,
                      child: CircleAvatar(
                        backgroundColor:
                            Colors.purpleAccent.shade100.withOpacity(0.4),
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
                      )),
                ],
              ),
            ),
            Hero(
              tag: 'test-$title',
              child: Material(
                type: MaterialType.transparency,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        backgroundColor: isDark
                            ? Colors.grey.shade100.withOpacity(0.2)
                            : Colors.grey.shade200,
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 15,
                        fontFamily: 'Unbounded',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Hero(
                tag: 'test-$photo',
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(photo.toString(),
                      width: 500, fit: BoxFit.cover),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: 'test-$description',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    description.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class PhotoHero extends StatelessWidget {
//   PhotoHero({super.key, required this.photo, this.onTap, this.width});

//   String photo;
//   VoidCallback? onTap;
//   double? width;

//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width,
//       child: Hero(
//         tag: photo,
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: onTap,
//             child: Image.network(
//               photo.toString(),
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
