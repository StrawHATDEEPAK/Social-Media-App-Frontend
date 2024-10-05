import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as dev;

import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../screens/profile_screen.dart';

class CustomText extends StatelessWidget {
  final String caption;

  const CustomText({
    Key? key,
    required this.caption,
  }) : super(key: key);

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    List<String> captionElements = caption.split(' ');

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text.rich(TextSpan(
          text: null,
          children: captionElements.map((w) {
            return w.startsWith('@') && w.length > 1
                ? TextSpan(
                    text: ' ${w.replaceAll(':', '')}',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        dev.log(w.replaceAll('[@:]', ''), name: '@ names');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileWidget(
                                isMe: w.replaceAll(RegExp('@:'), '') ==
                                        userProvider.user.username
                                    ? true
                                    : false,
                                username: w.replaceAll(RegExp('[@:]'), '')),
                          ),
                        );
                      },
                  )
                : w.startsWith('http')
                    ? TextSpan(
                        text: w,
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchInBrowser(Uri.parse(w));
                          },
                      )
                    : TextSpan(
                        text: ' $w',
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black),
                      );
          }).toList())),
    );
  }
}
