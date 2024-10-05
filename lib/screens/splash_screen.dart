import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foxxi/components/entry_Point1.dart';
import 'package:foxxi/providers/theme_provider.dart';
import 'package:foxxi/screens/login_screen.dart';
import 'package:foxxi/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'package:rive/rive.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  ThemeMode theme;
  SplashScreen({required this.theme});
  // const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _MyRiveAnimationState();
}

class _MyRiveAnimationState extends State<SplashScreen> {
  AuthService authService = AuthService();

  String id = '';
  Future<bool> isJwtEmpty() async {
    var cookies = await const FlutterSecureStorage().read(key: 'cookies');

    if (cookies != null) {
      return false;
    } else {
      return true;
    }
  }

  void getUserId() async {}

  void getScreen() async {
    if (await isJwtEmpty()) {
      Timer(
          const Duration(milliseconds: 1500),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    } else {
      Timer(
          const Duration(milliseconds: 1500),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const BottomNavBar())));
    }
  }

  @override
  void initState() {
    super.initState();

    getScreen();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: widget.theme==ThemeMode.dark?Colors.grey.shade900:Colors.white,
        child: const Center(
          child: RiveAnimation.asset(
            'lib/assets/foxxiSplash.riv',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
