import 'package:flutter/material.dart';
import 'package:foxxi/components/custom_text.dart';
import 'package:foxxi/components/postlikebar.dart';
import 'package:foxxi/providers/user_provider.dart';
import 'package:foxxi/screens/profile_screen.dart';
import 'package:foxxi/services/comment_service.dart';
import 'package:foxxi/services/post_service.dart';
import 'package:foxxi/utils.dart';
import 'package:foxxi/widgets/add_comment.dart';
import 'package:foxxi/widgets/comment_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

import '../models/comments.dart';
import '../models/feed_post_model.dart';
import '../providers/theme_provider.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class PostCard extends StatefulWidget {
  final String postId;

  const PostCard({
    Key? key,
    required this.postId,
  }) : super(key: key);

  // const PostCard({super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  FeedPostModel? post;
  bool isImage = false;
  bool isVideo = false;
  final postService = PostService();
  final commentService = CommentService();
  final TextEditingController _commentTextController = TextEditingController();
  VideoPlayerController? _controller;
  late Future<List<Comment>> _comments;
  List<Comment> filteredCommentList = [];
  @override
  void initState() {
    getPostData();
    super.initState();
  }

  Future<void> getPostData() async {
    postService.getPostById(context: context, id: widget.postId).then((value) {
      setState(() {
        post = value;
      });

      if (post != null) {
        if (post!.media?.mediatype == 'image') {
          isImage = true;
        }

        if (post!.media?.mediatype == 'video') {
          isVideo = true;
          initializeVideo();
        }
        getComments();
      }
    });
    return;
  }

  void initializeVideo() {
    _controller = VideoPlayerController.network(post!.media!.url.toString())
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      });

    if (_controller!.value.isInitialized) {
      _controller!.setLooping(true);
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _commentTextController.dispose();
    if (_controller != null) {
      _controller!.dispose();
    }
  }

  void getComments() async {
    if (post != null) {
      _comments = commentService.getCommentByPostId(
          context: context, id: post!.id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true).user;
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    if (post != null) {
      DateTime datetime = DateTime.parse(post!.createdAt);
      final tempDate = DateFormat.yMd().add_jm().format(datetime);

      return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor:
                  isDark ? Colors.grey.shade900 : Colors.grey.shade100,
              child: IconButton(
                // iconSize: 20,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xffff4e00),
                  // size: 15,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        ),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        body: RefreshIndicator(
          onRefresh: getPostData,
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [],
                  ),
                  Container(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color:
                                isDark ? Colors.grey.shade900 : Colors.white),
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
                                    Card(
                                      shape: const CircleBorder(),
                                      elevation: 5,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundImage: NetworkImage(
                                            post!.author.image.toString()),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (post!.author.username !=
                                                userProvider.username) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfileWidget(
                                                              isMe: false,
                                                              username: post!
                                                                  .author
                                                                  .username)));
                                            }
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                post!.author.name.toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                              Text(
                                                "@${post!.author.username}",
                                                style: TextStyle(
                                                    color: isDark
                                                        ? Colors.grey
                                                        : Colors.grey[300]),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      tempDate
                                          .toString()
                                          .replaceFirst(' ', '\n'),
                                      style: TextStyle(color: Colors.grey[300]),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        BuildContext dialogContext;
                                        showDialog(
                                          useRootNavigator: false,
                                          context: context,
                                          builder: (context) {
                                            dialogContext = context;
                                            return Dialog(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 238, 189, 91),
                                              child: ListView(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 16),
                                                  shrinkWrap: true,
                                                  children: [
                                                    post!.author.id ==
                                                            userProvider.id
                                                        ? 'Delete Post'
                                                        : null,
                                                    post!.author.id !=
                                                            userProvider.id
                                                        ? null
                                                        : 'Repost Post',
                                                    post!.author.id ==
                                                            userProvider.id
                                                        ? null
                                                        : 'Report Post',
                                                    post!.author.id ==
                                                            userProvider.id
                                                        ? 'Update Post'
                                                        : null,
                                                  ]
                                                      .map(
                                                        (e) => InkWell(
                                                            child: Container(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 12,
                                                                  horizontal:
                                                                      16),
                                                              child: null,
                                                            ),
                                                            onTap: () {
                                                              if (e ==
                                                                  'Report Post') {
                                                                postService
                                                                    .reportPost(
                                                                        id: post!
                                                                            .id,
                                                                        context:
                                                                            context);
                                                              }

                                                              if (e ==
                                                                  'Repost Post') {
                                                                postService
                                                                    .repostPost(
                                                                        context:
                                                                            context,
                                                                        id: post!
                                                                            .id);
                                                              }

                                                              if (e ==
                                                                  'Update Post') {
                                                                Navigator.pop(
                                                                    dialogContext);
                                                                showMaterialModalBottomSheet<
                                                                    void>(
                                                                  shape: const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.vertical(
                                                                              top: Radius.circular(25))),
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          Padding(
                                                                    padding: EdgeInsets.only(
                                                                        bottom: MediaQuery.of(context)
                                                                            .viewInsets
                                                                            .bottom),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child: Text(
                                                                              'Update Post',
                                                                              style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.black, fontFamily: 'InstagramSans', fontSize: 25, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8),
                                                                              child: CircleAvatar(
                                                                                radius: 16,
                                                                                backgroundImage: NetworkImage(post!.author.image.toString()),
                                                                              ),
                                                                            ),
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: 8),
                                                                                      child: Text(
                                                                                        post!.author.name.toString(),
                                                                                        style: TextStyle(
                                                                                          color: isDark ? Colors.grey.shade200 : Colors.black,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: 4.0),
                                                                                      child: Text(
                                                                                        '@${post!.author.username}',
                                                                                        style: TextStyle(
                                                                                          color: isDark ? Colors.grey.shade600 : Colors.black,
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                const Padding(
                                                                                  padding: EdgeInsets.only(
                                                                                    left: 8,
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: const [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(left: 8.0),
                                                                              child: Text('Your Reply'),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        AddCommentWidget(
                                                                          notifyPost:
                                                                              getPostData,
                                                                          isPostUpdate:
                                                                              true,
                                                                          hashtags:
                                                                              post!.hashtags,
                                                                          postUserId: post!
                                                                              .author
                                                                              .id,
                                                                          postId:
                                                                              post!.id,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              Navigator.pop(
                                                                  dialogContext);
                                                            }),
                                                      )
                                                      .toList()),
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomText(caption: post!.caption),
                              ),
                              isImage == false && isVideo == false
                                  ? PostLikeCommentBar(
                                      notifyComments: getComments,
                                      post: post!,
                                      isImage: true,
                                      isVideo: false,
                                    )
                                  : const SizedBox(),
                              isImage
                                  ? Container(
                                      height: 400,
                                      width: MediaQuery.of(context).size.width -
                                          20,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(30)),
                                        // border: Border(
                                        //     bottom: BorderSide(color: Colors.black.withOpacity(1))),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              post!.media!.url.toString()),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: PostLikeCommentBar(
                                        notifyComments: getComments,
                                        post: post!,
                                        isImage: true,
                                        isVideo: false,
                                      ))
                                  : isVideo
                                      ? Container(
                                          height: 400,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              20,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            // border: Border(
                                            //     bottom: BorderSide(color: Colors.black.withOpacity(1))),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Stack(
                                                children: [
                                                  _controller!
                                                          .value.isInitialized
                                                      ? Container(
                                                          decoration: const BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          30))),
                                                          height: 330,
                                                          width: 400,
                                                          child: VideoPlayer(
                                                              _controller!))
                                                      : Container(),
                                                  Positioned(
                                                    top: 270,
                                                    left: 10,
                                                    child: FloatingActionButton(
                                                      onPressed: () {
                                                        setState(
                                                          () {
                                                            _controller!.value
                                                                    .isPlaying
                                                                ? _controller!
                                                                    .pause()
                                                                : _controller!
                                                                    .play();
                                                          },
                                                        );
                                                      },
                                                      child: Icon(
                                                        _controller!
                                                                .value.isPlaying
                                                            ? Icons.pause
                                                            : Icons.play_arrow,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              PostLikeCommentBar(
                                                  notifyComments: getComments,
                                                  post: post!,
                                                  isVideo: true,
                                                  isImage: false),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Comments',
                            style: TextStyle(
                                fontFamily: 'InstagramSans',
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 20),
                          ),
                        ),
                        FutureBuilder<List<Comment>>(
                            future: _comments,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                filteredCommentList = snapshot.data!
                                    .where(
                                      (element) => element.isReply == false,
                                    )
                                    .toList();
                                return Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).padding.top),
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: ListView.builder(
                                      physics: const ScrollPhysics(),
                                      shrinkWrap: true,
                                      reverse: true,
                                      itemCount: filteredCommentList.length,
                                      itemBuilder: ((context, index) {
                                        // dev.log(snapshot.data![index].isReply
                                        //         .toString() +
                                        //     " " +
                                        //     snapshot.data![index].id +
                                        //     " " +
                                        //     snapshot.data![index].parentId
                                        //         .toString());

                                        return CommentCard(
                                          post: post!,
                                          notifyPost: getPostData,
                                          notifyComment: getComments,
                                          comment: filteredCommentList[index],
                                        );
                                      }),
                                    ),
                                  ),
                                );
                              } else {
                                return const Center(child: CustomLoader());
                              }
                            })
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        body: const Center(
          child: CustomLoader(),
        ),
      );
    }
  }
}
