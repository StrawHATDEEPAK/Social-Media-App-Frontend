import 'package:flutter/material.dart';
import 'package:foxxi/routing_constants.dart';
import 'package:foxxi/services/user_service.dart';
import 'package:foxxi/utils.dart';
import 'package:foxxi/widgets/textfield_widget_2.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class AirDropScreen extends StatelessWidget {
  static const String routeName = airdropScreenRoute;
  AirDropScreen({super.key});
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _walletAddressTextController =
      TextEditingController();
  final TextEditingController _messageTextController = TextEditingController();
  final UserService userService = UserService();
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.purpleAccent.shade100.withOpacity(0.4),
            child: IconButton(
              // iconSize: 20,
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                // size: 15,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
      ),
      body: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'AirDrop',
              style: TextStyle(
                  fontSize: 50,
                  color: isDark ? Colors.grey.shade100 : Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Send us your Email Address, Wallet Address and a Optional Message to receive your free tokens',
                style: TextStyle(
                    color: isDark ? Colors.grey.shade100 : Colors.black),
              ),
            ),
            TextFieldWidget2(
              controller: _emailTextController,
              headingText: 'Email Address*',
            ),
            TextFieldWidget2(
                controller: _walletAddressTextController,
                headingText: 'Wallet Address*'),
            TextFieldWidget2(
                controller: _messageTextController, headingText: 'Message'),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  if (_emailTextController.text.isEmpty ||
                      _walletAddressTextController.text.isEmpty) {
                    showSnackBar(context, 'Fill the Required Fields');
                  } else {
                    userService.requestAirdrop(
                        context: context,
                        email: _emailTextController.text,
                        walletAddress: _walletAddressTextController.text,
                        message: _messageTextController.text);
                  }
                },
                child: const Text('Send Email'))
          ],
        )
      ]),
    );
  }
}
