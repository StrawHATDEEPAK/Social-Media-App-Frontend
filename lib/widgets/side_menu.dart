import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/gradient.dart' as gradient;
import 'package:provider/provider.dart';

import 'package:foxxi/components/entry_Point1.dart';
import 'package:foxxi/components/entry_point2.dart';
import 'package:foxxi/models/menu.dart';
import 'package:foxxi/providers/theme_provider.dart';
import 'package:foxxi/providers/user_provider.dart';
import 'package:foxxi/services/auth_service.dart';
import 'package:foxxi/utils/rive_utils.dart';

import '../components/side_menu_tile.dart';
import '../utils.dart';
import 'light_dark_switch.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  Menu selectedSideMenu = sidebarMenus.first;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final userProvider = Provider.of<UserProvider>(context, listen: true).user;

    return Container(
      width: 288,
      height: double.infinity,
      // color: Colors.purpleAccent.shade100.withOpacity(0.65),
      decoration: isDark
          ? BoxDecoration(color: Colors.grey.shade900)
          : BoxDecoration(
              // borderRadius: BorderRadius.only(
              //     bottomLeft: Radius.circular(30),
              //     bottomRight: Radius.circular(30)),
              gradient: gradient.LinearGradient(
                colors: [
                  const Color(0xffec9f05).withOpacity(0.4),
                  const Color(0xffff4e00).withOpacity(0.4),
                ],
                stops: const [0, 1],
                begin: const AlignmentDirectional(1, 0),
                end: const AlignmentDirectional(-1, 0),
              ),
            ),
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: () {},
                      child: Image.network(
                        userProvider.image.toString(),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: CustomLoader(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                              child: Icon(
                            Icons.person_2_rounded,
                            size: 100,
                          ));
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                userProvider.name.toString(),
                style: TextStyle(
                    fontFamily: 'InstagramSans',
                    color: isDark ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '@${userProvider.username.toString()}',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.grey.shade600,
                  fontFamily: 'InstagramSans',
                ),
              ),
            ),
            Text(
              'Browse'.toUpperCase(),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 20,
                fontFamily: 'InstagramSans',
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: DayNightSwitch(
                value: Provider.of<ThemeProvider>(context).isDarkMode,
                // moonImage: AssetImage('assets/moon.png'),
                // sunImage: AssetImage('assets/sun.png'),
                sunColor: Colors.yellow,
                moonColor: Colors.grey,
                dayColor: Colors.yellowAccent.shade100,
                nightColor: Colors.blue.shade900,
                onChanged: (value) {
                  final provider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleTheme(value);
                },
              ),
            ),
            ...sidebarMenus
                .map((menu) => SideMenuTile(
                      menu: menu,
                      selectedMenu: selectedSideMenu,
                      press: () {
                        RiveUtils.changeSMIBoolState(menu.rive.status!);
                        setState(() {
                          selectedSideMenu = menu;
                        });
                        if (selectedSideMenu.title.toLowerCase() == 'home') {
                          Navigator.pushNamed(context, BottomNavBar.routeName);
                        }
                        if (selectedSideMenu.title.toLowerCase() ==
                            'settings') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const bottomNavBar2()));
                        }
                        if (selectedSideMenu.title.toLowerCase() == 'Log Out') {
                          authService.signOut(context: context);
                        }
                      },
                      riveOnInit: (artboard) {
                        menu.rive.status = RiveUtils.getRiveInput(artboard,
                            stateMachineName: menu.rive.stateMachineName);
                      },
                    ))
                .toList(),
            InkWell(
              onTap: () {
                authService.signOut(context: context);
              },
              child: ListTile(
                leading: const SizedBox(
                  height: 36,
                  width: 36,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.logout_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text(
                  'Log Out',
                  style: TextStyle(
                      fontFamily: 'InstagramSans',
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
