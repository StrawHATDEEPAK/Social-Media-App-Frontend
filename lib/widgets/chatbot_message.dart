import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
      required this.text,
      required this.sender,
      this.isImage = false});

  final String text;
  final String sender;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return (sender == 'You')
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: isImage
                      ? AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            text,
                            loadingBuilder: (context, child, loadingProgress) =>
                                loadingProgress == null
                                    ? child
                                    : LoadingAnimationWidget.fourRotatingDots(
                                        color: Colors.white,
                                        size: 50,
                                      ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            text.trim(),
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontFamily: 'InstagramSans', fontSize: 15),
                          ),
                        ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  // color: Colors.green.shade300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.green.shade300,
                  ),
                  child: Text(
                    sender,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  // color: Colors.green.shade300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.red.shade300,
                  ),
                  child: Text(
                    sender,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: isImage
                      ? AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            text,
                            loadingBuilder: (context, child, loadingProgress) =>
                                loadingProgress == null
                                    ? child
                                    : LoadingAnimationWidget.fourRotatingDots(
                                        color: Colors.white,
                                        size: 50,
                                      ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            text.trim(),
                            style: const TextStyle(
                                fontFamily: 'InstagramSans', fontSize: 15),
                          ),
                        ),
                ),
              ],
            ),
          );
  }
}
