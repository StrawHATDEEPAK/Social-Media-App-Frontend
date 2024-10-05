import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:foxxi/providers/theme_provider.dart';

void showSnackBar(BuildContext context, String text) {
  // dev.log(text, name: "Response Body");
  final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

  Fluttertoast.showToast(
      msg: text, backgroundColor: isDark ? Colors.black : Colors.white);
}

class Items {
  static const items = [
    'Your Feed',
    'Trending',
    'Foxxi Trends',
  ];

  static const List<IconData> icons = [
    Icons.trending_up_outlined,
    Icons.local_fire_department,
    Icons.person_outline_sharp,
  ];
}

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.twistingDots(
        size: 30,
        leftDotColor: const Color(0xffff4e00),
        rightDotColor: const Color(0xffec9f05));
  }
}
