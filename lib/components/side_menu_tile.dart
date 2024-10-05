import 'package:flutter/material.dart';
import 'package:flutter/src/painting/gradient.dart' as gradient;
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import 'package:foxxi/models/menu.dart';
import 'package:foxxi/providers/theme_provider.dart';

class SideMenuTile extends StatelessWidget {
  const SideMenuTile(
      {super.key,
      required this.menu,
      required this.press,
      required this.riveOnInit,
      required this.selectedMenu});
  final Menu menu;
  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;
  final Menu selectedMenu;

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Column(children: [
      Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            width: selectedMenu == menu ? 288 : 0,
            height: 56,
            left: 0,
            child: Container(),
            // child: Container(
            //   decoration: isDark
            //       ?
            //       : BoxDecoration(
            //           color: Colors.purpleAccent.shade100.withOpacity(0.7),

            //         ),
            // ),
          ),
          ListTile(
            onTap: press,
            leading: SizedBox(
              height: 36,
              width: 36,
              child: RiveAnimation.asset(
                menu.rive.src,
                artboard: menu.rive.artboard,
                onInit: riveOnInit,
              ),
            ),
            title: Text(
              menu.title,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.grey.shade800,
                fontSize: 16,
                fontFamily: 'InstagramSans',
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}
