import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final VoidCallback function;
  bool? isFollowed;
  int? followStatusCode;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  FollowButton(
      {Key? key,
      required this.backgroundColor,
      required this.borderColor,
      this.isFollowed,
      this.followStatusCode,
      required this.textColor,
      required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: const EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: function,
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            height: 27,
            child: Text(
              isFollowed! ? 'Unfollow' : 'Follow',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
    ));
  }
}
