import 'dart:developer' as dev;
import 'dart:ui';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:foxxi/components/donate_button.dart';
import 'package:foxxi/constants.dart';
import 'package:foxxi/models/feed_post_model.dart';
import 'package:foxxi/models/notification.dart';
import 'package:foxxi/providers/theme_provider.dart';
import 'package:foxxi/providers/user_provider.dart';
import 'package:foxxi/screens/chat.dart';
import 'package:foxxi/services/notification_service.dart';
import 'package:foxxi/services/post_service.dart';
import 'package:foxxi/utils.dart';
import 'package:foxxi/widgets/add_comment.dart';

class PostLikeCommentBar extends StatefulWidget {
  VoidCallback? notifyComments;
  final FeedPostModel post;
  final bool isImage;
  final bool isVideo;

  PostLikeCommentBar({
    Key? key,
    this.notifyComments,
    required this.post,
    required this.isImage,
    required this.isVideo,
  }) : super(key: key);

  @override
  State<PostLikeCommentBar> createState() => _PostLikeCommentBarState();
}

class _PostLikeCommentBarState extends State<PostLikeCommentBar> {
  final PostService postService = PostService();

  final NotificationService notificationService = NotificationService();
  bool isLiked = false;
  int? likes;
  @override
  void initState() {
    super.initState();
    isPostLikedByUser();
    setLikes();
  }

  // void getlikes() {
  //   postService.getPostById(context: context, id: widget.post.id).then((value) {
  //     setState(() {
  //       if (value?.likes?.length != null) {
  //         likes = value!.likes!.length;
  //       }
  //     });
  //   });
  // }

  void isPostLikedByUser() {
    if (widget.post.likes != null) {
      if (widget.post.likes!.contains(
          Provider.of<UserProvider>(context, listen: false).user.id)) {
        setState(() {
          isLiked = true;
        });
      } else {
        setState(() {
          isLiked = false;
        });
      }
    }
  }

  void setLikes() {
    likes = widget.post.likes?.length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context, listen: true).isDarkMode;
    final userProvider = Provider.of<UserProvider>(context, listen: true).user;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 3,
              sigmaY: 3,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                gradient: LinearGradient(
                  colors: [
                    widget.isImage || widget.isVideo
                        ? const Color(0xffec9f05).withOpacity(0.4)
                        : const Color(0xffec9f05).withOpacity(0.4),
                    widget.isImage || widget.isVideo
                        ? const Color(0xffff4e00).withOpacity(0.4)
                        : const Color(0xffff4e00).withOpacity(0.4),
                  ],
                  stops: const [0, 4],
                  begin: const AlignmentDirectional(1, 0),
                  end: const AlignmentDirectional(-1, 0),
                  // color: Colors.purpleAccent.shade100.withOpacity(
                  // 0.3,
                ),
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: badges.Badge(
                      badgeAnimation: const badges.BadgeAnimation.size(),
                      badgeStyle: const badges.BadgeStyle(
                          badgeColor: Color(0xffec9f05)),
                      badgeContent: widget.post.likes?.length == null
                          ? const Text('0')
                          : Text(likes.toString()),
                      child: Icon(
                        Icons.favorite_rounded,
                        size: 30,
                        color: isLiked
                            ? Colors.red
                            : isDark
                                ? const Color(0xffff4e00).withOpacity(0.7)
                                : widget.isImage
                                    ? const Color(0xffec9f05).withOpacity(0.8)
                                    : const Color(0xffec9f05).withOpacity(0.8),
                      ),
                    ),
                    onPressed: () {
                      if (userProvider.id != widget.post.author.id) {
                        postService
                            .likePost(
                                context: context, id: widget.post.id.toString())
                            .then((value) {
                          if (isLiked) {
                            setState(() {
                              isLiked = false;
                              likes = likes! - 1;
                            });
                            notificationService.addNotification(
                                context: context,
                                notification: NotificationModel(
                                    notification: ' liked your',
                                    notificationType:
                                        NotificationType.POST_LIKE.name,
                                    userId: widget.post.author.id,
                                    username: userProvider.username));
                          } else {
                            setState(() {
                              isLiked = true;

                              if (likes == 0) {
                                likes = 1;
                              } else {
                                likes = likes! + 1;
                              }
                            });
                          }
                        });
                      } else {
                        showSnackBar(context, 'You Cannot like your own post');
                      }
                    },
                  ),
                  IconButton(
                    icon: badges.Badge(
                      badgeStyle: const badges.BadgeStyle(
                          badgeColor: Color(0xffec9f05)),
                      badgeContent: widget.post.comments?.length == null
                          ? const Text('0')
                          : Text(widget.post.comments!.length.toString()),
                      child: Icon(Icons.comment_rounded,
                          color: isDark
                              ? const Color(0xffff4e00).withOpacity(0.7)
                              : widget.isImage
                                  ? const Color(0xffec9f05).withOpacity(0.8)
                                  : const Color(0xffec9f05).withOpacity(0.8),
                          size: 30),
                    ),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25))),
                        context: context,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Reply',
                                    style: TextStyle(
                                        color: isDark
                                            ? Colors.grey.shade400
                                            : Colors.black,
                                        fontFamily: 'InstagramSans',
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundImage: NetworkImage(
                                          widget.post.author.image.toString()),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                              widget.post.author.name
                                                  .toString(),
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.grey.shade200
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0),
                                            child: Text(
                                              '@${widget.post.author.username}',
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.grey.shade600
                                                    : Colors.black,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text('Your Reply'),
                                  ),
                                ],
                              ),
                              AddCommentWidget(
                                notifyComments: widget.notifyComments,
                                isAddComment: true,
                                postUsername: widget.post.author.username,
                                postId: widget.post.id,
                                postUserId: widget.post.author.id,
                              ),
                              const SizedBox(
                                height: 100,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  widget.post.author.id != userProvider.id
                      ? IconButton(
                          icon: Icon(
                            Icons.send_rounded,
                            color: isDark
                                ? const Color(0xffff4e00).withOpacity(0.7)
                                : widget.isImage
                                    ? const Color(0xffec9f05).withOpacity(0.8)
                                    : const Color(0xffec9f05).withOpacity(0.8),
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OneOneChatScreen(
                                          senderId: widget.post.author.id,
                                          senderUsername:
                                              widget.post.author.username,
                                        )));
                          })
                      : const SizedBox(),
                  widget.post.author.id != userProvider.id
                      ? DonateButton(post: widget.post)
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
