import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foxxi/providers/navigation_argument_data_provider.dart';
import 'package:foxxi/providers/post_provider.dart';
import 'package:foxxi/providers/story_provider.dart';
import 'package:foxxi/providers/theme_provider.dart';
import 'package:foxxi/providers/user_provider.dart';
import 'package:foxxi/providers/wallet_address.dart';
import 'package:foxxi/router.dart';
import 'package:foxxi/screens/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ((context) => WalletAddressProvider())),
      ChangeNotifierProvider(create: ((context) => UserProvider())),
      ChangeNotifierProvider(create: ((context) => PostProvider())),
      ChangeNotifierProvider(create: ((context) => ThemeProvider())),
      ChangeNotifierProvider(
          create: (context) => ScreenNavigationArgumentProvider()),
      ChangeNotifierProvider(create: ((context) => StoryProvider())),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  late ThemeMode theme;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    readThemeMode();

    super.initState();
  }

  void readThemeMode() {
    Provider.of<ThemeProvider>(context, listen: false)
        .readSavedThemeInstance()
        .then((value) {
      setState(() {
        widget.theme = value;
        Provider.of<ThemeProvider>(context, listen: false).setThemeMode =
            widget.theme;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      darkTheme: MyThemes.darkTheme,
      theme: MyThemes.lightTheme,
      onGenerateRoute: generateRoute,
      themeMode: themeProvider.themeMode,
      home: SplashScreen(theme: widget.theme),
    );
  }
}
