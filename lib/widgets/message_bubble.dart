import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart'
    show BubbleType, ChatBubble, ChatBubbleClipper5;
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:foxxi/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(5.0),
        //   child: isMe
        //       ? null
        //       : CircleAvatar(
        //           backgroundImage: NetworkImage(
        //             chat.sender.image.toString(),
        //           ),
        //         ),
        // ),
        Flexible(
          child: ChatBubble(
              clipper: ChatBubbleClipper5(
                  type:
                      isMe ? BubbleType.sendBubble : BubbleType.receiverBubble),
              backGroundColor:
                  !isMe ? const Color(0xffec9f05) : const Color(0xffff4e00),
              alignment: isMe ? Alignment.topRight : Alignment.topLeft,
              margin: const EdgeInsets.only(top: 5),
              child: Linkify(
                options: const LinkifyOptions(humanize: false),
                text: message.toString(),
                style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontFamily: 'InstagramSans'),
                onOpen: (link) async {
                  if (await canLaunchUrl(Uri.parse(link.url))) {
                    await launchUrl(Uri.parse(link.url),
                        mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      showSnackBar(context, 'Cannot Launch URL');
                    }
                  }
                },
                linkStyle: const TextStyle(
                    fontSize: 17,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold),
              )),
        ),
      ],
    );
  }
}
