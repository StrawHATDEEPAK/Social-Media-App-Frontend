import 'package:flutter/material.dart';
import 'package:foxxi/providers/theme_provider.dart';
import 'package:foxxi/providers/user_provider.dart';
import 'package:foxxi/screens/chat.dart';
import 'package:provider/provider.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final userProvider = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    Colors.grey.shade600,
                    Colors.grey.shade900,
                  ]
                : [
                    const Color(0xffff4e00).withOpacity(0.4),
                    const Color(0xffec9f05).withOpacity(0.4),
                  ],
            stops: const [0, 1],
            begin: const AlignmentDirectional(1, 0),
            end: const AlignmentDirectional(-1, 0),
            // color: Colors.purpleAccent.shade100.withOpacity(
            // 0.3,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(16),
                    height: 100,
                    // width: MediaQuery.of(context).size.width * 0.1,
                    child: CircleAvatar(
                      backgroundColor: const Color(0xffff4e00).withOpacity(0.4),
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
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, right: 10, top: 5),
              child: ListTile(
                trailing: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(userProvider.image.toString()),
                ),
                leading: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProvider.name,
                        style: TextStyle(
                          fontFamily: 'Unbounded',
                          color: isDark ? Colors.grey.shade500 : Colors.black38,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        '@${userProvider.username.toLowerCase()}',
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.black38,
                          fontSize: 15,
                          fontFamily: 'Unbounded',
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ChatScreen(
              userName: userProvider.username.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
