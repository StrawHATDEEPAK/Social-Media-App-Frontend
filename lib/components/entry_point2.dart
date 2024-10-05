// import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:foxxi/screens/mint_NFT.dart';
import 'package:foxxi/screens/wallet_screen.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../screens/profile_settings.dart';
import '../screens/security_Screen.dart';
import '../screens/tweet_migration.dart';
import 'models/bottom_bar_item_model.dart';
import 'notch_bottom_bar.dart';

class bottomNavBar2 extends StatefulWidget {
  const bottomNavBar2({Key? key}) : super(key: key);

  @override
  State<bottomNavBar2> createState() => _bottomNavBar2State();
}

class _bottomNavBar2State extends State<bottomNavBar2> {
  final _pageController = PageController(initialPage: 0);

  int maxCount = 5;

  /// widget list
  final List<Widget> bottomBarPages = [
    const ProfileSettings(),
    const WalletWeb(),
    mintNFT(),
    const SecuritySettingScreen(),
    TweetMigrationScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(bottomBarPages.length, (index) {
          {
            return bottomBarPages[index];
          }
        }),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              pageController: _pageController,
              color: isDark ? Colors.black : Colors.white,
              notchColor: isDark ? Colors.black54 : Colors.white,
              showLabel: false,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.settings,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.settings,
                    color: Colors.blueAccent,
                  ),
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.wallet,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.wallet,
                    color: Colors.blueAccent,
                  ),
                ),

                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.photo_album_rounded,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.photo_album_rounded,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 2',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.security_rounded,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.security_rounded,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 2',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.move_to_inbox_rounded,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.move_to_inbox_rounded,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 2',
                ),

                ///svg example
                // BottomBarItem(
                //   inActiveItem: SvgPicture.asset(
                //     'assets/search_icon.svg',
                //     color: Colors.blueGrey,
                //   ),
                //   activeItem: SvgPicture.asset(
                //     'assets/search_icon.svg',
                //     color: Colors.white,
                //   ),
                //   itemLabel: 'Page 3',
                // ),
                // const BottomBarItem(
                //   inActiveItem: Icon(
                //     Icons.settings,
                //     color: Colors.blueGrey,
                //   ),
                //   activeItem: Icon(
                //     Icons.settings,
                //     color: Colors.pink,
                //   ),
                //   itemLabel: 'Page 4',
                // ),
                // const BottomBarItem(
                //   inActiveItem: Icon(
                //     Icons.person,
                //     color: Colors.blueGrey,
                //   ),
                //   activeItem: Icon(
                //     Icons.person,
                //     color: Colors.yellow,
                //   ),
                //   itemLabel: 'Page 5',
                // ),
              ],
              onTap: (index) {
                /// control your animation using page controller
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutSine,
                );
              },
            )
          : null,
    );
  }
}
