import 'dart:developer' as dev;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foxxi/components/custom_text.dart';
import 'package:foxxi/screens/profile_screen.dart';
import 'package:foxxi/services/notification_service.dart';
import 'package:foxxi/utils.dart';
import 'package:foxxi/widgets/add_comment.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:foxxi/components/postlikebar.dart';
import 'package:foxxi/models/feed_post_model.dart';
import 'package:foxxi/providers/theme_provider.dart';
import 'package:foxxi/services/post_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../components/pinch_to_zoom.dart';
import '../providers/user_provider.dart';
import '../screens/post_screen.dart';
import '../services/comment_service.dart';

class FeedCard extends StatefulWidget {
  final FeedPostModel post;
  final bool isImage;
  final bool isVideo;
  const FeedCard({
    Key? key,
    required this.post,
    required this.isImage,
    required this.isVideo,
  }) : super(key: key);

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  final commentService = CommentService();
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  NotificationService notificationService = NotificationService();
  PostService postService = PostService();

  @override
  void initState() {
    if (widget.isVideo) {
      _controller =
          VideoPlayerController.network(widget.post.media!.url.toString());
      _initializeVideoPlayerFuture = _controller.initialize();

      _controller.addListener(() {
        if (_controller.value.hasError) {
          dev.log(_controller.value.errorDescription.toString(),
              name: 'Video Player Error');
          dev.log(widget.post.media!.url.toString(), name: 'Video Link');
        }
        if (_controller.value.isInitialized) {
          _controller.setLooping(true);
          setState(() {});
        }
        if (_controller.value.isBuffering) {}
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // @override
  @override
  Widget build(context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    final userProvider = Provider.of<UserProvider>(context, listen: true);

    DateTime datetime = DateTime.parse(widget.post.createdAt);
    final tempDate = DateFormat.yMd().add_jm().format(datetime);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostCard(
              postId: widget.post.id,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: isDark ? Colors.grey.shade700 : Colors.white),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ).copyWith(right: 0),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileWidget(
                                      isMe: widget.post.author.id ==
                                              userProvider.user.id
                                          ? true
                                          : false,
                                      username: widget.post.author.username),
                                ));
                          },
                          child: Card(
                            shape: const CircleBorder(),
                            elevation: 5,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                  widget.post.author.image.toString()),
                              onBackgroundImageError: (exception, stackTrace) =>
                                  const SizedBox(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.post.author.name.toString(),
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white
                                        : Colors.grey.shade900,
                                    fontSize: 15,
                                    fontFamily: 'InstagramSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '@${widget.post.author.username.toString()}',
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          tempDate.toString().replaceFirst(' ', '\n'),
                          style: TextStyle(
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                        true
                            ? IconButton(
                                onPressed: () {
                                  BuildContext dialogContext;
                                  showDialog(
                                    useRootNavigator: false,
                                    context: context,
                                    builder: (context) {
                                      dialogContext = context;
                                      return Dialog(
                                        backgroundColor: const Color.fromARGB(
                                            255, 238, 189, 91),
                                        child: ListView(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shrinkWrap: true,
                                          children: [
                                            widget.post.author.id ==
                                                    userProvider.user.id
                                                ? 'Delete Post'
                                                : null,
                                            widget.post.author.id ==
                                                    userProvider.user.id
                                                ? null
                                                : 'Repost Post',
                                            widget.post.author.id ==
                                                    userProvider.user.id
                                                ? null
                                                : 'Report Post',
                                            widget.post.author.id ==
                                                    userProvider.user.id
                                                ? 'Update Post'
                                                : null,
                                          ]
                                              .map(
                                                (e) => InkWell(
                                                    child: Container(
                                                      padding: e == null
                                                          ? null
                                                          : const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 12,
                                                              horizontal: 16),
                                                      child: e == null
                                                          ? null
                                                          : Text(e.toString()),
                                                    ),
                                                    onTap: () {
                                                      dev.log(
                                                          '$e Button Pressed',
                                                          name:
                                                              'FeedPostCard  button');
                                                      if (e == 'Delete Post') {
                                                        postService
                                                            .deletePost(
                                                                context:
                                                                    context,
                                                                id: widget
                                                                    .post.id
                                                                    .toString())
                                                            .then((value) {
                                                          Navigator.pop(
                                                              dialogContext);
                                                        });
                                                      }
                                                      if (e == 'Repost Post') {
                                                        postService
                                                            .repostPost(
                                                                id: widget
                                                                    .post.id,
                                                                context:
                                                                    context)
                                                            .then((value) {
                                                          Navigator.pop(
                                                              dialogContext);
                                                        });
                                                      }
                                                      if (e == 'Report Post') {
                                                        postService
                                                            .reportPost(
                                                                id: widget
                                                                    .post.id,
                                                                context:
                                                                    context)
                                                            .then((value) {
                                                          Navigator.pop(
                                                              dialogContext);
                                                        });
                                                      }

                                                      if (e == 'Update Post') {
                                                        Navigator.pop(
                                                            dialogContext);
                                                        showMaterialModalBottomSheet<
                                                            void>(
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.vertical(
                                                                      top: Radius
                                                                          .circular(
                                                                              25))),
                                                          context: context,
                                                          builder: (context) =>
                                                              Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                      'Update Post',
                                                                      style: TextStyle(
                                                                          color: isDark
                                                                              ? Colors
                                                                                  .grey.shade400
                                                                              : Colors
                                                                                  .black,
                                                                          fontFamily:
                                                                              'InstagramSans',
                                                                          fontSize:
                                                                              25,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8),
                                                                      child:
                                                                          CircleAvatar(
                                                                        radius:
                                                                            16,
                                                                        backgroundImage: NetworkImage(widget
                                                                            .post
                                                                            .author
                                                                            .image
                                                                            .toString()),
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 8),
                                                                              child: Text(
                                                                                widget.post.author.name.toString(),
                                                                                style: TextStyle(
                                                                                  color: isDark ? Colors.grey.shade200 : Colors.black,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 4.0),
                                                                              child: Text(
                                                                                '@${widget.post.author.username}',
                                                                                style: TextStyle(
                                                                                  color: isDark ? Colors.grey.shade600 : Colors.black,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        const Padding(
                                                                          padding:
                                                                              EdgeInsets.only(
                                                                            left:
                                                                                8,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: const [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              8.0),
                                                                      child: Text(
                                                                          'Your Reply'),
                                                                    ),
                                                                  ],
                                                                ),
                                                                AddCommentWidget(
                                                                  isPostUpdate:
                                                                      true,
                                                                  hashtags: widget
                                                                      .post
                                                                      .hashtags,
                                                                  postUserId:
                                                                      widget
                                                                          .post
                                                                          .author
                                                                          .id,
                                                                  postId: widget
                                                                      .post.id,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }),
                                              )
                                              .toList(),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.more_vert),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText(caption: widget.post.caption),
                    ),
                  ),
                  widget.isImage
                      ? Container(
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular((30))),
                            // border: Border(
                            //     bottom: BorderSide(color: Colors.black.withOpacity(1))),
                          ),
                          child: Stack(
                            children: [
                              PinchZoom(
                                resetDuration:
                                    const Duration(milliseconds: 100),
                                maxScale: 3,
                                child: ClipRRect(
                                  child: Image.network(
                                    widget.post.media!.url.toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // child: DecoratedBox(
                              //   decoration: BoxDecoration(
                              //     borderRadius: const BorderRadius.only(
                              //         bottomLeft: Radius.circular(30),
                              //         bottomRight: Radius.circular((30))),
                              //     // border: Border(
                              //     //     bottom: BorderSide(color: Colors.black.withOpacity(1))),
                              //     image: DecorationImage(
                              //       image: NetworkImage(
                              //           widget.post.media!.url.toString()),
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ),
                              // ),

                              PostLikeCommentBar(
                                post: widget.post,
                                isImage: true,
                                isVideo: false,
                              )
                            ],
                          ),
                        )
                      // ? Container(
                      //     height: 400,
                      //     width: MediaQuery.of(context).size.width - 20,
                      //     decoration: BoxDecoration(
                      //       borderRadius: const BorderRadius.only(
                      //           bottomLeft: Radius.circular(30),
                      //           bottomRight: Radius.circular((30))),
                      //       // border: Border(
                      //       //     bottom: BorderSide(color: Colors.black.withOpacity(1))),
                      //       image: DecorationImage(
                      //         image: NetworkImage(
                      //             widget.post.media!.url.toString()),
                      //         fit: BoxFit.cover,
                      //       ),
                      //     ),
                      //     child: PostLikeCommentBar(post: widget.post,isImage: true,isVideo: false,))
                      : widget.isVideo
                          ? Container(
                              height: 370,
                              width: MediaQuery.of(context).size.width - 20,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                // border: Border(
                                //     bottom: BorderSide(color: Colors.black.withOpacity(1))),
                              ),
                              child: FutureBuilder(
                                future: _initializeVideoPlayerFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Stack(
                                      children: [
                                        Container(
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))),
                                            height: 370,
                                            width: 400,
                                            child: VideoPlayer(_controller)),
                                        Positioned(
                                          top: 250,
                                          left: 10,
                                          child: FloatingActionButton(
                                            heroTag: widget.post.id,
                                            onPressed: () {
                                              setState(() {
                                                if (_controller
                                                    .value.isPlaying) {
                                                  _controller.pause();
                                                } else {
                                                  _controller.play();
                                                }
                                              });
                                            },
                                            child: Icon(
                                              _controller.value.isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                            ),
                                          ),
                                        ),
                                        PostLikeCommentBar(
                                          post: widget.post,
                                          isImage: false,
                                          isVideo: true,
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const Center(
                                      child: CustomLoader(),
                                    );
                                  }
                                },
                              ),
                            )
                          : const SizedBox(),
                  widget.isImage == false && widget.isVideo == false
                      ? PostLikeCommentBar(
                          post: widget.post,
                          isImage: false,
                          isVideo: false,
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
