import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:foxxi/components/custom_textfield.dart';
import 'package:provider/provider.dart';

import 'package:foxxi/constants.dart';
import 'package:foxxi/models/notification.dart';
import 'package:foxxi/providers/user_provider.dart';
import 'package:foxxi/services/comment_service.dart';
import 'package:foxxi/services/notification_service.dart';
import 'package:foxxi/services/post_service.dart';
import 'package:foxxi/utils.dart';

class AddCommentWidget extends StatelessWidget {
  VoidCallback? notifyPost;
  VoidCallback? notifyComments;
  bool isUpdateComment;
  bool isAddComment;
  bool isAddCommentReply;
  bool isPostUpdate;
  final String? postUsername;
  final List<String>? hashtags;
  final String? commentId;
  final String? postUserId;
  final String? postId;
  AddCommentWidget({
    Key? key,
    this.notifyPost,
    this.notifyComments,
    this.isUpdateComment = false,
    this.isAddComment = false,
    this.isAddCommentReply = false,
    this.isPostUpdate = false,
    this.postUsername,
    this.hashtags,
    this.commentId,
    this.postUserId,
    required this.postId,
  }) : super(key: key);
  final CommentService commentService = CommentService();
  PostService postService = PostService();
  NotificationService notificationService = NotificationService();
  CustomTextField customTextField =
      CustomTextField(hintext: 'An Interesting Reply');
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false).user;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          customTextField,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
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
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          dev.log(customTextField.caption,
                              name: 'custom Textfield text');
                          if (customTextField.caption.isNotEmpty) {
                            if (isAddComment == true) {
                              dev.log('Add Comment Started');
                              int statusCode = await commentService.addComment(
                                  context: context,
                                  postId: postId!,
                                  caption: customTextField.caption);

                              if (userProvider.id != postUserId) {
                                if (context.mounted) {
                                  if (statusCode == 201) {
                                    if (notifyComments != null) {
                                      dev.log('refreshed');
                                      notifyComments!();
                                    }
                                    {
                                      notificationService.addNotification(
                                          context: context,
                                          notification: NotificationModel(
                                              notification: 'commented on your',
                                              notificationType: NotificationType
                                                  .POST_REPLY.name,
                                              userId: postUserId!,
                                              username: userProvider.username,
                                              postId: postId));
                                    }
                                  }
                                }
                              }
                            }
                            if (isAddCommentReply == true) {
                              dev.log('Add ReplyComment Started');
                              if (context.mounted) {
                                commentService
                                    .addCommentReply(
                                        isReply: true,
                                        parentId: commentId!,
                                        context: context,
                                        postId: postId!,
                                        caption: customTextField.caption)
                                    .then((value) {
                                  notifyComments!();
                                });
                              }
                            }
                            if (isUpdateComment == true &&
                                isPostUpdate == false) {
                              dev.log('Update Comment Started');
                              if (context.mounted) {
                                commentService
                                    .updateComment(
                                        context: context,
                                        id: commentId!,
                                        caption: customTextField.caption)
                                    .then((value) {
                                  notifyComments!();
                                });
                              }
                            }
                            if (isPostUpdate == true &&
                                isUpdateComment == false) {
                              dev.log('Update Post Started');
                              if (context.mounted) {
                                postService
                                    .updatePost(
                                        context: context,
                                        id: postId!,
                                        caption: customTextField.caption,
                                        hashtags: hashtags!)
                                    .then((value) {
                                  if (notifyPost != null) {
                                    notifyPost!();
                                  }
                                });
                              }
                            }
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          } else {
                            showSnackBar(context, "Field can't be empty");
                          }
                        },
                        child: Text(isUpdateComment
                            ? 'Update Comment'
                            : isPostUpdate
                                ? 'Post Update'
                                : 'Comment'),
                      ),
                    ]),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
