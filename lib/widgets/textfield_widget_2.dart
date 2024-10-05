import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class TextFieldWidget2 extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String headingText;
  const TextFieldWidget2({
    Key? key,
    required this.controller,
    this.hintText,
    required this.headingText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            headingText,
            style: TextStyle(
                fontFamily: 'InstagramSans',
                fontSize: 15,
                color: isDark ? Colors.grey.shade100 : Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              // color:isDark?Colors.white:Colors.black,
              border: const OutlineInputBorder(borderSide: BorderSide()),
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}
